Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbaJUW5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:57:40 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53993 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933910AbaJUW5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:57:25 -0400
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [RFC PATCH] coredump: fix incomplete core file created when dump_skip was used last
Date: Tue, 21 Oct 2014 15:57:08 -0700
Message-Id: <1413932228-27642-2-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org>
References: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situation when dump_skip is used on last part
of core file with intent of creating zeros. However if it
is not followed by any write (through dump_emit) zeros
will not be written into the file. I.e llseek without
subsequent write does not create any content.

Such issue happened during bigcore.exp gdb testsuite run on
ARM V7 rootfs running on top of ARM V8 kenel (compat mode).
For last vma in elf_core_dump function last 5 pages could
not be mapped and as result dump_skip was called. And resulting
core file was missing 5 last pages and gdb complained about
that.

Solution is to introduce new field into coredump_params struct
that would track whether last helper used did real write or
llseek. If last operation was llseek, move position back to
1 byte and write 1 zero byte. As result all content intended
with last dump_skip will appear in core file as zeros.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
---
 fs/coredump.c           | 26 ++++++++++++++++++++++++++
 include/linux/binfmts.h |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index a93f7e6..da0000b 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -489,6 +489,27 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
+/*
+ * Write last byte into core file. It is called if last operation
+ * on core file was llseek through dump_skip, and we need to write
+ * something at the end of the file, so zeros intended to be added
+ * by dump_skip will go into the file.
+ */
+static int dump_write_last_byte(struct coredump_params *cprm)
+{
+	char lastbyte = 0;
+	struct file *file = cprm->file;
+
+	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+		if (dump_interrupted() ||
+		    file->f_op->llseek(file, -1, SEEK_CUR) < 0)
+			return 0;
+		if (!dump_emit(cprm, &lastbyte, 1))
+			return 0;
+	}
+	return 1;
+}
+
 void do_coredump(const siginfo_t *siginfo)
 {
 	struct core_state core_state;
@@ -514,6 +535,7 @@ void do_coredump(const siginfo_t *siginfo)
 		 * by any locks.
 		 */
 		.mm_flags = mm->flags,
+		.last_op_status = COREDUMP_LAST_WRITE,
 	};
 
 	audit_core_dumps(siginfo->si_signo);
@@ -664,6 +686,8 @@ void do_coredump(const siginfo_t *siginfo)
 	if (!dump_interrupted()) {
 		file_start_write(cprm.file);
 		core_dumped = binfmt->core_dump(&cprm);
+		if (cprm.last_op_status == COREDUMP_LAST_LLSEEK)
+			dump_write_last_byte(&cprm);
 		file_end_write(cprm.file);
 	}
 	if (ispipe && core_pipe_limit)
@@ -706,6 +730,7 @@ int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 		cprm->written += n;
 		nr -= n;
 	}
+	cprm->last_op_status = COREDUMP_LAST_WRITE;
 	return 1;
 }
 EXPORT_SYMBOL(dump_emit);
@@ -721,6 +746,7 @@ int dump_skip(struct coredump_params *cprm, size_t nr)
 		    file->f_op->llseek(file, nr, SEEK_CUR) < 0)
 			return 0;
 		cprm->written += nr;
+		cprm->last_op_status = COREDUMP_LAST_LLSEEK;
 		return 1;
 	} else {
 		while (nr > PAGE_SIZE) {
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 61f29e5..5f4ad91 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -53,6 +53,11 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+/* last coredump operation status */
+
+#define COREDUMP_LAST_WRITE 1
+#define COREDUMP_LAST_LLSEEK 2
+
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	const siginfo_t *siginfo;
@@ -61,6 +66,7 @@ struct coredump_params {
 	unsigned long limit;
 	unsigned long mm_flags;
 	loff_t written;
+	int last_op_status;
 };
 
 /*
-- 
1.8.1.4

