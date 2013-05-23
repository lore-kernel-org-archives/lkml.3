Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3EWKUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:20:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41839 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab3EWKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:19:57 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/1] USB: ehci-omap: Reset dma_mask pointer on probe
Date: Thu, 23 May 2013 13:19:47 +0300
Message-ID: <1369304387-29610-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369304387-29610-1-git-send-email-rogerq@ti.com>
References: <1369304387-29610-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree probed devices don't get dma_mask set. Previously
we were setting the dma_mask pointer only if it was NULL.
However, the address of 'omap_ehci_dma_mask' would change
each time the module is unloaded and loaded back thus causing
the devices dma_mask pointer to be invalid on the next load.

This will cause page faults if any driver tries to access the
old dma_mask pointer.

Unconditionally re-setting the dma_mask pointer fixes this problem.

e.g. of backtrace when mass storage device is plugged in after
ehci-omap module is unloaded and loaded back when booted with device tree.

[  646.398223] Unable to handle kernel paging request at virtual address bf08f678
[  646.406005] pgd = c0004000
[  646.408966] [bf08f678] *pgd=8c9ec811, *pte=00000000, *ppte=00000000
[  646.415649] Internal error: Oops: 7 [#1] SMP ARM
[  646.420532] Modules linked in: ehci_omap ehci_hcd snd_soc_omap snd_soc_omap_mcbsp snd_soc_core regmap_spi snd_compress snd_pcm snd_timer snd soundcore snd_page_alloc [last unloaded: ehci_hcd]
[  646.438629] CPU: 0 PID: 691 Comm: kworker/u2:2 Not tainted 3.10.0-rc2-00047-g519fe2e #490
[  646.447265] Workqueue: events_unbound async_run_entry_fn
[  646.452880] task: ce12cb80 ti: ce194000 task.ti: ce194000
[  646.458618] PC is at scsi_calculate_bounce_limit+0x34/0x48
[  646.464385] LR is at __scsi_alloc_queue+0x80/0x108
[  646.469451] pc : [<c032a680>]    lr : [<c032a714>]    psr: a0000013
[  646.469451] sp : ce195c88  ip : 0000000c  fp : 00000001
[  646.481536] r10: cca4d018  r9 : cca42808  r8 : 00000000
[  646.487060] r7 : 0000012a  r6 : ce527420  r5 : ce3561b0  r4 : ce415000
[  646.493927] r3 : bf08f678  r2 : ce424cd0  r1 : 000000f0  r0 : ce415000
[  646.500823] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  646.508544] Control: 10c5387d  Table: 8c9bc019  DAC: 00000015
[  646.514587] Process kworker/u2:2 (pid: 691, stack limit = 0xce194240)
[  646.521392] Stack: (0xce195c88 to 0xce196000)
[  646.526000] 5c80:                   ffffffff cca42800 cca4d000 ce415000 ffffffe0 c032b978
[  646.534606] 5ca0: cca42800 c032c114 ce12cb80 cca4d000 00000000 ce195d64 00000000 ce415000
[  646.543243] 5cc0: ce194000 00000000 c07b5574 c032c654 00000000 c008c2bc 60000093 ce194000
[  646.551879] 5ce0: ce12cb80 c04cc890 00000001 ce415000 ce194000 00000000 c07b5574 c008c2bc
[  646.560485] 5d00: 60000013 cca4d0a8 00000004 60000013 ffffffff c04cc890 c07b5880 cca4d000
[  646.569122] 5d20: 00000000 00000000 ce415180 ffffffff ce194000 00000000 c07b5574 c032cf40
[  646.577758] 5d40: 00000000 00000000 ce195d8c 00000000 c08a8208 00000000 00000002 00000000
[  646.586364] 5d60: ce415220 00000000 00000000 00000000 00000002 ce12d010 ce12cb80 00000006
[  646.595001] 5d80: 00000004 c07b932c 00000006 c008c0fc 00000000 ce12cb80 ce415180 ce194000
[  646.603637] 5da0: ce12cb80 c04cc890 00000001 ffffffff ce194000 ce415068 c07b5574 c008c2bc
[  646.612243] 5dc0: 60000013 00000001 ce415000 00000000 ffffffff 00000000 ce194000 ce415180
[  646.620880] 5de0: c07b5574 c032d400 00000000 ce415000 ce415180 ce415000 ffffffff ffffffff
[  646.629516] 5e00: 00000000 ce415180 ce415068 c032d708 cc9759c0 c00690bc 0000005d ce415000
[  646.638122] 5e20: ce329940 ccae4300 ce195ec0 ccb26dd0 ccb26dc0 c032d824 00000000 00000000
[  646.646759] 5e40: c07b6f1c ce329940 ccae4300 c032d9c4 00000000 c07b6f1c ce329940 ce03f000
[  646.655395] 5e60: ce195ec0 c0065384 00000000 00000000 60000013 ce047f00 ce03f000 ccb26dd0
[  646.664001] 5e80: ce329940 ccb26dd0 ce329940 ce03f000 ce195ec0 00000000 ce047f00 c005842c
[  646.672637] 5ea0: 00000002 00000000 c00583a0 c04ca4d4 ce12cb80 00000002 00000000 00000000
[  646.681274] 5ec0: c07cb97c c08a8128 00000000 c06187b0 ce03f000 ce329940 ce03f030 ce329958
[  646.689910] 5ee0: ce194000 ce194000 c07b5208 00000001 ce03f000 c0058b10 00000000 00000000
[  646.698516] 5f00: 00000000 ce194000 60000113 ce0a1e34 00000000 ce329940 c00589d8 00000000
[  646.707153] 5f20: 00000000 00000000 00000000 c005ebec ce12cb80 00000000 00000001 ce329940
[  646.715789] 5f40: 00000000 00000000 dead4ead ffffffff ffffffff c07cb8f4 00000000 00000000
[  646.724395] 5f60: c0615efc ce195f64 ce195f64 00000000 00000000 dead4ead ffffffff ffffffff
[  646.733032] 5f80: c07cb8f4 00000000 00000000 c0615efc ce195f90 ce195f90 ce195fac ce0a1e34
[  646.741668] 5fa0: c005eb48 00000000 00000000 c0013688 00000000 00000000 00000000 00000000
[  646.750274] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  646.758911] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 2a7fef02 00b3ff00
[  646.767547] [<c032a680>] (scsi_calculate_bounce_limit+0x34/0x48) from [<c032a714>] (__scsi_alloc_queue+0x80/0x108)
[  646.778472] [<c032a714>] (__scsi_alloc_queue+0x80/0x108) from [<c032b978>] (scsi_alloc_queue+0x10/0x60)
[  646.788391] [<c032b978>] (scsi_alloc_queue+0x10/0x60) from [<c032c114>] (scsi_alloc_sdev+0x170/0x270)
[  646.798126] [<c032c114>] (scsi_alloc_sdev+0x170/0x270) from [<c032c654>] (scsi_probe_and_add_lun+0x39c/0x948)
[  646.808593] [<c032c654>] (scsi_probe_and_add_lun+0x39c/0x948) from [<c032cf40>] (__scsi_scan_target+0xd4/0x53c)
[  646.819244] [<c032cf40>] (__scsi_scan_target+0xd4/0x53c) from [<c032d400>] (scsi_scan_channel.part.2+0x58/0x6c)
[  646.829895] [<c032d400>] (scsi_scan_channel.part.2+0x58/0x6c) from [<c032d708>] (scsi_scan_host_selected+0xd0/0x168)
[  646.840972] [<c032d708>] (scsi_scan_host_selected+0xd0/0x168) from [<c032d824>] (do_scsi_scan_host+0x84/0x8c)
[  646.851440] [<c032d824>] (do_scsi_scan_host+0x84/0x8c) from [<c032d9c4>] (do_scan_async+0x10/0x164)
[  646.860992] [<c032d9c4>] (do_scan_async+0x10/0x164) from [<c0065384>] (async_run_entry_fn+0x40/0x180)
[  646.870727] [<c0065384>] (async_run_entry_fn+0x40/0x180) from [<c005842c>] (process_one_work+0x1b4/0x49c)
[  646.880828] [<c005842c>] (process_one_work+0x1b4/0x49c) from [<c0058b10>] (worker_thread+0x138/0x37c)
[  646.890563] [<c0058b10>] (worker_thread+0x138/0x37c) from [<c005ebec>] (kthread+0xa4/0xb0)
[  646.899291] [<c005ebec>] (kthread+0xa4/0xb0) from [<c0013688>] (ret_from_fork+0x14/0x2c)
[  646.907836] Code: e3530000 0a000003 e59331b8 e3530000 (11c320d0)
[  646.914367] ---[ end trace 157a5b85fcd31f7f ]---

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 3d1491b..b33e306 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -146,8 +146,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &omap_ehci_dma_mask;
+	pdev->dev.dma_mask = &omap_ehci_dma_mask;
 
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, dev,
 			dev_name(dev));
-- 
1.7.4.1

