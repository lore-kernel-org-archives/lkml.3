Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbbAMNn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:43:58 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52348 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbAMNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:43:56 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>, <jolsa@kernel.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <dev@codyps.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 1/5] perf tools: [uclibc] fix statfs.f_type data type mismatch build error
Date: Tue, 13 Jan 2015 19:13:20 +0530
Message-ID: <1421156604-30603-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <abrodkin@synopsys.com>

ARC Linux uses the no legacy syscalls abi and corresponding uClibc headers
statfs defines f_type to be U32 which causes perf build breakage

http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common-generic/bits/statfs.h

   ----------->8---------------
  CC       fs/fs.o
fs/fs.c: In function 'fs__valid_mount':
fs/fs.c:82:24: error: comparison between signed and unsigned integer
expressions [-Werror=sign-compare]
  else if (st_fs.f_type != magic)
                        ^
cc1: all warnings being treated as errors
   ----------->8---------------

Cc: Borislav Petkov <bp@suse.de>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

---
v4:
 * Add Ack from Jiri Olsa

v3: Changes since v2 [2]
 * Made Changelog a bit more concise, no code changes [vgupta]

v2: Changes since v1 [1]
 * Added type cast to DEBUGFS_MAGIC in "debugfs.c" [Arnaldo]
 * Added verbose explanation of root cause

[2] https://lkml.org/lkml/2014/9/16/296
[1] https://lkml.org/lkml/2014/8/13/529

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/lib/api/fs/debugfs.c | 2 +-
 tools/lib/api/fs/fs.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6d7743..93aa4cd2416f 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -67,7 +67,7 @@ int debugfs_valid_mountpoint(const char *debugfs)
 
 	if (statfs(debugfs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+	else if ((long) st_fs.f_type != (long) DEBUGFS_MAGIC)
 		return -ENOENT;
 
 	return 0;
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 65d9be3f9887..15e64921ea84 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -79,7 +79,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long) st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
-- 
1.9.1

