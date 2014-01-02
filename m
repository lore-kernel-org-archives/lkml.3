Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaABIgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:36:00 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:52558 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaABIf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:35:59 -0500
Date: Thu, 2 Jan 2014 09:35:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.13-rc7
Message-ID: <20140102093551.50f166b2@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010208-6892-0000-0000-0000075BD18A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

happy new year.. and please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Two small bug fixes and a follow-up to the CONFIG_NR_CPUS change. A kernel
compiled with CONFIG_NR_CPUS=256 will waste quite a bit of memory for the
per-cpu arrays. Under z/VM the maximum number of CPUs is 64, the code
now limits the possible cpu mask to 64 if running under z/VM.

Heiko Carstens (1):
      s390/smp: improve setup of possible cpu mask

Martin Schwidefsky (1):
      s390/3270: fix allocation of tty3270_screen structure

Sebastian Ott (1):
      s390/pci: obtain function handle in hotplug notifier

 arch/s390/Kconfig           |    1 -
 arch/s390/include/asm/smp.h |    2 ++
 arch/s390/kernel/setup.c    |    1 +
 arch/s390/kernel/smp.c      |   25 ++++++++++++++++---------
 arch/s390/pci/pci_event.c   |    2 ++
 drivers/s390/char/tty3270.c |    2 +-
 6 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1e1a03d..e9f3125 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -135,7 +135,6 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select INIT_ALL_POSSIBLE
 	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGACTION
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index ac9bed8..1607793 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -31,6 +31,7 @@ extern void smp_yield(void);
 extern void smp_stop_cpu(void);
 extern void smp_cpu_set_polarization(int cpu, int val);
 extern int smp_cpu_get_polarization(int cpu);
+extern void smp_fill_possible_mask(void);
 
 #else /* CONFIG_SMP */
 
@@ -50,6 +51,7 @@ static inline int smp_vcpu_scheduled(int cpu) { return 1; }
 static inline void smp_yield_cpu(int cpu) { }
 static inline void smp_yield(void) { }
 static inline void smp_stop_cpu(void) { }
+static inline void smp_fill_possible_mask(void) { }
 
 #endif /* CONFIG_SMP */
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 4444875..0f3d44e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1023,6 +1023,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_vmcoreinfo();
 	setup_lowcore();
 
+	smp_fill_possible_mask();
         cpu_init();
 	s390_init_cpu_topology();
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index dc4a534..9587047 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -721,18 +721,14 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return 0;
 }
 
-static int __init setup_possible_cpus(char *s)
-{
-	int max, cpu;
+static unsigned int setup_possible_cpus __initdata;
 
-	if (kstrtoint(s, 0, &max) < 0)
-		return 0;
-	init_cpu_possible(cpumask_of(0));
-	for (cpu = 1; cpu < max && cpu < nr_cpu_ids; cpu++)
-		set_cpu_possible(cpu, true);
+static int __init _setup_possible_cpus(char *s)
+{
+	get_option(&s, &setup_possible_cpus);
 	return 0;
 }
-early_param("possible_cpus", setup_possible_cpus);
+early_param("possible_cpus", _setup_possible_cpus);
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -775,6 +771,17 @@ void __noreturn cpu_die(void)
 
 #endif /* CONFIG_HOTPLUG_CPU */
 
+void __init smp_fill_possible_mask(void)
+{
+	unsigned int possible, cpu;
+
+	possible = setup_possible_cpus;
+	if (!possible)
+		possible = MACHINE_IS_VM ? 64 : nr_cpu_ids;
+	for (cpu = 0; cpu < possible && cpu < nr_cpu_ids; cpu++)
+		set_cpu_possible(cpu, true);
+}
+
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	/* request the 0x1201 emergency signal external interrupt */
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index 800f064..0696072 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -75,6 +75,7 @@ void zpci_event_availability(void *data)
 		if (!zdev || zdev->state == ZPCI_FN_STATE_CONFIGURED)
 			break;
 		zdev->state = ZPCI_FN_STATE_CONFIGURED;
+		zdev->fh = ccdf->fh;
 		ret = zpci_enable_device(zdev);
 		if (ret)
 			break;
@@ -101,6 +102,7 @@ void zpci_event_availability(void *data)
 		if (pdev)
 			pci_stop_and_remove_bus_device(pdev);
 
+		zdev->fh = ccdf->fh;
 		zpci_disable_device(zdev);
 		zdev->state = ZPCI_FN_STATE_STANDBY;
 		break;
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 3f4ca4e..34629ea 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -942,7 +942,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return rc;
 	}
 
-	tp->screen = tty3270_alloc_screen(tp->view.cols, tp->view.rows);
+	tp->screen = tty3270_alloc_screen(tp->view.rows, tp->view.cols);
 	if (IS_ERR(tp->screen)) {
 		rc = PTR_ERR(tp->screen);
 		raw3270_put_view(&tp->view);

