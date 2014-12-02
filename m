Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaLBTfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:35:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715AbaLBT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 040/121] spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM
Date: Tue,  2 Dec 2014 11:18:39 -0800
Message-Id: <1417548000-1794-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 2b9375b91bef65b837bed61a05fb387159b38ddf upstream.

If PM_RUNTIME is enabled, it is easy to trigger the following backtrace
on pxa2xx hosts:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at /home/lumag/linux/arch/arm/mach-pxa/clock.c:35 clk_disable+0xa0/0xa8()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-00007-g1b3d2ee-dirty #104
[<c000de68>] (unwind_backtrace) from [<c000c078>] (show_stack+0x10/0x14)
[<c000c078>] (show_stack) from [<c001d75c>] (warn_slowpath_common+0x6c/0x8c)
[<c001d75c>] (warn_slowpath_common) from [<c001d818>] (warn_slowpath_null+0x1c/0x24)
[<c001d818>] (warn_slowpath_null) from [<c0015e80>] (clk_disable+0xa0/0xa8)
[<c0015e80>] (clk_disable) from [<c02507f8>] (pxa2xx_spi_suspend+0x2c/0x34)
[<c02507f8>] (pxa2xx_spi_suspend) from [<c0200360>] (platform_pm_suspend+0x2c/0x54)
[<c0200360>] (platform_pm_suspend) from [<c0207fec>] (dpm_run_callback.isra.14+0x2c/0x74)
[<c0207fec>] (dpm_run_callback.isra.14) from [<c0209254>] (__device_suspend+0x120/0x2f8)
[<c0209254>] (__device_suspend) from [<c0209a94>] (dpm_suspend+0x50/0x208)
[<c0209a94>] (dpm_suspend) from [<c00455ac>] (suspend_devices_and_enter+0x8c/0x3a0)
[<c00455ac>] (suspend_devices_and_enter) from [<c0045ad4>] (pm_suspend+0x214/0x2a8)
[<c0045ad4>] (pm_suspend) from [<c04b5c34>] (test_suspend+0x14c/0x1dc)
[<c04b5c34>] (test_suspend) from [<c000880c>] (do_one_initcall+0x8c/0x1fc)
[<c000880c>] (do_one_initcall) from [<c04aecfc>] (kernel_init_freeable+0xf4/0x1b4)
[<c04aecfc>] (kernel_init_freeable) from [<c0378078>] (kernel_init+0x8/0xec)
[<c0378078>] (kernel_init) from [<c0009590>] (ret_from_fork+0x14/0x24)
---[ end trace 46524156d8faa4f6 ]---

This happens because suspend function tries to disable a clock that is
already disabled by runtime_suspend callback. Add if
(!pm_runtime_suspended()) checks to suspend/resume path.

Fixes: 7d94a505858 (spi/pxa2xx: add support for runtime PM)
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Reported-by: Andrea Adami <andrea.adami@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-pxa2xx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 4dc7036..dc907e5 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1280,7 +1280,9 @@ static int pxa2xx_spi_suspend(struct device *dev)
 	if (status != 0)
 		return status;
 	write_SSCR0(0, drv_data->ioaddr);
-	clk_disable_unprepare(ssp->clk);
+
+	if (!pm_runtime_suspended(dev))
+		clk_disable_unprepare(ssp->clk);
 
 	return 0;
 }
@@ -1294,7 +1296,8 @@ static int pxa2xx_spi_resume(struct device *dev)
 	pxa2xx_spi_dma_resume(drv_data);
 
 	/* Enable the SSP clock */
-	clk_prepare_enable(ssp->clk);
+	if (!pm_runtime_suspended(dev))
+		clk_prepare_enable(ssp->clk);
 
 	/* Restore LPSS private register bits */
 	lpss_ssp_setup(drv_data);
-- 
1.9.1

