Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaJ1LNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:13:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbaJ1LNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:13:21 -0400
Date: Tue, 28 Oct 2014 04:13:08 -0700
From: "tip-bot for Maciej W. Rozycki" <tipbot@zytor.com>
Message-ID: <tip-0c7ba5008365b49c55f5bb9d9e859785b1f5cffe@git.kernel.org>
Cc: macro@linux-mips.org, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        macro@linux-mips.org
In-Reply-To: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/irq: Fix XT-PIC-XT-PIC in /proc/interrupts
Git-Commit-ID: 0c7ba5008365b49c55f5bb9d9e859785b1f5cffe
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

Commit-ID:  0c7ba5008365b49c55f5bb9d9e859785b1f5cffe
Gitweb:     http://git.kernel.org/tip/0c7ba5008365b49c55f5bb9d9e859785b1f5cffe
Author:     Maciej W. Rozycki <macro@linux-mips.org>
AuthorDate: Sun, 26 Oct 2014 16:06:28 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:04:55 +0100

x86/irq: Fix XT-PIC-XT-PIC in /proc/interrupts

Fix duplicate XT-PIC seen in /proc/interrupts on x86 systems
that make  use of 8259A Programmable Interrupt Controllers.
Specifically convert  output like this:

           CPU0
  0:      76573    XT-PIC-XT-PIC    timer
  1:         11    XT-PIC-XT-PIC    i8042
  2:          0    XT-PIC-XT-PIC    cascade
  4:          8    XT-PIC-XT-PIC    serial
  6:          3    XT-PIC-XT-PIC    floppy
  7:          0    XT-PIC-XT-PIC    parport0
  8:          1    XT-PIC-XT-PIC    rtc0
 10:        448    XT-PIC-XT-PIC    fddi0
 12:         23    XT-PIC-XT-PIC    eth0
 14:       2464    XT-PIC-XT-PIC    ide0
NMI:          0   Non-maskable interrupts
ERR:          0

to one like this:

           CPU0
  0:     122033    XT-PIC  timer
  1:         11    XT-PIC  i8042
  2:          0    XT-PIC  cascade
  4:          8    XT-PIC  serial
  6:          3    XT-PIC  floppy
  7:          0    XT-PIC  parport0
  8:          1    XT-PIC  rtc0
 10:        145    XT-PIC  fddi0
 12:         31    XT-PIC  eth0
 14:       2245    XT-PIC  ide0
NMI:          0   Non-maskable interrupts
ERR:          0

that is one like we used to have from ~2.2 till it was changed
sometime.

The rationale is there is no value in this duplicate
information, it  merely clutters output and looks ugly.  We only
have one handler for  8259A interrupts so there is no need to
give it a name separate from the  name already given to
irq_chip.

We could define meaningful names for handlers based on bits in
the ELCR  register on systems that have it or the value of the
LTIM bit we use in  ICW1 otherwise (hardcoded to 0 though with
MCA support gone), to tell  edge-triggered and level-triggered
inputs apart.  While that information  does not affect 8259A
interrupt handlers it could help people determine  which lines
are shareable and which are not.  That is material for a
separate change though.

Any tools that parse /proc/interrupts are supposed not to be
affected  since it was many years we used the format this change
converts back to.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/i8259.c   | 3 +--
 arch/x86/kernel/irqinit.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 8af8171..e7cc537 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -111,8 +111,7 @@ static void make_8259A_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
-	irq_set_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      i8259A_chip.name);
+	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
 	enable_irq(irq);
 }
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 44f1ed4..4de73ee 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -70,7 +70,6 @@ int vector_used_by_percpu_irq(unsigned int vector)
 void __init init_ISA_irqs(void)
 {
 	struct irq_chip *chip = legacy_pic->chip;
-	const char *name = chip->name;
 	int i;
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
@@ -79,7 +78,7 @@ void __init init_ISA_irqs(void)
 	legacy_pic->init(0);
 
 	for (i = 0; i < nr_legacy_irqs(); i++)
-		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
+		irq_set_chip_and_handler(i, chip, handle_level_irq);
 }
 
 void __init init_IRQ(void)
