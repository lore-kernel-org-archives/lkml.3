Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaB1RDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:03:33 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:45468
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbaB1RDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:03:32 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2014 12:03:32 EST
From: Tim Sander <tim@krieglstein.org>
To: "linux-arm@lists.infradead.org" <linux-arm@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: FIQ on xilinx cortex a9 zynq
Date: Fri, 28 Feb 2014 17:53:29 +0100
Message-ID: <8605883.1pbkKagGpT@dabox>
User-Agent: KMail/4.12.2 (Linux/3.13.0; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am currently trying to get the FIQ interrupt working with linux. I want to
have the FIQ to have an interrupt which is not masked by linux and gives the
lowest irq latencys the hardware can deliver. 

In the case of the xilinx zynx i have seen that the ICCICR register enables
the FIQ via the fittingly named config bit FiqEn. Enabling this bit "as is" does
not seem to work as the kernel works in secure mode and thus all interrupts
delivered suddenly are delivered in FIQ context which is obviously not a good
idea. 

So i tried to switch all interrupts to the non-secure mode:
Disable the interrupts in ICCICR register, set all interrupt security
registers to 0xffffffff which means non-secure mode.

The register values after that looked like that which is slighly irritating
for the ICDISR0 case:
ICDISR0:f800ffff
ICDISR1:ffffffff
ICDISR2:ffffffff
Set the ICCICR register to 0x17 (SBPR,AckCtl,EnableNS,EnableS).
But still the kernel locks up when doing this. 

One cause would be that in driver/irqchips/irq-gic.c the first bit in ICCICR is
used to switch the interrupts off. Now it should be the second bit as they where 
shifted to the non-secure mode.

I tried the following patch which should switch both the non-secure and the
secure images but still this locked the kernel up:
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 5e7f810..a05a126 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -467,13 +467,14 @@ static void gic_cpu_init(struct gic_chip_data *gic)
                writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
        writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-       writel_relaxed(1, base + GIC_CPU_CTRL);
+
+       writel_relaxed(readl(base + GIC_CPU_CTRL)|3, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
 {
        void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-       writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+       writel_relaxed(readl(cpu_base + GIC_CPU_CTRL)&0xfffffffc, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -608,7 +609,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
                writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
        writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-       writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+       writel_relaxed(readl(cpu_base + GIC_CPU_CTRL)|3, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,        void *v)
----

but still the kernel locks up even if i haven't enabled the fiqen bit in ICCICR register.
So currently i am out of ideas why the kernel locks up but i am sure i have forgotten one thing
or another... :-/

It seems much harder to get the FIQ running than in the "good ol' days" without TrustZone.

Best regards
Tim

