Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbaHGQHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:07:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43977 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbaHGQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:07:15 -0400
X-AuditID: cbfee61a-f79e46d00000134f-78-53e3a431bff2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-mmc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-s3c: fix runtime PM handling on sdhci_add_host()
 failure
Date: Thu, 07 Aug 2014 18:07:07 +0200
Message-id: <5567000.WJnOP5ckul@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQV3DJY+DDfZ2K1tMWneAyeLf7FNs
	FhMub2e0uPGrjdXibNMbdovLu+awWRz5389oMeP8PiaL42vDHTg9/q56wexx59oeNo+XE3+z
	edx4tZDJo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDLuTNnJWPBPsWLJ3RXMDYwrZbsYOTkk
	BEwk9h38xARhi0lcuLeerYuRi0NIYDqjxIlnDcwQTguTxKy9i5lBqtgErCQmtq9iBLFFBBQl
	ji+dww5SxCywiUni89GNYEXCAmESj86vYQOxWQRUJU40vgOL8wpoSmyZ8wAsLirgKbFj+0o2
	iLigxI/J91hAbGYBeYl9+6eyQthaEut3HmeawMg3C0nZLCRls5CULWBkXsUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHNTPpHYwrmywOMQowMGoxMMr0P04WIg1say4MvcQowQHs5IIry5I
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6Ne5NQlL5J3
	G9w8t6PmVME/zf0r+WMNhS9L5ugs1uoWz70p8K1KYuE869ObbUOW2U08OkFns9XdK/szztiI
	SLy5XPhwb8qGEhFbD4OYx3u35/3rj919cGXmg4zaf9XyJ29Nv3Swfu6v9m9Tfi4MV/yucahu
	0/RP2hF7TWZdPxHZu3i55eyta536lViKMxINtZiLihMBLezETGYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime Power Management handling for the sdhci_add_host() failure
case in sdhci_s3c_probe() should match the code in sdhci_s3c_remove()
(which uses pm_runtime_disable() call which matches the earlier
pm_runtime_enable() one).  Fix it.

This patch fixes "BUG: spinlock bad magic on CPU#0, swapper/0/1" and
"Unbalanced pm_runtime_enable!" warnings.

>From the kernel log:
...
[    1.659631] s3c-sdhci 12530000.sdhci: sdhci_add_host() failed
[    1.665096] BUG: spinlock bad magic on CPU#0, swapper/0/1
[    1.670433]  lock: 0xea01e484, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    1.677895] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-next-20140804-00008-ga59480f-dirty #707
[    1.687037] [<c0013ae4>] (unwind_backtrace) from [<c0010d70>] (show_stack+0x10/0x14)
[    1.694740] [<c0010d70>] (show_stack) from [<c04050c8>] (dump_stack+0x68/0xb8)
[    1.701948] [<c04050c8>] (dump_stack) from [<c0052558>] (do_raw_spin_lock+0x15c/0x1a4)
[    1.709848] [<c0052558>] (do_raw_spin_lock) from [<c040a630>] (_raw_spin_lock_irqsave+0x20/0x28)
[    1.718619] [<c040a630>] (_raw_spin_lock_irqsave) from [<c030d7d0>] (sdhci_do_set_ios+0x1c/0x5cc)
[    1.727464] [<c030d7d0>] (sdhci_do_set_ios) from [<c030ddfc>] (sdhci_runtime_resume_host+0x50/0x104)
[    1.736574] [<c030ddfc>] (sdhci_runtime_resume_host) from [<c02462dc>] (pm_generic_runtime_resume+0x2c/0x40)
[    1.746383] [<c02462dc>] (pm_generic_runtime_resume) from [<c0247898>] (__rpm_callback+0x34/0x70)
[    1.755233] [<c0247898>] (__rpm_callback) from [<c02478fc>] (rpm_callback+0x28/0x88)
[    1.762958] [<c02478fc>] (rpm_callback) from [<c02486f0>] (rpm_resume+0x384/0x4ec)
[    1.770511] [<c02486f0>] (rpm_resume) from [<c02488b0>] (pm_runtime_forbid+0x58/0x64)
[    1.778325] [<c02488b0>] (pm_runtime_forbid) from [<c030ea70>] (sdhci_s3c_probe+0x4a4/0x540)
[    1.786749] [<c030ea70>] (sdhci_s3c_probe) from [<c02429cc>] (platform_drv_probe+0x2c/0x5c)
[    1.795076] [<c02429cc>] (platform_drv_probe) from [<c02415f0>] (driver_probe_device+0x114/0x234)
[    1.803929] [<c02415f0>] (driver_probe_device) from [<c024179c>] (__driver_attach+0x8c/0x90)
[    1.812347] [<c024179c>] (__driver_attach) from [<c023ffb4>] (bus_for_each_dev+0x54/0x88)
[    1.820506] [<c023ffb4>] (bus_for_each_dev) from [<c0240df8>] (bus_add_driver+0xd8/0x1cc)
[    1.828665] [<c0240df8>] (bus_add_driver) from [<c0241db8>] (driver_register+0x78/0xf4)
[    1.836652] [<c0241db8>] (driver_register) from [<c00088a4>] (do_one_initcall+0x80/0x1d0)
[    1.844816] [<c00088a4>] (do_one_initcall) from [<c059ac94>] (kernel_init_freeable+0x108/0x1d4)
[    1.853503] [<c059ac94>] (kernel_init_freeable) from [<c0401300>] (kernel_init+0x8/0xe4)
[    1.861568] [<c0401300>] (kernel_init) from [<c000e538>] (ret_from_fork+0x14/0x3c)
[    1.869582] platform 12530000.sdhci: Driver s3c-sdhci requests probe deferral
...
[    1.997047] s3c-sdhci 12530000.sdhci: Unbalanced pm_runtime_enable!
...
[    2.027235] s3c-sdhci 12530000.sdhci: sdhci_add_host() failed
[    2.032884] platform 12530000.sdhci: Driver s3c-sdhci requests probe deferral
...

Tested on Hardkernel's Exynos4412 based ODROID-U3 board.

Fixes: 9f4e8151dbbc ("mmc: sdhci-s3c: Enable runtime power management")
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
patch is against next-20140804 branch of linux-next kernel

 drivers/mmc/host/sdhci-s3c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index fa5954a..1e47903 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -606,8 +606,6 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
 	ret = sdhci_add_host(host);
 	if (ret) {
 		dev_err(dev, "sdhci_add_host() failed\n");
-		pm_runtime_forbid(&pdev->dev);
-		pm_runtime_get_noresume(&pdev->dev);
 		goto err_req_regs;
 	}
 
@@ -618,6 +616,8 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
 	return 0;
 
  err_req_regs:
+	pm_runtime_disable(&pdev->dev);
+
  err_no_busclks:
 	clk_disable_unprepare(sc->clk_io);
 
-- 
1.8.2.3


