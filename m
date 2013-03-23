Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3CWRbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:31:15 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:49774 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3CWRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:31:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tim Jordan <tim@insipid.org.uk>, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] firewire: Fix 'failed to read phy reg' on FW643 rev8
Date: Sat, 23 Mar 2013 13:30:39 -0400
Message-Id: <1364059839-3335-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
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

Clear the PHY arbitration timeout condition prior to enabling LCtrl.

NB: The problem appears to be timing-related as well, since clearing
the timeout status before configure_1394a_enhancements() has no effect.

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
 drivers/firewire/core.h | 1 +
 drivers/firewire/ohci.c | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index 515a42c..9c69848 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -38,6 +38,7 @@ void fw_notice(const struct fw_card *card, const char *fmt, ...);
 #define PHY_EXTENDED_REGISTERS	0xe0
 #define PHY_BUS_SHORT_RESET	0x40
 #define PHY_INT_STATUS_BITS	0x3c
+#define PHY_ARB_TIMEOUT		0x08
 #define PHY_ENABLE_ACCEL	0x02
 #define PHY_ENABLE_MULTI	0x01
 #define PHY_PAGE_SELECT		0xe0
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 6ce6e07..371fb74 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2195,13 +2195,14 @@ static int configure_1394a_enhancements(struct fw_ohci *ohci)
 	if (ohci->quirks & QUIRK_NO_1394A)
 		enable_1394a = false;
 
-	/* Configure PHY and link consistently. */
+	/* Configure PHY and link consistently and reset the
+	 * PHY arbitration timeout status */
 	if (enable_1394a) {
 		clear = 0;
-		set = PHY_ENABLE_ACCEL | PHY_ENABLE_MULTI;
+		set = PHY_ENABLE_ACCEL | PHY_ENABLE_MULTI | PHY_ARB_TIMEOUT;
 	} else {
 		clear = PHY_ENABLE_ACCEL | PHY_ENABLE_MULTI;
-		set = 0;
+		set = PHY_ARB_TIMEOUT;
 	}
 	ret = update_phy_reg(ohci, 5, clear, set);
 	if (ret < 0)
-- 
1.8.1.2

