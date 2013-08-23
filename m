Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3HWJa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:30:28 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53425 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HWJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:30:24 -0400
Message-ID: <52172BAA.7020009@gmail.com>
Date: Fri, 23 Aug 2013 11:30:18 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com> <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local> <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
In-Reply-To: <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
Content-Type: multipart/mixed;
 boundary="------------010201020507060305010600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010201020507060305010600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/23/13 02:59, Sören Brinkmann wrote:
> On Thu, Aug 22, 2013 at 05:26:47PM -0700, Sören Brinkmann wrote:
>> On Tue, Aug 20, 2013 at 04:04:31AM +0200, Sebastian Hesselbarth wrote:
>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>>> remove it from corresponding drivers/clk code.
>>
>> I think that would break Zynq.
>> If I see this correctly you call of_clk_init() from common code,
>> _before_ the SOC specific time init function is called.
>> The problem is, that we have code setting up a global pointer which is
>> required by zynq_clk_setup() which is triggered when of_clk_init() is
>> called.
>>
>> Let me try to illustrate the current call graph:
>>
>> time_init()
>> 	zynq_timer_init()		// this machines init_time()
>> 		zynq_slcr_init()	// setup System Level Control Registers including a global pointer
>> 			zynq_clock_init()
>> 				of_clk_init()
>> 					zynq_clk_setup()   // requires pointer setup in zynq_slcr_init()
>> 					...
>>
>> IIUC, your series would change this to:
>> time_init()
>> 	of_clk_init()
>> 		zynq_clk_setup()	// SLCR pointer is not setup/NULL
>> 		...
>> 	zynq_timer_init()
>> 		zynq_slcr_init()	// now the pointer becomes valid
>
> I guess we could move zynq_slcr_init() into init_irq(). I'll give that a
> shot tomorrow.

Sören,

thanks for looking into this. I also had a look at the files in
question. Based on Steffen's proposal, I prepared a diff that should do
the trick. It moves zynq_slcr_init() to early_init, instead of reusing
another hook that has magic cow powers (it calls irqchip_init that zynq
also wants sooner or later).

Also, it removes zynq_clock_init() and let zynq_clk_setup() map the
register itself by finding the node and use of_iomap(). I realized that
clock registers are quite separated within slcr, so you can consider
to have your own node for the clk-provider. As Steffen is proposing
this but mentioned incompatible DT changes, I chose that intermediate
step above.

It would be great, if you test the diff and prepare a patch out of
it, that I pick-up in the patch set. That way, we also have your
Signed-off on it.

Sebastian



--------------010201020507060305010600
Content-Type: text/x-patch;
 name="arm-of_clk_init-zynq-proposal.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="arm-of_clk_init-zynq-proposal.diff"

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5f25256..a5a3969 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -19,8 +19,6 @@
 #include <linux/cpumask.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-#include <linux/clk/zynq.h>
-#include <linux/clocksource.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -58,10 +56,9 @@ static void __init zynq_init_machine(void)
 	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
 }
 
-static void __init zynq_timer_init(void)
+static void __init zynq_init_early(void)
 {
 	zynq_slcr_init();
-	clocksource_of_init();
 }
 
 static struct map_desc zynq_cortex_a9_scu_map __initdata = {
@@ -104,8 +101,8 @@ static const char * const zynq_dt_match[] = {
 DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.smp		= smp_ops(zynq_smp_ops),
 	.map_io		= zynq_map_io,
+	.init_early	= zynq_init_early,
 	.init_machine	= zynq_init_machine,
-	.init_time	= zynq_timer_init,
 	.dt_compat	= zynq_dt_match,
 	.restart	= zynq_system_reset,
 MACHINE_END
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 1836d5a..59ad09f 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -106,8 +106,6 @@ int __init zynq_slcr_init(void)
 
 	pr_info("%s mapped to %p\n", np->name, zynq_slcr_base);
 
-	zynq_clock_init(zynq_slcr_base);
-
 	of_node_put(np);
 
 	return 0;
diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 089d3e3..8fa0de7 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -21,6 +21,7 @@
 #include <linux/clk/zynq.h>
 #include <linux/clk-provider.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/io.h>
@@ -203,9 +204,19 @@ static void __init zynq_clk_setup(struct device_node *np)
 	const char *periph_parents[4];
 	const char *swdt_ext_clk_mux_parents[2];
 	const char *can_mio_mux_parents[NUM_MIO_PINS];
+	struct device_node *slcrnp;
 
 	pr_info("Zynq clock init\n");
 
+	slcrnp = of_find_compatible_node(NULL, NULL, "xlnx,zynq-slcr");
+	if (WARN_ON(!slcrnp))
+		return;
+
+	zynq_slcr_base_priv = of_iomap(slcrnp, 0);
+	of_node_put(slcrnp);
+	if (WARN_ON(!zynq_slcr_base_priv))
+		return;
+	
 	/* get clock output names from DT */
 	for (i = 0; i < clk_max; i++) {
 		if (of_property_read_string_index(np, "clock-output-names",
@@ -528,9 +539,3 @@ static void __init zynq_clk_setup(struct device_node *np)
 }
 
 CLK_OF_DECLARE(zynq_clkc, "xlnx,ps7-clkc", zynq_clk_setup);
-
-void __init zynq_clock_init(void __iomem *slcr_base)
-{
-	zynq_slcr_base_priv = slcr_base;
-	of_clk_init(NULL);
-}
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
index e062d31..58b5516 100644
--- a/include/linux/clk/zynq.h
+++ b/include/linux/clk/zynq.h
@@ -22,8 +22,6 @@
 
 #include <linux/spinlock.h>
 
-void zynq_clock_init(void __iomem *slcr);
-
 struct clk *clk_register_zynq_pll(const char *name, const char *parent,
 		void __iomem *pll_ctrl, void __iomem *pll_status, u8 lock_index,
 		spinlock_t *lock);

--------------010201020507060305010600--
