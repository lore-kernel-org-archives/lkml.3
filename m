Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3BZO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:58:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45851 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab3BZO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:58:36 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH] Prevent USB hub remove oops
Date: Tue, 26 Feb 2013 22:58:05 +0800
Message-Id: <1361890685-12247-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When initialisation of one or more USB hub ports fails, we can hit a null
pointer dereference when dropping the hub. Analysis shows there's a false
assumption about the ports being setup, so address this.

hub 2-3:1.0: USB hub found
hub 2-3:1.0: 7 ports detected
hub 2-3:1.0: hub_hub_status failed (err = -11)
hub 2-3:1.0: config failed, can't get hub status (err -11)
BUG: unable to handle kernel NULL pointer dereference at      (null)
IP: [<ffffffff8168ff16>] hub_quiesce+0x46/0xb0
PGD 0 
Oops: 0000 [#1] SMP 
CPU 2 
Pid: 3364, comm: khubd Not tainted 3.8.0-advanced+ #21 IBM IBM System X3755 M3 -[7164Z63]-/94Y6321   
RIP: 0010:[<ffffffff8168ff16>] [<ffffffff8168ff16>] hub_quiesce+0x46/0xb0
RSP: 0018:ffff88046c535978 EFLAGS: 00010246
RAX: ffff88046c4fc100 RBX: 0000000000000000 RCX: 000000000000000b
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88046c6b8400 R08: 0000000000000002 R09: 000000000000129b
R10: 0000000000000000 R11: ffff88046c53550e R12: ffff88046c098000
R13: ffff88046c0a8430 R14: ffffffff81af72e0 R15: ffff88046c6b8400
FS: 00007fcbd36196e0(0000) GS:ffff88046fc80000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 3364, threadinfo ffff88046c534000, task ffff88046c58ad00)
Stack:
 ffff88046c0a8400 ffff88046c6b8400 ffff88046c098088 ffffffff816901a5
 ffff88046c098088 ffff88046c0a8400 ffff88046c098088 ffff88046c098000
 ffff88046c4fc180 ffffffff816904c1 ffffffff8169a261 ffff88046c0a8430
Call Trace:
 [<ffffffff816901a5>] ? hub_disconnect+0x75/0x140
 [<ffffffff816904c1>] ? hub_probe+0x251/0x260
 [<ffffffff8169a261>] ? usb_match_one_id+0x31/0x70
 [<ffffffff8169a9a6>] ? usb_probe_interface+0x1a6/0x260
 [<ffffffff815030f8>] ? driver_probe_device+0x68/0x210
 [<ffffffff81503340>] ? __driver_attach+0xa0/0xa0
 [<ffffffff81501a8e>] ? bus_for_each_drv+0x3e/0x80
 [<ffffffff81502e18>] ? device_attach+0x98/0xb0
 [<ffffffff81501ca0>] ? bus_probe_device+0x80/0xb0
 [<ffffffff814fffbe>] ? device_add+0x5be/0x680
 [<ffffffff8169818e>] ? usb_string+0x11e/0x1e0
 [<ffffffff8169933d>] ? usb_set_configuration+0x4cd/0x7c0
 [<ffffffff8116ef1d>] ? sysfs_do_create_link+0xed/0x220
 [<ffffffff816a2b6f>] ? generic_probe+0x2f/0x90
 [<ffffffff815030f8>] ? driver_probe_device+0x68/0x210
 [<ffffffff81503340>] ? __driver_attach+0xa0/0xa0
 [<ffffffff81501a8e>] ? bus_for_each_drv+0x3e/0x80
 [<ffffffff81502e18>] ? device_attach+0x98/0xb0
 [<ffffffff81501ca0>] ? bus_probe_device+0x80/0xb0
 [<ffffffff814fffbe>] ? device_add+0x5be/0x680
 [<ffffffff813956ff>] ? mix_pool_bytes.constprop.19+0x3f/0x60
 [<ffffffff81690628>] ? usb_new_device+0x158/0x210
 [<ffffffff816928b0>] ? hub_port_connect_change+0x570/0x9c0
 [<ffffffff8169316f>] ? hub_thread+0x26f/0x7c0
 [<ffffffff8108384c>] ? __wake_up_common+0x4c/0x80
 [<ffffffff8107bea0>] ? abort_exclusive_wait+0xb0/0xb0
 [<ffffffff81692f00>] ? usb_reset_device+0x140/0x140
 [<ffffffff8107b1e3>] ? kthread+0xb3/0xc0
 [<ffffffff8107b130>] ? __kthread_parkme+0x80/0x80
 [<ffffffff8186332c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff8107b130>] ? __kthread_parkme+0x80/0x80
Code: e4 00 00 00 02 83 fb 02 74 38 41 8b 84 24 40 04 00 00 85 c0 7e 2c 31 db 0f 1f 44 00 00 48 8b 85 f8 01 00 00 48 63 d3 48 8b 3c d0 <48> 83 3f 00 74 05 e8 9f fe ff ff ff c3 41 39 9c 24 40 04 00 00 
RIP [<ffffffff8168ff16>] hub_quiesce+0x46/0xb0
 RSP <ffff88046c535978>
CR2: 0000000000000000

(gdb) list *(hub_quiesce+0x46)
0xffffffff81690056 is in hub_quiesce (drivers/usb/core/hub.c:1266).
1261		hub->quiescing = 1;
1262	
1263		if (type != HUB_SUSPEND) {
1264			/* Disconnect all the children */
1265			for (i = 0; i < hdev->maxchild; ++i) {
1266				if (hub->ports[i]->child)
1267					usb_disconnect(&hub->ports[i]->child);
1268			}
1269		}

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index cbf7168..a7abc57 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1263,7 +1263,7 @@ static void hub_quiesce(struct usb_hub *hub, enum hub_quiescing_type type)
 	if (type != HUB_SUSPEND) {
 		/* Disconnect all the children */
 		for (i = 0; i < hdev->maxchild; ++i) {
-			if (hub->ports[i]->child)
+			if (hub->ports[i] && hub->ports[i]->child)
 				usb_disconnect(&hub->ports[i]->child);
 		}
 	}
-- 
1.7.10.4

