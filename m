Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaHGCbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:31:52 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51456 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754423AbaHGCbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:31:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,279,1406563200"; 
   d="scan'208";a="34288531"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>
CC: <isimatu.yasuaki@jp.fujitsu.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ACPI: Check if acpi_device->handler is NULL when ACPI_HOTPLUG_MEMORY is not configured.
Date: Fri, 8 Aug 2014 10:30:45 +0800
Message-ID: <1407465045-4726-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ACPI_HOTPLUG_MEMORY is not configured, memory_device_handler.attach is not set.
And in acpi_scan_attach_handler(), the acpi_device->handler will not be initialized.

In acpi_scan_hot_remove(), it doesn't check if acpi_device->handler is NULL.
If we do memory hot-remove without ACPI_HOTPLUG_MEMORY configured, the kernel
will panic.

[  250.304538] BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
[  250.304960] IP: [<ffffffff813e318f>] acpi_device_hotplug+0x1d7/0x4c4
[  250.305120] PGD 0
[  250.305120] Oops: 0000 [#1] SMP
[  250.305120] Modules linked in: sd_mod(E) sr_mod(E) cdrom(E) crc_t10dif(E) crct10dif_common(E) ata_piix(E) libata(E)
[  250.305120] CPU: 0 PID: 41 Comm: kworker/u2:1 Tainted: G            E 3.16.0-rc7--3.16-rc7-tangchen+ #20
[  250.305120] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  250.305120] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  250.305120] task: ffff8800182436c0 ti: ffff880018254000 task.ti: ffff880018254000
[  250.305120] RIP: 0010:[<ffffffff813e318f>]  [<ffffffff813e318f>] acpi_device_hotplug+0x1d7/0x4c4
[  250.305120] RSP: 0000:ffff880018257da8  EFLAGS: 00000246
[  250.305120] RAX: 0000000000000000 RBX: ffff88001cd8d800 RCX: 0000000000000000
[  250.305120] RDX: 0000000000000000 RSI: ffff88001e40e6f8 RDI: 0000000000000246
[  250.305120] RBP: ffff880018257df0 R08: 0000000000000096 R09: 00000000000011a0
[  250.305120] R10: 63735f6970636120 R11: 725f746f685f6e61 R12: 0000000000000003
[  250.305120] R13: ffff88001cc1c400 R14: ffff88001e062028 R15: 0000000000000040
[  250.305120] FS:  0000000000000000(0000) GS:ffff88001e400000(0000) knlGS:0000000000000000
[  250.305120] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  250.305120] CR2: 0000000000000088 CR3: 000000001a9a2000 CR4: 00000000000006f0
[  250.305120] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  250.305120] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  250.305120] Stack:
[  250.305120]  00000000523cab58 ffff88001cd8d9f8 ffff88001852d480 00000000523cab58
[  250.305120]  ffff88001852d480 ffff880018221e40 ffff88001cc1c400 ffff88001cce2d00
[  250.305120]  0000000000000040 ffff880018257e08 ffffffff813dc31d ffff88001852d480
[  250.305120] Call Trace:
[  250.305120]  [<ffffffff813dc31d>] acpi_hotplug_work_fn+0x1e/0x29
[  250.305120]  [<ffffffff8108eefb>] process_one_work+0x17b/0x460
[  250.305120]  [<ffffffff8108f69d>] worker_thread+0x11d/0x5b0
[  250.305120]  [<ffffffff8108f580>] ? rescuer_thread+0x3a0/0x3a0
[  250.305120]  [<ffffffff81096811>] kthread+0xe1/0x100
[  250.305120]  [<ffffffff81096730>] ? kthread_create_on_node+0x1a0/0x1a0
[  250.305120]  [<ffffffff816cc6bc>] ret_from_fork+0x7c/0xb0
[  250.305120]  [<ffffffff81096730>] ? kthread_create_on_node+0x1a0/0x1a0

This patch fixes this problem by checking if acpi_device->handler is NULL in acpi_scan_hot_remove().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f775fa0..aae0ce0 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -351,7 +351,8 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 	unsigned long long sta;
 	acpi_status status;
 
-	if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
+	if (device->handler && device->handler->hotplug.demand_offline
+	    && !acpi_force_hot_remove) {
 		if (!acpi_scan_is_offline(device, true))
 			return -EBUSY;
 	} else {
-- 
1.8.4.2

