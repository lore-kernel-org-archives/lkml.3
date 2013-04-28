Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3D1VY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 17:24:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36617 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3D1VY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 17:24:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 28 Apr 2013 23:24:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tim Jordan <tim@insipid.org.uk>
Subject: [PATCH v3] firewire: Fix 'failed to read phy reg' on FW643 rev8
Message-ID: <20130428232408.78d08150@stein>
In-Reply-To: <20130428230709.39a3ca06@stein>
References: <1364306830.12229.14.camel@thor.lan>
	<1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
	<20130428230709.39a3ca06@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

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

[Stefan R:  Peter also reports a change of behavior with LSI FW323.
Before the patch, there would often occur a lock transaction failure
during firewire-core startup:
[    6.056022] firewire_core 0000:07:06.0: BM lock failed (timeout), making local node (ffc0) root
This failure no longer happens after the patch, without an obvious
reason for the failure or the fix.]

[Stefan R:  Added quirk flag, quirk table entry, and comment.]

Reported-by: Tim Jordan <tim@insipid.org.uk>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -284,6 +284,7 @@ static char ohci_driver_name[] = KBUILD_
 #define QUIRK_NO_MSI			16
 #define QUIRK_TI_SLLZ059		32
 #define QUIRK_IR_WAKE			64
+#define QUIRK_PHY_LCTRL_TIMEOUT		128
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
@@ -296,7 +297,10 @@ static const struct {
 		QUIRK_BE_HEADERS},
 
 	{PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_AGERE_FW643, 6,
-		QUIRK_NO_MSI},
+		QUIRK_PHY_LCTRL_TIMEOUT | QUIRK_NO_MSI},
+
+	{PCI_VENDOR_ID_ATT, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_PHY_LCTRL_TIMEOUT},
 
 	{PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_SB1394, PCI_ANY_ID,
 		QUIRK_RESET_PACKET},
@@ -343,6 +347,7 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
 	", IR wake unreliable = "	__stringify(QUIRK_IR_WAKE)
+	", phy LCtrl timeout = "	__stringify(QUIRK_PHY_LCTRL_TIMEOUT)
 	")");
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -2293,14 +2298,25 @@ static int ohci_enable(struct fw_card *c
 	 * will lock up the machine.  Wait 50msec to make sure we have
 	 * full link enabled.  However, with some cards (well, at least
 	 * a JMicron PCIe card), we have to try again sometimes.
+	 *
+	 * TI TSB82AA2 + TSB81BA3(A) cards signal LPS enabled early but
+	 * cannot actually use the phy at that time.  These need tens of
+	 * millisecods pause between LPS write and first phy access too.
+	 *
+	 * But do not wait for 50msec on Agere/LSI cards.  Their phy
+	 * arbitration state machine may time out during such a long wait.
 	 */
+
 	reg_write(ohci, OHCI1394_HCControlSet,
 		  OHCI1394_HCControl_LPS |
 		  OHCI1394_HCControl_postedWriteEnable);
 	flush_writes(ohci);
 
-	for (lps = 0, i = 0; !lps && i < 3; i++) {
+	if (!(ohci->quirks & QUIRK_PHY_LCTRL_TIMEOUT))
 		msleep(50);
+
+	for (lps = 0, i = 0; !lps && i < 150; i++) {
+		msleep(1);
 		lps = reg_read(ohci, OHCI1394_HCControlSet) &
 		      OHCI1394_HCControl_LPS;
 	}


-- 
Stefan Richter
-=====-===-= -=-- ===--
http://arcgraph.de/sr/
