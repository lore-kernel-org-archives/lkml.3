Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab3CZOVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:21:01 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35331 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400Ab3CZOU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:20:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2] firewire: Fix 'failed to read phy reg' on FW643 rev8
Date: Tue, 26 Mar 2013 10:19:20 -0400
Message-Id: <1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364306830.12229.14.camel@thor.lan>
References: <1364306830.12229.14.camel@thor.lan>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the LSI FW643 rev 8 [1], the first commanded bus reset at
the conclusion of ohci_enable() has been observed to fail with
the following messages:

[    4.884015] firewire_ohci 0000:01:00.0: failed to read phy reg
....
[    5.684012] firewire_ohci 0000:01:00.0: failed to read phy reg

With drivers/firewire/ohci.c instrumented, the error condition [2]
indicates the PHY arbitration state machine has timed out prior to
enabling PHY LCtrl.

Furthermore, instrumenting ohci_enable() shows that LPS has been
enabled within 1 ms.

Test LPS latching every 1 ms rather than every 50ms.

[1]  lspci -v

01:00.0 FireWire (IEEE 1394): LSI Corporation FW643 [TrueFire] PCIe 1394b Controller (rev 08) (prog-if 10 [OHCI])
	Subsystem: LSI Corporation FW643 [TrueFire] PCIe 1394b Controller
	Flags: bus master, fast devsel, latency 0, IRQ 92
	Memory at fbeff000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 3
	Capabilities: [4c] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [170] Device Serial Number 08-14-43-82-00-00-41-fc
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

[2] instrumented WARNING in read_phy_reg()

[    4.576010] ------------[ cut here ]------------
[    4.576035] WARNING: at ./drivers/firewire/ohci.c:570 read_phy_reg+0x93/0xe0 [firewire_ohci]()
[    4.576050] Hardware name: Precision WorkStation T5400
[    4.576058] failed to read phy reg:1 (phy(5) @ config enhance:19)
[    4.576068] Modules linked in: hid_logitech_dj hid_generic(+) usbhid <...snip...>
[    4.576140] Pid: 61, comm: kworker/2:1 Not tainted 3.8.0-2+fwtest-xeon #2+fwtest
[    4.576149] Call Trace:
[    4.576160]  [<ffffffff8105468f>] warn_slowpath_common+0x7f/0xc0
[    4.576168]  [<ffffffff81054786>] warn_slowpath_fmt+0x46/0x50
[    4.576178]  [<ffffffffa00caca3>] read_phy_reg+0x93/0xe0 [firewire_ohci]
[    4.576188]  [<ffffffffa00cae19>] ohci_read_phy_reg+0x39/0x60 [firewire_ohci]
[    4.576203]  [<ffffffffa00731ff>] fw_send_phy_config+0xbf/0xe0 [firewire_core]
[    4.576214]  [<ffffffffa006b2d6>] br_work+0x46/0xb0 [firewire_core]
[    4.576225]  [<ffffffff81071e0c>] process_one_work+0x13c/0x500
[    4.576238]  [<ffffffffa006b290>] ? fw_card_initialize+0x180/0x180 [firewire_core]
[    4.576248]  [<ffffffff810737ed>] worker_thread+0x16d/0x470
[    4.576257]  [<ffffffff81073680>] ? busy_worker_rebind_fn+0x100/0x100
[    4.576266]  [<ffffffff8107d160>] kthread+0xc0/0xd0
[    4.576275]  [<ffffffff816a0000>] ? pcpu_dump_alloc_info+0x1cb/0x2c4
[    4.576284]  [<ffffffff8107d0a0>] ? kthread_create_on_node+0x130/0x130
[    4.576297]  [<ffffffff816b2f6c>] ret_from_fork+0x7c/0xb0
[    4.576305]  [<ffffffff8107d0a0>] ? kthread_create_on_node+0x130/0x130
[    4.576313] ---[ end trace cbc940994b300302 ]---

Reported-by: Tim Jordan <tim@insipid.org.uk>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/firewire/ohci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 45912e6..044ace3 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2268,8 +2268,8 @@ static int ohci_enable(struct fw_card *card,
 		  OHCI1394_HCControl_postedWriteEnable);
 	flush_writes(ohci);
 
-	for (lps = 0, i = 0; !lps && i < 3; i++) {
-		msleep(50);
+	for (lps = 0, i = 0; !lps && i < 150; i++) {
+		msleep(1);
 		lps = reg_read(ohci, OHCI1394_HCControlSet) &
 		      OHCI1394_HCControl_LPS;
 	}
-- 
1.8.1.2

