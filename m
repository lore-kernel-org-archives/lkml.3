Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3JGHjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 03:39:45 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:60833 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3JGHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 03:39:42 -0400
Date: Mon, 7 Oct 2013 09:39:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.12-rc5
Message-ID: <20131007093936.45625613@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100707-4966-0000-0000-0000071AE222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A couple of bux fixes, notable are the regression with ptrace vs. restarting
system calls and the patch for kdump to be able to copy from virtual memory.

Christian Borntraeger (1):
      s390/sclp: properly detect line mode console

Heiko Carstens (1):
      s390/kprobes: add exrl to list of prohibited opcodes

Martin Schwidefsky (1):
      s390: fix system call restart after inferior call

Michael Holzheu (1):
      s390: Allow vmalloc target buffers for copy_from_oldmem()

Wei Yongjun (1):
      s390/3270: fix return value check in tty3270_resize_work()

 arch/s390/kernel/crash_dump.c |   42 ++++++++++++++++++++---------------------
 arch/s390/kernel/entry.S      |    1 +
 arch/s390/kernel/entry64.S    |    1 +
 arch/s390/kernel/kprobes.c    |    6 +++++-
 drivers/s390/char/sclp_cmd.c  |    8 +++++---
 drivers/s390/char/tty3270.c   |    2 +-
 6 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index c84f33d..7dd2172 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -40,28 +40,26 @@ static inline void *load_real_addr(void *addr)
 }
 
 /*
- * Copy up to one page to vmalloc or real memory
+ * Copy real to virtual or real memory
  */
-static ssize_t copy_page_real(void *buf, void *src, size_t csize)
+static int copy_from_realmem(void *dest, void *src, size_t count)
 {
-	size_t size;
+	unsigned long size;
+	int rc;
 
-	if (is_vmalloc_addr(buf)) {
-		BUG_ON(csize >= PAGE_SIZE);
-		/* If buf is not page aligned, copy first part */
-		size = min(roundup(__pa(buf), PAGE_SIZE) - __pa(buf), csize);
-		if (size) {
-			if (memcpy_real(load_real_addr(buf), src, size))
-				return -EFAULT;
-			buf += size;
-			src += size;
-		}
-		/* Copy second part */
-		size = csize - size;
-		return (size) ? memcpy_real(load_real_addr(buf), src, size) : 0;
-	} else {
-		return memcpy_real(buf, src, csize);
-	}
+	if (!count)
+		return 0;
+	if (!is_vmalloc_or_module_addr(dest))
+		return memcpy_real(dest, src, count);
+	do {
+		size = min(count, PAGE_SIZE - (__pa(dest) & ~PAGE_MASK));
+		if (memcpy_real(load_real_addr(dest), src, size))
+			return -EFAULT;
+		count -= size;
+		dest += size;
+		src += size;
+	} while (count);
+	return 0;
 }
 
 /*
@@ -114,7 +112,7 @@ static ssize_t copy_oldmem_page_kdump(char *buf, size_t csize,
 		rc = copy_to_user_real((void __force __user *) buf,
 				       (void *) src, csize);
 	else
-		rc = copy_page_real(buf, (void *) src, csize);
+		rc = copy_from_realmem(buf, (void *) src, csize);
 	return (rc == 0) ? rc : csize;
 }
 
@@ -210,7 +208,7 @@ int copy_from_oldmem(void *dest, void *src, size_t count)
 	if (OLDMEM_BASE) {
 		if ((unsigned long) src < OLDMEM_SIZE) {
 			copied = min(count, OLDMEM_SIZE - (unsigned long) src);
-			rc = memcpy_real(dest, src + OLDMEM_BASE, copied);
+			rc = copy_from_realmem(dest, src + OLDMEM_BASE, copied);
 			if (rc)
 				return rc;
 		}
@@ -223,7 +221,7 @@ int copy_from_oldmem(void *dest, void *src, size_t count)
 				return rc;
 		}
 	}
-	return memcpy_real(dest + copied, src + copied, count - copied);
+	return copy_from_realmem(dest + copied, src + copied, count - copied);
 }
 
 /*
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index cc30d1f..0dc2b6d 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -266,6 +266,7 @@ sysc_sigpending:
 	tm	__TI_flags+3(%r12),_TIF_SYSCALL
 	jno	sysc_return
 	lm	%r2,%r7,__PT_R2(%r11)	# load svc arguments
+	l	%r10,__TI_sysc_table(%r12)	# 31 bit system call table
 	xr	%r8,%r8			# svc 0 returns -ENOSYS
 	clc	__PT_INT_CODE+2(2,%r11),BASED(.Lnr_syscalls+2)
 	jnl	sysc_nr_ok		# invalid svc number -> do svc 0
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 2b2188b..e5b43c9 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -297,6 +297,7 @@ sysc_sigpending:
 	tm	__TI_flags+7(%r12),_TIF_SYSCALL
 	jno	sysc_return
 	lmg	%r2,%r7,__PT_R2(%r11)	# load svc arguments
+	lg	%r10,__TI_sysc_table(%r12)	# address of system call table
 	lghi	%r8,0			# svc 0 returns -ENOSYS
 	llgh	%r1,__PT_INT_CODE+2(%r11)	# load new svc number
 	cghi	%r1,NR_syscalls
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 0ce9fb2..d86e64e 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -67,6 +67,11 @@ static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
 	case 0xac:	/* stnsm */
 	case 0xad:	/* stosm */
 		return -EINVAL;
+	case 0xc6:
+		switch (insn[0] & 0x0f) {
+		case 0x00: /* exrl   */
+			return -EINVAL;
+		}
 	}
 	switch (insn[0]) {
 	case 0x0101:	/* pr	 */
@@ -180,7 +185,6 @@ static int __kprobes is_insn_relative_long(kprobe_opcode_t *insn)
 		break;
 	case 0xc6:
 		switch (insn[0] & 0x0f) {
-		case 0x00: /* exrl   */
 		case 0x02: /* pfdrl  */
 		case 0x04: /* cghrl  */
 		case 0x05: /* chrl   */
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 8cd34bf..77df9cb 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -145,9 +145,11 @@ bool __init sclp_has_linemode(void)
 
 	if (sccb->header.response_code != 0x20)
 		return 0;
-	if (sccb->sclp_send_mask & (EVTYP_MSG_MASK | EVTYP_PMSGCMD_MASK))
-		return 1;
-	return 0;
+	if (!(sccb->sclp_send_mask & (EVTYP_OPCMD_MASK | EVTYP_PMSGCMD_MASK)))
+		return 0;
+	if (!(sccb->sclp_receive_mask & (EVTYP_MSG_MASK | EVTYP_PMSGCMD_MASK)))
+		return 0;
+	return 1;
 }
 
 bool __init sclp_has_vt220(void)
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index a0f47c8..3f4ca4e 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -810,7 +810,7 @@ static void tty3270_resize_work(struct work_struct *work)
 	struct winsize ws;
 
 	screen = tty3270_alloc_screen(tp->n_rows, tp->n_cols);
-	if (!screen)
+	if (IS_ERR(screen))
 		return;
 	/* Switch to new output size */
 	spin_lock_bh(&tp->view.lock);

