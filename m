Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbbAPVYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:24:37 -0500
Received: from mail.kernel.org ([198.145.29.136]:54201 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981AbbAPVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:23:11 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Brodkin <abrodkin@synopsys.com>,
        Borislav Petkov <bp@suse.de>, Cody P Schafer <dev@codyps.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf tools: Fix statfs.f_type data type mismatch build error with uclibc
Date: Fri, 16 Jan 2015 18:22:37 -0300
Message-Id: <1421443362-10709-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
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

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Link: http://lkml.kernel.org/r/1420888254-17504-2-git-send-email-vgupta@synopsys.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/debugfs.c | 2 +-
 tools/lib/api/fs/fs.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6d7743..86ea2d7b8845 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -67,7 +67,7 @@ int debugfs_valid_mountpoint(const char *debugfs)
 
 	if (statfs(debugfs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+	else if ((long)st_fs.f_type != (long)DEBUGFS_MAGIC)
 		return -ENOENT;
 
 	return 0;
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 65d9be3f9887..128ef6332a6b 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -79,7 +79,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long)st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
-- 
1.9.3

