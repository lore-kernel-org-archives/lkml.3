Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3LRNFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:05:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47430 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab3LRNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:05:15 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: dwc3: dwc3-omap: Fix the crash in module removal
Date: Wed, 18 Dec 2013 18:35:09 +0530
Message-ID: <1387371909-17159-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the wrapper driver the child nodes are populated using
of_platform_populate(), which does a device_add. So while
removing the module if platform_device_unregister is called
it leads to following crash.

[   57.676757] Unable to handle kernel NULL pointer dereference at virtual address 00000018
[   57.685241] pgd = edf7c000
[   57.687988] [00000018] *pgd=add17831, *pte=00000000, *ppte=00000000
[   57.694488] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[   57.699920] Modules linked in: g_mass_storage usb_f_mass_storage libcomposite configfs wlcore_sdio dwc3_omap(-) pixcir_i2c_ts [last unloaded: dwc3]
[   57.713317] CPU: 0 PID: 1580 Comm: rmmod Not tainted 3.12.4-02001-gb1278cc-dirty #21
[   57.721099] task: ed9f8bc0 ti: edfb0000 task.ti: edfb0000
[   57.726562] PC is at release_resource+0x14/0x7c
[   57.731109] LR is at release_resource+0x10/0x7c
[   57.735687] pc : [<c004e278>]    lr : [<c004e274>]    psr: 600f0013
[   57.735687] sp : edfb1eb0  ip : 600f0013  fp : 00021008
[   57.747192] r10: 00000000  r9 : edfb0000  r8 : c00142e8
[   57.752441] r7 : edfb0000  r6 : bf005198  r5 : edd18000  r4 : edfa3e80
[   57.759002] r3 : 00000000  r2 : 00000000  r1 : 00000010  r0 : c09bf394
[   57.765563] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   57.772735] Control: 10c53c7d  Table: adf7c059  DAC: 00000015
[   57.778503] Process rmmod (pid: 1580, stack limit = 0xedfb0248)
[   57.784454] Stack: (0xedfb1eb0 to 0xedfb2000)
[   57.788848] 1ea0:                                     00000000 00000001 edd18000 c03a1870
[   57.797088] 1ec0: edd18010 edd18000 00000000 c03a1b70 00000000 bf0051a4 edd18010 c039c86c
[   57.805297] 1ee0: ed927a40 edd9d9f0 edcc0990 ed97e410 ed97e444 bf00518c bf005120 ed97e410
[   57.813507] 1f00: bf005d54 c03a1594 c03a157c c039fe94 bf005d54 ed97e410 bf005d54 c03a0698
[   57.821746] 1f20: 00000000 bf005d54 c09e4f90 c039fcbc 00000000 bf005d98 00000800 c00abd2c
[   57.829956] 1f40: c09c9920 00000000 bf005d98 00000800 edfb1f44 33637764 616d6f5f 00000070
[   57.838165] 1f60: ed9f8bc0 c0014190 00000001 00000000 edfb0000 bee6ee08 00021008 c00a36e0
[   57.846405] 1f80: 00021088 00000800 00021088 00000081 80000010 00021088 00000800 00021088
[   57.854614] 1fa0: 00000081 c0014100 00021088 00000800 000210b8 00000800 c0514b00 c0514b00
[   57.862823] 1fc0: 00021088 00000800 00021088 00000081 00000001 bee6ebf8 bee6ee08 00021008
[   57.871032] 1fe0: 43098880 bee6ebb4 b6fd59bc 4309888c 80000010 000210b8 0002130c 00000000
[   57.879302] [<c004e278>] (release_resource+0x14/0x7c) from [<c03a1870>] (platform_device_del+0x6c/0x9c)
[   57.888732] [<c03a1870>] (platform_device_del+0x6c/0x9c) from [<c03a1b70>] (platform_device_unregister+0xc/0x18)
[   57.898986] [<c03a1b70>] (platform_device_unregister+0xc/0x18) from [<bf0051a4>] (dwc3_omap_remove_core+0xc/0x14 [dwc3_omap])
[   57.910400] [<bf0051a4>] (dwc3_omap_remove_core+0xc/0x14 [dwc3_omap]) from [<c039c86c>] (device_for_each_child+0x34/0x74)
[   57.921417] [<c039c86c>] (device_for_each_child+0x34/0x74) from [<bf00518c>] (dwc3_omap_remove+0x6c/0x78 [dwc3_omap])
[   57.932067] [<bf00518c>] (dwc3_omap_remove+0x6c/0x78 [dwc3_omap]) from [<c03a1594>] (platform_drv_remove+0x18/0x1c)
[   57.942565] [<c03a1594>] (platform_drv_remove+0x18/0x1c) from [<c039fe94>] (__device_release_driver+0x70/0xc8)
[   57.952606] [<c039fe94>] (__device_release_driver+0x70/0xc8) from [<c03a0698>] (driver_detach+0xb4/0xb8)
[   57.962127] [<c03a0698>] (driver_detach+0xb4/0xb8) from [<c039fcbc>] (bus_remove_driver+0x8c/0xd0)
[   57.971160] [<c039fcbc>] (bus_remove_driver+0x8c/0xd0) from [<c00abd2c>] (SyS_delete_module+0x118/0x22c)
[   57.980712] [<c00abd2c>] (SyS_delete_module+0x118/0x22c) from [<c0014100>] (ret_fast_syscall+0x0/0x48)
[   57.990051] Code: e1a04000 e59f0068 eb175e43 e5943010 (e5932018)
[   57.996368] ---[ end trace 2af5f15c0b475a3d ]---

Replace platform_device_unregister with of_device_unregister.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index b269dbd..d241ff3 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -323,7 +323,7 @@ static int dwc3_omap_remove_core(struct device *dev, void *c)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 
-	platform_device_unregister(pdev);
+	of_device_unregister(pdev);
 
 	return 0;
 }
-- 
1.8.1

