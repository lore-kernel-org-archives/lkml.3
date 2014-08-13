Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaHMRD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:03:58 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:48521 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaHMRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:03:57 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Cody P Schafer <dev@codyps.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: fix type mismatch - long vs __statfs_word
Date: Wed, 13 Aug 2014 21:03:49 +0400
Message-Id: <1407949429-25421-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From "include/uapi/asm-generic/statfs.h" it is seen that "statfs.f_type" is of
type "__statfs_word" which in its turn is "__u32" (unsigned int) for 32-bit
systems.

So in case of compilation with "-Werror" following breakage happens:
--->---
fs.c: In function ‘fs__valid_mount’:
fs.c:76:24: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
  else if (st_fs.f_type != magic)
                        ^
cc1: all warnings being treated as errors
--->---

Note that now when fs.c is in "lib/api/fs" and in "tools/lib/api/Makefile"
CFLAGS has hard-coded "-Werror" this is inevitable even if one builds "perf"
with "WERROR=0".

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index c1b49c3..4b2fa7b 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -75,7 +75,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long)st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
-- 
1.9.3

