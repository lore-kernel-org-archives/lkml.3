Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3HTIXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:23:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3HTIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:23:51 -0400
Date: Tue, 20 Aug 2013 01:22:24 -0700
From: tip-bot for Yoshihiro YUNOMAE <tipbot@zytor.com>
Message-ID: <tip-17405453f4ad0220721a29978692081be6392b8f@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, yoshihiro.yunomae.ez@hitachi.com,
        seiji.aguchi@hds.com, zhangyanfei@cn.fujitsu.com,
        hidehiro.kawai.ez@hitachi.com, mtosatti@redhat.com, ak@linux.intel.com,
        sebastian@breakpoint.cc, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, ebiederm@xmission.com,
        gleb@redhat.com, masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, yoshihiro.yunomae.ez@hitachi.com,
        konrad.wilk@oracle.com, zhangyanfei@cn.fujitsu.com,
        seiji.aguchi@hds.com, hidehiro.kawai.ez@hitachi.com,
        mtosatti@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        sebastian@breakpoint.cc, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joro@8bytes.org, ebiederm@xmission.com, gleb@redhat.com,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20130820070107.28245.83806.stgit@yunodevel>
References: <20130820070107.28245.83806.stgit@yunodevel>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/ioapic/kcrash: Prevent crash_kexec()
  from deadlocking on ioapic_lock
Git-Commit-ID: 17405453f4ad0220721a29978692081be6392b8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Aug 2013 01:22:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17405453f4ad0220721a29978692081be6392b8f
Gitweb:     http://git.kernel.org/tip/17405453f4ad0220721a29978692081be6392b8f
Author:     Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
AuthorDate: Tue, 20 Aug 2013 16:01:07 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 20 Aug 2013 09:26:33 +0200

x86/ioapic/kcrash: Prevent crash_kexec() from deadlocking on ioapic_lock

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
---
 arch/x86/include/asm/apic.h    | 2 ++
 arch/x86/kernel/apic/io_apic.c | 5 +++++
 arch/x86/kernel/crash.c        | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f8119b5..1d2091a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -715,4 +715,6 @@ static inline void exiting_ack_irq(void)
 	ack_APIC_irq();
 }
 
+extern void ioapic_zap_locks(void);
+
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..260abc2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1534,6 +1534,11 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
 	}
 }
 
+void ioapic_zap_locks(void)
+{
+	raw_spin_lock_init(&ioapic_lock);
+}
+
 __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
 	union IO_APIC_reg_00 reg_00;
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
