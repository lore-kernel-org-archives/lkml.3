Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaIPPQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:16:43 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:40361 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaIPPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:16:42 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Cody P Schafer <dev@codyps.com>
Subject: [PATCH v2] perf tools: fix type mismatch - long vs __statfs_word
Date: Tue, 16 Sep 2014 19:16:29 +0400
Message-Id: <1410880589-22531-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of compilation with "-Wextra" following breakage happens:
--->---
fs.c: In function ‘fs__valid_mount’:
fs.c:76:24: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
  else if (st_fs.f_type != magic)
                        ^
cc1: all warnings being treated as errors
--->---

Note that now when fs.c is in "lib/api/fs" and in "tools/lib/api/Makefile"
CFLAGS has hard-coded "-Wextra" this is inevitable even if one builds "perf"
with "WERROR=0".

Even though "debugfs.c" gets compiled successfully because DEBUGFS_MAGIC is
definitely positive (MSB bit is not set, so compiler doesn't care about
explisit cast to "long") it's good to cast "st_fs.f_type" to "long" as well.

And here's an explanation of observed issue.

Perf tools use libc headers instead of ones from kernel source tree.
This is because "perf" is just a user-space tool even thought its sources are
merged in Linux kernel source tree.
And so "statfs.h" comes from either uClibc, glibc or musl.

In case of uClibc most of architectures use "legacy" version from here:
http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common/bits/statfs.h

New UAPI compliant architectures (looks like for now it's only ARC) uses UAPI
version of "statfs.h" from here:
http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common-generic/bits/statfs.h

In this particular situation most interesting difference is in data type used
for "struct statfs" member "f_type".

In "legacy" version it's:
--->---
__SWORD_TYPE f_type;
--->---

In UAPI version it's:
--->---
__U32_TYPE f_type;
--->---

In its turn mentioned types are defined in
http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common/bits/types.h
this way:
--->---
...
--->---

And for 32-bit architectures "int" is of the same length as "long" so compiler
is happy on data type check.

But if "f_type" is "unsigned int" it's definitely not an unsigned "long".

Essential fix is explicit casting of "f_type" to "long".

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

Changes in v2:

 * Added type cast to DEBUGFS_MAGIC in "debugfs.c"
 * Added verbose explanation of root cause

Thanks a lot to Arnaldo for mention of another instance of hidden missing
cast in "debugfs.c".

---
 tools/lib/api/fs/debugfs.c | 2 +-
 tools/lib/api/fs/fs.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6..93aa4cd 100644
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
index c1b49c3..a9fd78b 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -75,7 +75,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long) st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
-- 
1.9.3

