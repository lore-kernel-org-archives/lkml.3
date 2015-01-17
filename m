Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbbAQKMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:12:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbAQKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:12:34 -0500
Date: Sat, 17 Jan 2015 02:11:49 -0800
From: tip-bot for Alexey Brodkin <tipbot@zytor.com>
Message-ID: <tip-db1806edcfef007d9594435a331dcf7e7f1b8fac@git.kernel.org>
Cc: Vineet.Gupta1@synopsys.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, bp@suse.de,
        peterz@infradead.org, mingo@kernel.org, acme@redhat.com,
        abrodkin@synopsys.com, jolsa@kernel.org, dev@codyps.com
Reply-To: mingo@kernel.org, acme@redhat.com, abrodkin@synopsys.com,
        jolsa@kernel.org, dev@codyps.com, Vineet.Gupta1@synopsys.com,
        tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, bp@suse.de, peterz@infradead.org
In-Reply-To: <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
References: <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix statfs.f_type data type mismatch build error with uclibc
Git-Commit-ID: db1806edcfef007d9594435a331dcf7e7f1b8fac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db1806edcfef007d9594435a331dcf7e7f1b8fac
Gitweb:     http://git.kernel.org/tip/db1806edcfef007d9594435a331dcf7e7f1b8fac
Author:     Alexey Brodkin <abrodkin@synopsys.com>
AuthorDate: Sat, 10 Jan 2015 16:40:50 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:29 -0300

perf tools: Fix statfs.f_type data type mismatch build error with uclibc

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
index a74fba6..86ea2d7 100644
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
index 65d9be3..128ef63 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -79,7 +79,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long)st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
