Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJZQGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:06:32 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:46731 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJZQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:06:31 -0400
Date: Sun, 26 Oct 2014 16:06:28 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix XT-PIC-XT-PIC in /proc/interrupts
Message-ID: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix duplicate XT-PIC seen in /proc/interrupts on x86 systems that make 
use of 8259A Programmable Interrupt Controllers.  Specifically convert 
output like this:

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

that is one like we used to have from ~2.2 till it was changed sometime.

The rationale is there is no value in this duplicate information, it 
merely clutters output and looks ugly.  We only have one handler for 
8259A interrupts so there is no need to give it a name separate from the 
name already given to irq_chip.

We could define meaningful names for handlers based on bits in the ELCR 
register on systems that have it or the value of the LTIM bit we use in 
ICW1 otherwise (hardcoded to 0 though with MCA support gone), to tell 
edge-triggered and level-triggered inputs apart.  While that information 
does not affect 8259A interrupt handlers it could help people determine 
which lines are shareable and which are not.  That is material for a 
separate change though.

Any tools that parse /proc/interrupts are supposed not to be affected 
since it was many years we used the format this change converts back to.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Original report recorded here: https://lkml.org/lkml/2014/9/25/190 -- 
and given no feedback here is a fix, as promised.  I'll be happy to 
discuss it further if there is any concern about this change.

 Otherwise, please apply.

  Maciej

linux-x86-xt-pic.patch
Index: linux-3.16-dolch/arch/x86/kernel/i8259.c
===================================================================
--- linux-3.16-dolch.orig/arch/x86/kernel/i8259.c
+++ linux-3.16-dolch/arch/x86/kernel/i8259.c
@@ -111,8 +111,7 @@ static void make_8259A_irq(unsigned int 
 {
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
-	irq_set_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      i8259A_chip.name);
+	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
 	enable_irq(irq);
 }
 
Index: linux-3.16-dolch/arch/x86/kernel/irqinit.c
===================================================================
--- linux-3.16-dolch.orig/arch/x86/kernel/irqinit.c
+++ linux-3.16-dolch/arch/x86/kernel/irqinit.c
@@ -70,7 +70,6 @@ int vector_used_by_percpu_irq(unsigned i
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
