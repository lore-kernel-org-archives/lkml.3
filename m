Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3JIAPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60574 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3JIAP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:28 -0400
Date: Wed, 09 Oct 2013 01:15:27 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 08/13] aout: switch to dump_emit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThR1-0002xp-Np@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/ia32/ia32_aout.c |   20 ++++++++------------
 fs/binfmt_aout.c          |    7 +++----
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 80361c0..9e26e9e 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -133,14 +133,6 @@ static void set_brk(unsigned long start, unsigned long end)
 
 #include <linux/coredump.h>
 
-#define DUMP_WRITE(addr, nr)			     \
-	if (!dump_write(cprm->file, (void *)(addr), (nr))) \
-		goto end_coredump;
-
-#define DUMP_SEEK(offset)		\
-	if (!dump_seek(cprm->file, offset))	\
-		goto end_coredump;
-
 #define START_DATA(u)	(u.u_tsize << PAGE_SHIFT)
 #define START_STACK(u)	(u.start_stack)
 
@@ -192,22 +184,26 @@ static int aout_core_dump(struct coredump_params *cprm)
 
 	set_fs(KERNEL_DS);
 	/* struct user */
-	DUMP_WRITE(&dump, sizeof(dump));
+	if (!dump_emit(cprm, &dump, sizeof(dump)))
+		goto end_coredump;
 	/* Now dump all of the user data.  Include malloced stuff as well */
-	DUMP_SEEK(PAGE_SIZE - sizeof(dump));
+	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
+		goto end_coredump;
 	/* now we start writing out the user space info */
 	set_fs(USER_DS);
 	/* Dump the data area */
 	if (dump.u_dsize != 0) {
 		dump_start = START_DATA(dump);
 		dump_size = dump.u_dsize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start, dump_size);
+		if (!dump_emit(cprm, (void *)dump_start, dump_size))
+			goto end_coredump;
 	}
 	/* Now prepare to dump the stack area */
 	if (dump.u_ssize != 0) {
 		dump_start = START_STACK(dump);
 		dump_size = dump.u_ssize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start, dump_size);
+		if (!dump_emit(cprm, (void *)dump_start, dump_size))
+			goto end_coredump;
 	}
 end_coredump:
 	set_fs(fs);
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index faaa819..a4f847f 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -45,7 +45,6 @@ static int load_aout_library(struct file*);
  */
 static int aout_core_dump(struct coredump_params *cprm)
 {
-	struct file *file = cprm->file;
 	mm_segment_t fs;
 	int has_dumped = 0;
 	void __user *dump_start;
@@ -85,7 +84,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 
 	set_fs(KERNEL_DS);
 /* struct user */
-	if (!dump_write(file, &dump, sizeof(dump)))
+	if (!dump_emit(cprm, &dump, sizeof(dump)))
 		goto end_coredump;
 /* Now dump all of the user data.  Include malloced stuff as well */
 	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
@@ -96,14 +95,14 @@ static int aout_core_dump(struct coredump_params *cprm)
 	if (dump.u_dsize != 0) {
 		dump_start = START_DATA(dump);
 		dump_size = dump.u_dsize << PAGE_SHIFT;
-		if (!dump_write(file, dump_start, dump_size))
+		if (!dump_emit(cprm, dump_start, dump_size))
 			goto end_coredump;
 	}
 /* Now prepare to dump the stack area */
 	if (dump.u_ssize != 0) {
 		dump_start = START_STACK(dump);
 		dump_size = dump.u_ssize << PAGE_SHIFT;
-		if (!dump_write(file, dump_start, dump_size))
+		if (!dump_emit(cprm, dump_start, dump_size))
 			goto end_coredump;
 	}
 end_coredump:
-- 
1.7.2.5


