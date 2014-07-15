Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbaGOJlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:41:55 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61011 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450AbaGOJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:41:48 -0400
Message-ID: <53C4F745.3070701@linaro.org>
Date: Tue, 15 Jul 2014 10:41:25 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Harro Haan <hrhaan@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        John Stultz <john.stultz@linaro.org>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/4] arm: KGDB NMI/FIQ support
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>	<1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <CAB5oZtCk5NwBJF+dBESKGhYabti=EWWtF2jJYK7HdyNHM46nTw@mail.gmail.com>
In-Reply-To: <CAB5oZtCk5NwBJF+dBESKGhYabti=EWWtF2jJYK7HdyNHM46nTw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 14:51, Harro Haan wrote:
> On 10 July 2014 10:03, Daniel Thompson <daniel.thompson@linaro.org> wrote:
>>
>> This patchset makes it possible to use kgdb's NMI infrastructure on ARM
>> platforms.
>>
>> The patches have been previously circulated as part of a large patchset
>> mixing together ARM architecture code and driver changes
>> (http://thread.gmane.org/gmane.linux.ports.arm.kernel/333901 ). This
>> patchset is dramatically cut down to include only the arch/arm code. The
>> driver code (irqchip and tty/serial) will follow when/if the arch code
>> is accepted.
>>
>> The first two patches modify the FIQ infrastructure to allow interrupt
>> controller drivers to register callbacks (the fiq_chip structure) to
>> manage FIQ routings and to ACK and EOI the FIQ. This makes it possible
>> to use FIQ in multi-platform kernels and with recent ARM interrupt
>> controllers.
>>
> 
> Daniel,
> 
> Thanks for the patches. I have tested the fiq and irq-gic patches on
> an i.MX6 (SabreSD board) for a different purpose:
> A FIQ timer interrupt at 1 kHz. The TWD watchdog block is used in
> timer mode for this (interrupt ID 30). The GIC affinity is set to CPU
> core 0 only for this interrupt ID.
> 
> I was surprised by the following behavior:
> $ cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>  29:       5459       3381       3175       3029       GIC  29  twd
>  30:         11          0          0          0       GIC  30  fake-fiq
> 
> Once every few seconds is interrupt ID 30 handled by the regular GIC
> handler instead of the FIQ exception path (which causes for example a
> bit more latencies). The other thousands of FIQ's are handled by the
> FIQ exception path. The problem is also confirmed by the following
> stackframe of the Lauterbach tooling:
> fake_fiq_handler(irq = 30, ...)
> handle_percpu_devid_irq(irq = 30, ...)
> generic_handle_irq(irq = 30)
> handle_IRQ(irq = 30, ...)
> gic_handle_irq
> __irq_svc
> -->exception
> 
> Notes:
> - The problem will occur more often by executing the following command:
>   $ while true; do hackbench 20; done &
> - Reading the GIC_CPU_INTACK register returns the interrupt ID of the
> highest priority pending interrupt.
> - The GIC_CPU_INTACK register (used by fiq_ack) will return spurious
> interrupt ID 0x3FF when read in fake_fiq_handler, because
> GIC_CPU_INTACK is already read by gic_handle_irq.
> - The FIQ exception will not occur anymore after gic_handle_irq
> read/acknowledges the FIQ by reading the GIC_CPU_INTACK register
> 
> From the behavior above I conclude that the GIC_CPU_INTACK register is
> first updated before the FIQ exception is generated, so there is a
> small period of time that gic_handle_irq can read/acknowledge the FIQ.

Makes sense.

Avoiding this problem on GICv2 is easy (thanks to the aliased intack
register) but on iMX.6 we have only a GICv1.


> I can reduce the number of occurrences (not prevent it) by adding the
> following hack to irq-gic.c
> @@ -297,10 +309,12 @@ static asmlinkage void __exception_irq_entry
> gic_handle_irq(struct pt_regs *regs
>   u32 irqstat, irqnr;
>   struct gic_chip_data *gic = &gic_data[0];
>   void __iomem *cpu_base = gic_data_cpu_base(gic);
> 
>   do {
> + while(readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_PENDING_SET)
> & (1 << 30))
> +   printk(KERN_ERR "TEMP: gic_handle_irq: wait for FIQ exception\n");
>   irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>   irqnr = irqstat & ~0x1c00;

I've made a more complete attempt to fix this. Could you test the
following? (and be prepared to fuzz the line numbers)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 73ae896..309bf2c 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -303,6 +303,28 @@ static int gic_set_wake(struct irq_data *d,
unsigned int on)
 #define gic_set_wake	NULL
 #endif

+/* Check for group 0 interrupt spuriously acked as a normal IRQ. This
+ * workaround will only work for level triggered interrupts (and in
+ * its current form is actively harmful on systems that don't support
+ * FIQ).
+ */
+static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32
irqstat)
+{
+	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+
+	if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
+		return irqnr;
+
+	if (readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_IGROUP +
+			  (irqnr / 32 * 4)) &
+	    BIT(irqnr % 32))
+		return irqnr;
+
+	/* this interrupt was spurious (needs to be handled as FIQ) */
+	writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
+	return 1023;
+}
+
 static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
@@ -310,8 +332,10 @@ static void __exception_irq_entry
gic_handle_irq(struct pt_regs *regs)
 	void __iomem *cpu_base = gic_data_cpu_base(gic);

 	do {
+		local_fiq_disable();
 		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
-		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+		irqnr = gic_handle_spurious_group_0(gic, irqstat);
+		local_fiq_enable();

 		if (likely(irqnr > 15 && irqnr < 1021)) {
 			irqnr = irq_find_mapping(gic->domain, irqnr);
