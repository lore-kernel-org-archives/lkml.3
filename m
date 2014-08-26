Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbaHZHrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:47:49 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46946 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050AbaHZHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:47:46 -0400
Date: Tue, 26 Aug 2014 09:47:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.17-rc3
Message-ID: <20140826094739.0af5a26a@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082607-8372-0000-0000-000000F00725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Wire up the system calls seccomp, getrandom and memfd_create.
Use static system information as input to add_device_randomness.
And three bug fixes.

Heiko Carstens (2):
      s390: wire up seccomp and getrandom syscalls
      s390: wire up memfd_create syscall

Martin Schwidefsky (3):
      s390: add system information as device randomness
      s390/3215: fix tty output containing tabs
      s390/sclp: remove unnecessary XTABS flag

Michael Holzheu (1):
      s390/kdump: Clear subchannel ID to signal non-CCW/SCSI IPL

 arch/s390/include/uapi/asm/unistd.h |    5 ++++-
 arch/s390/kernel/compat_wrapper.c   |    3 +++
 arch/s390/kernel/ipl.c              |    7 +++++++
 arch/s390/kernel/setup.c            |   19 +++++++++++++++++++
 arch/s390/kernel/syscalls.S         |    3 +++
 drivers/s390/char/con3215.c         |   20 +++++++++++++++++---
 drivers/s390/char/sclp_tty.c        |    2 +-
 7 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 3802d2d..940ac49 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -283,7 +283,10 @@
 #define __NR_sched_setattr	345
 #define __NR_sched_getattr	346
 #define __NR_renameat2		347
-#define NR_syscalls 348
+#define __NR_seccomp		348
+#define __NR_getrandom		349
+#define __NR_memfd_create	350
+#define NR_syscalls 351
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.c b/arch/s390/kernel/compat_wrapper.c
index 45cdb37..faf6caa 100644
--- a/arch/s390/kernel/compat_wrapper.c
+++ b/arch/s390/kernel/compat_wrapper.c
@@ -214,3 +214,6 @@ COMPAT_SYSCALL_WRAP3(finit_module, int, fd, const char __user *, uargs, int, fla
 COMPAT_SYSCALL_WRAP3(sched_setattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, flags);
 COMPAT_SYSCALL_WRAP4(sched_getattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, size, unsigned int, flags);
 COMPAT_SYSCALL_WRAP5(renameat2, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, unsigned int, flags);
+COMPAT_SYSCALL_WRAP3(seccomp, unsigned int, op, unsigned int, flags, const char __user *, uargs)
+COMPAT_SYSCALL_WRAP3(getrandom, char __user *, buf, size_t, count, unsigned int, flags)
+COMPAT_SYSCALL_WRAP2(memfd_create, const char __user *, uname, unsigned int, flags)
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 633ca75..22aac58 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2060,6 +2060,13 @@ void s390_reset_system(void (*func)(void *), void *data)
 	S390_lowcore.program_new_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) s390_base_pgm_handler;
 
+	/*
+	 * Clear subchannel ID and number to signal new kernel that no CCW or
+	 * SCSI IPL has been done (for kexec and kdump)
+	 */
+	S390_lowcore.subchannel_id = 0;
+	S390_lowcore.subchannel_nr = 0;
+
 	/* Store status at absolute zero */
 	store_status();
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index ae1d5be..82bc113 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -24,6 +24,7 @@
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
+#include <linux/random.h>
 #include <linux/user.h>
 #include <linux/tty.h>
 #include <linux/ioport.h>
@@ -61,6 +62,7 @@
 #include <asm/diag.h>
 #include <asm/os_info.h>
 #include <asm/sclp.h>
+#include <asm/sysinfo.h>
 #include "entry.h"
 
 /*
@@ -766,6 +768,7 @@ static void __init setup_hwcaps(void)
 #endif
 
 	get_cpu_id(&cpu_id);
+	add_device_randomness(&cpu_id, sizeof(cpu_id));
 	switch (cpu_id.machine) {
 	case 0x9672:
 #if !defined(CONFIG_64BIT)
@@ -804,6 +807,19 @@ static void __init setup_hwcaps(void)
 }
 
 /*
+ * Add system information as device randomness
+ */
+static void __init setup_randomness(void)
+{
+	struct sysinfo_3_2_2 *vmms;
+
+	vmms = (struct sysinfo_3_2_2 *) alloc_page(GFP_KERNEL);
+	if (vmms && stsi(vmms, 3, 2, 2) == 0 && vmms->count)
+		add_device_randomness(&vmms, vmms->count);
+	free_page((unsigned long) vmms);
+}
+
+/*
  * Setup function called from init/main.c just after the banner
  * was printed.
  */
@@ -901,6 +917,9 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Setup zfcpdump support */
 	setup_zfcpdump();
+
+	/* Add system specific data to the random pool */
+	setup_randomness();
 }
 
 #ifdef CONFIG_32BIT
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index fe5cdf2..6fe886a 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -356,3 +356,6 @@ SYSCALL(sys_finit_module,sys_finit_module,compat_sys_finit_module)
 SYSCALL(sys_sched_setattr,sys_sched_setattr,compat_sys_sched_setattr) /* 345 */
 SYSCALL(sys_sched_getattr,sys_sched_getattr,compat_sys_sched_getattr)
 SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
+SYSCALL(sys_seccomp,sys_seccomp,compat_sys_seccomp)
+SYSCALL(sys_getrandom,sys_getrandom,compat_sys_getrandom)
+SYSCALL(sys_memfd_create,sys_memfd_create,compat_sys_memfd_create) /* 350 */
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index a6d47e5..c43aca6 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -1035,12 +1035,26 @@ static int tty3215_write(struct tty_struct * tty,
 			 const unsigned char *buf, int count)
 {
 	struct raw3215_info *raw;
+	int i, written;
 
 	if (!tty)
 		return 0;
 	raw = (struct raw3215_info *) tty->driver_data;
-	raw3215_write(raw, buf, count);
-	return count;
+	written = count;
+	while (count > 0) {
+		for (i = 0; i < count; i++)
+			if (buf[i] == '\t' || buf[i] == '\n')
+				break;
+		raw3215_write(raw, buf, i);
+		count -= i;
+		buf += i;
+		if (count > 0) {
+			raw3215_putchar(raw, *buf);
+			count--;
+			buf++;
+		}
+	}
+	return written;
 }
 
 /*
@@ -1188,7 +1202,7 @@ static int __init tty3215_init(void)
 	driver->subtype = SYSTEM_TYPE_TTY;
 	driver->init_termios = tty_std_termios;
 	driver->init_termios.c_iflag = IGNBRK | IGNPAR;
-	driver->init_termios.c_oflag = ONLCR | XTABS;
+	driver->init_termios.c_oflag = ONLCR;
 	driver->init_termios.c_lflag = ISIG;
 	driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(driver, &tty3215_ops);
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 7ed7a59..0036632 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -559,7 +559,7 @@ sclp_tty_init(void)
 	driver->subtype = SYSTEM_TYPE_TTY;
 	driver->init_termios = tty_std_termios;
 	driver->init_termios.c_iflag = IGNBRK | IGNPAR;
-	driver->init_termios.c_oflag = ONLCR | XTABS;
+	driver->init_termios.c_oflag = ONLCR;
 	driver->init_termios.c_lflag = ISIG | ECHO;
 	driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(driver, &sclp_ops);

