Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbaJIVKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbaJIVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 080/163] spi: dw: Don't use devm_kzalloc in master->setup callback
Date: Thu,  9 Oct 2014 14:01:45 -0700
Message-Id: <1412888588-26755-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit a97c883a16da7e0691a3be5465926c92a8da4da6 upstream.

device_add() expects that any memory allocated via devm_* API is only
done in the device's probe function.

Fix below boot warning:
WARNING: CPU: 1 PID: 1 at drivers/base/dd.c:286 driver_probe_device+0x2b4/0x2f4()
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.16.0-10474-g835c90b-dirty #160
[<c0016364>] (unwind_backtrace) from [<c001251c>] (show_stack+0x20/0x24)
[<c001251c>] (show_stack) from [<c04eaefc>] (dump_stack+0x7c/0x98)
[<c04eaefc>] (dump_stack) from [<c0023d4c>] (warn_slowpath_common+0x78/0x9c)
[<c0023d4c>] (warn_slowpath_common) from [<c0023d9c>] (warn_slowpath_null+0x2c/0x34)
[<c0023d9c>] (warn_slowpath_null) from [<c0302c60>] (driver_probe_device+0x2b4/0x2f4)
[<c0302c60>] (driver_probe_device) from [<c0302d90>] (__device_attach+0x50/0x54)
[<c0302d90>] (__device_attach) from [<c0300e60>] (bus_for_each_drv+0x54/0x9c)
[<c0300e60>] (bus_for_each_drv) from [<c0302958>] (device_attach+0x84/0x90)
[<c0302958>] (device_attach) from [<c0301f10>] (bus_probe_device+0x94/0xb8)
[<c0301f10>] (bus_probe_device) from [<c03000c0>] (device_add+0x434/0x4fc)
[<c03000c0>] (device_add) from [<c0342dd4>] (spi_add_device+0x98/0x164)
[<c0342dd4>] (spi_add_device) from [<c03444a4>] (spi_register_master+0x598/0x768)
[<c03444a4>] (spi_register_master) from [<c03446b4>] (devm_spi_register_master+0x40/0x80)
[<c03446b4>] (devm_spi_register_master) from [<c0346214>] (dw_spi_add_host+0x1a8/0x258)
[<c0346214>] (dw_spi_add_host) from [<c0346920>] (dw_spi_mmio_probe+0x1d4/0x294)
[<c0346920>] (dw_spi_mmio_probe) from [<c0304560>] (platform_drv_probe+0x3c/0x6c)
[<c0304560>] (platform_drv_probe) from [<c0302a98>] (driver_probe_device+0xec/0x2f4)
[<c0302a98>] (driver_probe_device) from [<c0302d3c>] (__driver_attach+0x9c/0xa0)
[<c0302d3c>] (__driver_attach) from [<c0300f0c>] (bus_for_each_dev+0x64/0x98)
[<c0300f0c>] (bus_for_each_dev) from [<c0302518>] (driver_attach+0x2c/0x30)
[<c0302518>] (driver_attach) from [<c0302134>] (bus_add_driver+0xdc/0x1f4)
[<c0302134>] (bus_add_driver) from [<c03035c8>] (driver_register+0x88/0x104)
[<c03035c8>] (driver_register) from [<c030445c>] (__platform_driver_register+0x58/0x6c)
[<c030445c>] (__platform_driver_register) from [<c0700f00>] (dw_spi_mmio_driver_init+0x18/0x20)
[<c0700f00>] (dw_spi_mmio_driver_init) from [<c0008914>] (do_one_initcall+0x90/0x1d4)
[<c0008914>] (do_one_initcall) from [<c06d7d90>] (kernel_init_freeable+0x178/0x248)
[<c06d7d90>] (kernel_init_freeable) from [<c04e687c>] (kernel_init+0x18/0xfc)
[<c04e687c>] (kernel_init) from [<c000ecd8>] (ret_from_fork+0x14/0x20)

Reported-by: Thor Thayer <tthayer@opensource.altera.com>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kamal: backport to 3.13-stable: was not using devm_kzalloc; only needed
  the set-NULL in dw_spi_cleanup. ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-dw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index b897c4ad..07fa943 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -675,6 +675,7 @@ static void dw_spi_cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 	kfree(chip);
+	spi_set_ctldata(spi, NULL);
 }
 
 static int init_queue(struct dw_spi *dws)
-- 
1.9.1

