Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbbAPObG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:31:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50454 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbAPObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:31:02 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-2b-54b920a36dff
From: Paul Osmialowski <p.osmialowsk@samsung.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [PATCH] mmc: sdhci-s3c: solve problem with sleeping in atomic context
Date: Fri, 16 Jan 2015 15:30:05 +0100
Message-id: <1421418605-457-1-git-send-email-p.osmialowsk@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t/xq7pLFHaGGOzhsZhweTujxeVdc9gs
	jvzvZ7SY8OYAs8XxteEOrB53ru1h87jxaiGTR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGXs
	XRlY8ECt4nTXReYGxm7FLkZODgkBE4n/txYwQthiEhfurWfrYuTiEBJYyijRdOkIO4TTyyRx
	/dZENpAqNgFDiZv/D4N1iAg0MUpM/+gLYjML6Es09T9lBrGFBfwkfnW9YwKxWQRUJZo2TgaL
	8wq4SfQuvsoMsU1O4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJgS87
	GBcfszrEKMDBqMTDO2PLjhAh1sSy4srcQ4wSHMxKIrwZAjtDhHhTEiurUovy44tKc1KLDzEy
	cXBKNTCq/u+ax6aSzdHv2vVhq926v1+2nYx4n7JwT89/jwjGdL2dsdOkd+rc1fW7Me+m3to9
	U8XOBbD1Sa7z++0zbckhzeP/si+1zTn7ecUu5aNP7iy/un4K+/+3x9+GsZbpv/H/sCjn48RD
	X7fzvj00YeG/3TpRFo8ergs93VS2nMP33ovqf4qMHut6LiuxFGckGmoxFxUnAgDRFn0x3wEA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change addresses following problem:

[    2.560726] ------------[ cut here ]------------
[    2.565341] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xec/0x118()
[    2.574439] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    2.579821] Modules linked in:
[    2.583038] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.0-next-20141216-00002-g4ff197fc1902-dirty #1318
[    2.593796] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[    2.599892] [<c0014c44>] (unwind_backtrace) from [<c0011bbc>] (show_stack+0x10/0x14)
[    2.607612] [<c0011bbc>] (show_stack) from [<c04953b8>] (dump_stack+0x70/0xbc)
[    2.614822] [<c04953b8>] (dump_stack) from [<c0023444>] (warn_slowpath_common+0x74/0xb0)
[    2.622885] [<c0023444>] (warn_slowpath_common) from [<c0023514>] (warn_slowpath_fmt+0x30/0x40)
[    2.631569] [<c0023514>] (warn_slowpath_fmt) from [<c0063644>] (lockdep_trace_alloc+0xec/0x118)
[    2.640246] [<c0063644>] (lockdep_trace_alloc) from [<c00df52c>] (__kmalloc+0x3c/0x1cc)
[    2.648240] [<c00df52c>] (__kmalloc) from [<c0394970>] (clk_fetch_parent_index+0xb8/0xd4)
[    2.656390] [<c0394970>] (clk_fetch_parent_index) from [<c0394a6c>] (clk_calc_new_rates+0xe0/0x1fc)
[    2.665415] [<c0394a6c>] (clk_calc_new_rates) from [<c0394b40>] (clk_calc_new_rates+0x1b4/0x1fc)
[    2.674181] [<c0394b40>] (clk_calc_new_rates) from [<c0395408>] (clk_set_rate+0x50/0xc8)
[    2.682265] [<c0395408>] (clk_set_rate) from [<c0377708>] (sdhci_cmu_set_clock+0x68/0x16c)
[    2.690503] [<c0377708>] (sdhci_cmu_set_clock) from [<c03735cc>] (sdhci_do_set_ios+0xf0/0x64c)
[    2.699095] [<c03735cc>] (sdhci_do_set_ios) from [<c0373b48>] (sdhci_set_ios+0x20/0x2c)
[    2.707080] [<c0373b48>] (sdhci_set_ios) from [<c035ddf0>] (mmc_power_up+0x118/0x1fc)
[    2.714889] [<c035ddf0>] (mmc_power_up) from [<c035ecd0>] (mmc_start_host+0x44/0x6c)
[    2.722615] [<c035ecd0>] (mmc_start_host) from [<c035fd60>] (mmc_add_host+0x58/0x7c)
[    2.730341] [<c035fd60>] (mmc_add_host) from [<c037454c>] (sdhci_add_host+0x968/0xd94)
[    2.738240] [<c037454c>] (sdhci_add_host) from [<c0377b60>] (sdhci_s3c_probe+0x354/0x52c)
[    2.746406] [<c0377b60>] (sdhci_s3c_probe) from [<c0283b58>] (platform_drv_probe+0x48/0xa4)
[    2.754733] [<c0283b58>] (platform_drv_probe) from [<c02824e8>] (driver_probe_device+0x13c/0x37c)
[    2.763585] [<c02824e8>] (driver_probe_device) from [<c02827bc>] (__driver_attach+0x94/0x98)
[    2.772003] [<c02827bc>] (__driver_attach) from [<c0280a60>] (bus_for_each_dev+0x54/0x88)
[    2.780163] [<c0280a60>] (bus_for_each_dev) from [<c0281b48>] (bus_add_driver+0xe4/0x200)
[    2.788322] [<c0281b48>] (bus_add_driver) from [<c0282dfc>] (driver_register+0x78/0xf4)
[    2.796308] [<c0282dfc>] (driver_register) from [<c00089b0>] (do_one_initcall+0xac/0x1f0)
[    2.804473] [<c00089b0>] (do_one_initcall) from [<c0673d94>] (kernel_init_freeable+0x10c/0x1d8)
[    2.813153] [<c0673d94>] (kernel_init_freeable) from [<c0490058>] (kernel_init+0x28/0x108)
[    2.821398] [<c0490058>] (kernel_init) from [<c000f268>] (ret_from_fork+0x14/0x2c)
[    2.828939] ---[ end trace 03cc00e539849d1f ]---

clk_set_rate() tries to take clk's prepare_lock mutex while being in atomic
context entered in sdhci_do_set_ios().
The solution is inspired by similar situation in sdhci_set_power() also called
from sdhci_do_set_ios():

                spin_unlock_irq(&host->lock);
                mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
                spin_lock_irq(&host->lock);

Note that since sdhci_s3c_set_clock() sets SDHCI_CLOCK_CARD_EN, proposed change
first resets this bit. It is reset anyway (by setting SDHCI_CLOCK_INT_EN bit
only) after call to clk_set_rate() in order to wait for the clock to stabilize
and is set again as soon as the clock becomes stable.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 drivers/mmc/host/sdhci-s3c.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index c45b893..115f556 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -12,6 +12,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
@@ -312,7 +313,14 @@ static void sdhci_cmu_set_clock(struct sdhci_host *host, unsigned int clock)
 
 	sdhci_s3c_set_clock(host, clock);
 
+	/* Reset SD Clock Enable */
+	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+	clk &= ~SDHCI_CLOCK_CARD_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+
+	spin_unlock_irq(&host->lock);
 	ret = clk_set_rate(ourhost->clk_bus[ourhost->cur_clk], clock);
+	spin_lock_irq(&host->lock);
 	if (ret != 0) {
 		dev_err(dev, "%s: failed to set clock rate %uHz\n",
 			mmc_hostname(host->mmc), clock);
-- 
1.9.1

