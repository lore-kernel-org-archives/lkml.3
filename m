Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbaD3Kgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:36:35 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53248 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727AbaD3Kgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:36:31 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-spi@vger.kernel.org, broonie@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] spi: Fix hung task timeout when initialization fails
Date: Wed, 30 Apr 2014 12:36:11 +0200
Message-Id: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "786235eeba0e1e85e5cbbb9f97d1087ad03dfa21 kthread:
make kthread_create() killable" kthread_run can be killed by the user,
ie, by killing modprobe.

When this happens spi_destroy_queue() fails to cleanout the resources
ending up in a hung process that outputs a error message and avoids
the computer to be halted.

This bug is particulary critical on machines that relay on the spi
subsystem to hold a file system (MTD over SPI).

[   95.900328] spi_master spi32765: failed to create message pump task
[   95.900358] spi_master spi32765: problem initializing queue
[   95.912333] qtec_pcie b0030000.pcie_bridge: Axi-pcie bridge supervisor
[  240.463698] INFO: task udevd:129 blocked for more than 120 seconds.
[  240.463724]       Not tainted 3.13.0-qtec-standard+ #191
[  240.463733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.463743] udevd           D ffff880087815ac0     0   129    118 0x00000006
[  240.463762]  ffff880086593590 0000000000000002 ffff880087815ac0 ffff880086593fd8
[  240.463778]  0000000000012c00 0000000000012c00 ffff880087815ac0 ffff880086593520
[  240.463792]  ffffffff813debe7 ffffffff810be6df ffffffff81da539c 0000000000000000
[  240.463807] Call Trace:
[  240.463836]  [<ffffffff813debe7>] ? vt_console_print+0x57/0x3e0
[  240.463852]  [<ffffffff810be6df>] ? print_prefix+0x6f/0xb0
[  240.463867]  [<ffffffff810bf45c>] ? wake_up_klogd+0x3c/0x50
[  240.463880]  [<ffffffff810bf67b>] ? console_unlock+0x20b/0x3f0
[  240.463897]  [<ffffffff8178b799>] schedule+0x29/0x70
[  240.463910]  [<ffffffff8178a8d9>] schedule_timeout+0x189/0x240
[  240.463925]  [<ffffffff813fd510>] ? dev_vprintk_emit+0x50/0x60
[  240.463939]  [<ffffffff8178c167>] wait_for_common+0xe7/0x190
[  240.463954]  [<ffffffff810a7780>] ? wake_up_process+0x40/0x40
[  240.463968]  [<ffffffff8178c22d>] wait_for_completion+0x1d/0x20
[  240.463981]  [<ffffffff810996bc>] flush_kthread_worker+0x6c/0x80
[  240.463995]  [<ffffffff8178c2cd>] ? wait_for_completion_killable+0x1d/0x40
[  240.464007]  [<ffffffff81099162>] ? kthread_create_on_node+0xd2/0x190
[  240.464020]  [<ffffffff81099000>] ? kthread_freezable_should_stop+0x80/0x80
[  240.464036]  [<ffffffff8146c637>] spi_destroy_queue+0x27/0x60
[  240.464050]  [<ffffffff8146cc46>] spi_register_master+0x5d6/0x900
[  240.464072]  [<ffffffffa0000713>] spi_bitbang_start+0x83/0x110 [spi_bitbang]
[  240.464089]  [<ffffffffa0005960>] xilinx_spi_probe+0x230/0x3aa [spi_xilinx]
[  240.464104]  [<ffffffff81403645>] platform_drv_probe+0x45/0xb0
[  240.464120]  [<ffffffff81401052>] ? driver_sysfs_add+0x82/0xb0
[  240.464134]  [<ffffffff81401795>] driver_probe_device+0x125/0x3b0
[  240.464149]  [<ffffffff81401a20>] ? driver_probe_device+0x3b0/0x3b0
[  240.464163]  [<ffffffff81401a5b>] __device_attach+0x3b/0x40
[  240.464177]  [<ffffffff813ff7c3>] bus_for_each_drv+0x63/0xa0
[  240.464191]  [<ffffffff814015f8>] device_attach+0x88/0xa0
[  240.464205]  [<ffffffff81400a08>] bus_probe_device+0x98/0xc0
[  240.464218]  [<ffffffff813fe865>] device_add+0x495/0x600
[  240.464233]  [<ffffffff815d860f>] of_device_add+0x2f/0x40
[  240.464246]  [<ffffffff815d8dab>] of_platform_device_create_pdata+0x6b/0xb0
[  240.464259]  [<ffffffff815d8f03>] of_platform_bus_create+0xf3/0x200
[  240.464272]  [<ffffffff815d7228>] ? __of_match_node+0x48/0xe0
[  240.464286]  [<ffffffff815d8f5e>] of_platform_bus_create+0x14e/0x200
[  240.464298]  [<ffffffff815d6adc>] ? __of_find_property+0x3c/0x80
[  240.464312]  [<ffffffff815d9177>] of_platform_populate+0x47/0x90
[  240.464334]  [<ffffffffa000bcf2>] qt5023_of_populate+0x562/0x980 [qt5023]
[  240.464357]  [<ffffffffa000c363>] qt5023_of_probe+0x1d3/0x300 [qt5023]
[  240.464472]  [<ffffffffa000a123>] qt5023_pci_probe+0xd3/0x1c0 [qt5023]
[  240.464491]  [<ffffffff813682d4>] pci_device_probe+0x84/0xe0
[  240.464507]  [<ffffffff81401795>] driver_probe_device+0x125/0x3b0
[  240.464522]  [<ffffffff81401af3>] __driver_attach+0x93/0xa0
[  240.464536]  [<ffffffff81401a60>] ? __device_attach+0x40/0x40
[  240.464550]  [<ffffffff813ff703>] bus_for_each_dev+0x63/0xa0
[  240.464585]  [<ffffffff8140114e>] driver_attach+0x1e/0x20
[  240.464640]  [<ffffffff81400d30>] bus_add_driver+0x180/0x250
[  240.464687]  [<ffffffffa0010000>] ? 0xffffffffa000ffff
[  240.464738]  [<ffffffff81402164>] driver_register+0x64/0xf0
[  240.464789]  [<ffffffffa0010000>] ? 0xffffffffa000ffff
[  240.464845]  [<ffffffff81367d9b>] __pci_register_driver+0x4b/0x50
[  240.464899]  [<ffffffffa0010031>] qt5023_init+0x31/0x33 [qt5023]
[  240.464943]  [<ffffffff810002f2>] do_one_initcall+0xd2/0x180
[  240.464960]  [<ffffffff8109da88>] ? __blocking_notifier_call_chain+0x58/0x70
[  240.464976]  [<ffffffff810e07c6>] load_module+0x1ad6/0x23a0
[  240.464992]  [<ffffffff810dd5d0>] ? store_uevent+0x40/0x40
[  240.465010]  [<ffffffff810de5ea>] ? copy_module_from_fd.isra.50+0x12a/0x190
[  240.465024]  [<ffffffff810e1226>] SyS_finit_module+0x86/0xb0
[  240.465041]  [<ffffffff81797049>] tracesys+0xd0/0xd5
[  360.540806] INFO: task udevd:129 blocked for more than 120 seconds.
[  360.540832]       Not tainted 3.13.0-qtec-standard+ #191
[  360.540841] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.540851] udevd           D ffff880087815ac0     0   129    118 0x00000006
[  360.540871]  ffff880086593590 0000000000000002 ffff880087815ac0 ffff880086593fd8
[  360.540886]  0000000000012c00 0000000000012c00 ffff880087815ac0 ffff880086593520
[  360.540900]  ffffffff813debe7 ffffffff810be6df ffffffff81da539c 0000000000000000
[  360.540915] Call Trace:
[  360.540943]  [<ffffffff813debe7>] ? vt_console_print+0x57/0x3e0
[  360.540959]  [<ffffffff810be6df>] ? print_prefix+0x6f/0xb0
[  360.540974]  [<ffffffff810bf45c>] ? wake_up_klogd+0x3c/0x50
[  360.540988]  [<ffffffff810bf67b>] ? console_unlock+0x20b/0x3f0
[  360.541004]  [<ffffffff8178b799>] schedule+0x29/0x70
[  360.541017]  [<ffffffff8178a8d9>] schedule_timeout+0x189/0x240
[  360.541032]  [<ffffffff813fd510>] ? dev_vprintk_emit+0x50/0x60
[  360.541046]  [<ffffffff8178c167>] wait_for_common+0xe7/0x190
[  360.541061]  [<ffffffff810a7780>] ? wake_up_process+0x40/0x40
[  360.541075]  [<ffffffff8178c22d>] wait_for_completion+0x1d/0x20
[  360.541089]  [<ffffffff810996bc>] flush_kthread_worker+0x6c/0x80
[  360.541102]  [<ffffffff8178c2cd>] ? wait_for_completion_killable+0x1d/0x40
[  360.541115]  [<ffffffff81099162>] ? kthread_create_on_node+0xd2/0x190
[  360.541127]  [<ffffffff81099000>] ? kthread_freezable_should_stop+0x80/0x80
[  360.541144]  [<ffffffff8146c637>] spi_destroy_queue+0x27/0x60
[  360.541157]  [<ffffffff8146cc46>] spi_register_master+0x5d6/0x900
[  360.541179]  [<ffffffffa0000713>] spi_bitbang_start+0x83/0x110 [spi_bitbang]
[  360.541196]  [<ffffffffa0005960>] xilinx_spi_probe+0x230/0x3aa [spi_xilinx]
[  360.541211]  [<ffffffff81403645>] platform_drv_probe+0x45/0xb0
[  360.541226]  [<ffffffff81401052>] ? driver_sysfs_add+0x82/0xb0
[  360.541240]  [<ffffffff81401795>] driver_probe_device+0x125/0x3b0
[  360.541255]  [<ffffffff81401a20>] ? driver_probe_device+0x3b0/0x3b0
[  360.541269]  [<ffffffff81401a5b>] __device_attach+0x3b/0x40
[  360.541283]  [<ffffffff813ff7c3>] bus_for_each_drv+0x63/0xa0
[  360.541297]  [<ffffffff814015f8>] device_attach+0x88/0xa0
[  360.541311]  [<ffffffff81400a08>] bus_probe_device+0x98/0xc0
[  360.541324]  [<ffffffff813fe865>] device_add+0x495/0x600
[  360.541339]  [<ffffffff815d860f>] of_device_add+0x2f/0x40
[  360.541352]  [<ffffffff815d8dab>] of_platform_device_create_pdata+0x6b/0xb0
[  360.541366]  [<ffffffff815d8f03>] of_platform_bus_create+0xf3/0x200
[  360.541378]  [<ffffffff815d7228>] ? __of_match_node+0x48/0xe0
[  360.541392]  [<ffffffff815d8f5e>] of_platform_bus_create+0x14e/0x200
[  360.541404]  [<ffffffff815d6adc>] ? __of_find_property+0x3c/0x80
[  360.541418]  [<ffffffff815d9177>] of_platform_populate+0x47/0x90
[  360.541441]  [<ffffffffa000bcf2>] qt5023_of_populate+0x562/0x980 [qt5023]
[  360.541463]  [<ffffffffa000c363>] qt5023_of_probe+0x1d3/0x300 [qt5023]
[  360.541484]  [<ffffffffa000a123>] qt5023_pci_probe+0xd3/0x1c0 [qt5023]
[  360.541502]  [<ffffffff813682d4>] pci_device_probe+0x84/0xe0
[  360.541517]  [<ffffffff81401795>] driver_probe_device+0x125/0x3b0
[  360.541620]  [<ffffffff81401af3>] __driver_attach+0x93/0xa0
[  360.541636]  [<ffffffff81401a60>] ? __device_attach+0x40/0x40
[  360.541650]  [<ffffffff813ff703>] bus_for_each_dev+0x63/0xa0
[  360.541665]  [<ffffffff8140114e>] driver_attach+0x1e/0x20
[  360.541680]  [<ffffffff81400d30>] bus_add_driver+0x180/0x250
[  360.541748]  [<ffffffffa0010000>] ? 0xffffffffa000ffff
[  360.541793]  [<ffffffff81402164>] driver_register+0x64/0xf0
[  360.541845]  [<ffffffffa0010000>] ? 0xffffffffa000ffff
[  360.541895]  [<ffffffff81367d9b>] __pci_register_driver+0x4b/0x50
[  360.541954]  [<ffffffffa0010031>] qt5023_init+0x31/0x33 [qt5023]
[  360.542007]  [<ffffffff810002f2>] do_one_initcall+0xd2/0x180
[  360.542062]  [<ffffffff8109da88>] ? __blocking_notifier_call_chain+0x58/0x70
[  360.542085]  [<ffffffff810e07c6>] load_module+0x1ad6/0x23a0
[  360.542101]  [<ffffffff810dd5d0>] ? store_uevent+0x40/0x40
[  360.542119]  [<ffffffff810de5ea>] ? copy_module_from_fd.isra.50+0x12a/0x190
[  360.542133]  [<ffffffff810e1226>] SyS_finit_module+0x86/0xb0
[  360.542150]  [<ffffffff81797049>] tracesys+0xd0/0xd5

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4eb9bf0..8331556 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1114,8 +1114,10 @@ static int spi_destroy_queue(struct spi_master *master)
 		return ret;
 	}
 
-	flush_kthread_worker(&master->kworker);
-	kthread_stop(master->kworker_task);
+	if (!IS_ERR(master->kworker_task)) {
+		flush_kthread_worker(&master->kworker);
+		kthread_stop(master->kworker_task);
+	}
 
 	return 0;
 }
-- 
1.9.2

