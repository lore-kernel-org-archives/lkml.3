Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaCDKui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:50:38 -0500
Received: from ni.piap.pl ([195.187.100.4]:54345 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbaCDKuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:50:37 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-arm-kernel@lists.infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Yinghai Lu <yinghai@kernel.org>, Russell King <linux@arm.linux.org.uk>
References: <m3eh2nqz7n.fsf@t19.piap.pl>
Date: Tue, 04 Mar 2014 11:50:35 +0100
In-Reply-To: <m3eh2nqz7n.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 28 Feb 2014 12:00:12 +0100")
MIME-Version: 1.0
Message-ID: <m338iynsp0.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH2] CNS3xxx: Fix a WARN() related to IRQ allocation.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140303 #7388596, check: 20140304 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at drivers/irqchip/irq-gic.c:952 gic_init_bases+0xe4/0x2b8()
Cannot allocate irq_descs @ IRQ16, assuming pre-allocated
Backtrace:
gic_init_bases    from cns3xxx_init_irq+0x24/0x34
cns3xxx_init_irq  from init_IRQ+0x24/0x2c
init_IRQ          from start_kernel+0x1a8/0x338
start_kernel      from 0x2000806c

The problem is that 64 CNS3xxx CPU interrupts, starting at 32, are
allocated by the ARM platform-independent code (as requested by
machine_desc->nr_irqs = 96), and then the GIC code tries to allocate
them again.

Tested on Gateworks Laguna board, masqueraded as CNS3420VB.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -246,7 +246,6 @@ static void __init cns3420_map_io(void)
 
 MACHINE_START(CNS3420VB, "Cavium Networks CNS3420 Validation Board")
 	.atag_offset	= 0x100,
-	.nr_irqs	= NR_IRQS_CNS3XXX,
 	.map_io		= cns3420_map_io,
 	.init_irq	= cns3xxx_init_irq,
 	.init_time	= cns3xxx_timer_init,
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -400,7 +400,6 @@ static const char *cns3xxx_dt_compat[] __initdata = {
 
 DT_MACHINE_START(CNS3XXX_DT, "Cavium Networks CNS3xxx")
 	.dt_compat	= cns3xxx_dt_compat,
-	.nr_irqs	= NR_IRQS_CNS3XXX,
 	.map_io		= cns3xxx_map_io,
 	.init_irq	= cns3xxx_init_irq,
 	.init_time	= cns3xxx_timer_init,

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
