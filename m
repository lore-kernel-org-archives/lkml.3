Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853Ab3LFXQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:16:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161327Ab3LFXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:16:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 072/152] x86/ioapic/kcrash: Prevent crash_kexec() from deadlocking on ioapic_lock
Date: Fri,  6 Dec 2013 15:09:56 -0800
Message-Id: <1386371476-2477-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

commit 17405453f4ad0220721a29978692081be6392b8f upstream.

Prevent crash_kexec() from deadlocking on ioapic_lock. When
crash_kexec() is executed on a CPU, the CPU will take ioapic_lock
in disable_IO_APIC(). So if the cpu gets an NMI while locking
ioapic_lock, a deadlock will happen.

In this patch, ioapic_lock is zapped/initialized before disable_IO_APIC().

You can reproduce this deadlock the following way:

1. Add mdelay(1000) after raw_spin_lock_irqsave() in
   native_ioapic_set_affinity()@arch/x86/kernel/apic/io_apic.c

   Although the deadlock can occur without this modification, it will increase
   the potential of the deadlock problem.

2. Build and install the kernel

3. Set up the OS which will run panic() and kexec when NMI is injected
    # echo "kernel.unknown_nmi_panic=1" >> /etc/sysctl.conf
    # vim /etc/default/grub
      add "nmi_watchdog=0 crashkernel=256M" in GRUB_CMDLINE_LINUX line
    # grub2-mkconfig

4. Reboot the OS

5. Run following command for each vcpu on the guest
    # while true; do echo <CPU num> > /proc/irq/<IO-APIC-edge or IO-APIC-fasteoi>/smp_affinitity; done;
   By running this command, cpus will get ioapic_lock for setting affinity.

6. Inject NMI (push a dump button or execute 'virsh inject-nmi <domain>' if you
   use VM). After injecting NMI, panic() is called in an nmi-handler context.
   Then, kexec will normally run in panic(), but the operation will be stopped
   by deadlock on ioapic_lock in crash_kexec()->machine_crash_shutdown()->
   native_machine_crash_shutdown()->disable_IO_APIC()->clear_IO_APIC()->
   clear_IO_APIC_pin()->ioapic_read_entry().

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/20130820070107.28245.83806.stgit@yunodevel
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ kamal: 3.8 stable prereq for
  522e664 x86/apic: Disable I/O APIC before shutdown of the local APIC ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/apic.h    | 2 ++
 arch/x86/kernel/apic/io_apic.c | 5 +++++
 arch/x86/kernel/crash.c        | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3388034..cb8bc81 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -688,4 +688,6 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+extern void ioapic_zap_locks(void);
+
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b739d39..c605173 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1513,6 +1513,11 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
+void ioapic_zap_locks(void)
+{
+	raw_spin_lock_init(&ioapic_lock);
+}
+
 __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
 	int i;
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 74467fe..e0e0841 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -128,7 +128,9 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	cpu_emergency_svm_disable();
 
 	lapic_shutdown();
-#if defined(CONFIG_X86_IO_APIC)
+#ifdef CONFIG_X86_IO_APIC
+	/* Prevent crash_kexec() from deadlocking on ioapic_lock. */
+	ioapic_zap_locks();
 	disable_IO_APIC();
 #endif
 #ifdef CONFIG_HPET_TIMER
-- 
1.8.3.2

