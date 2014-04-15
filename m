Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbaDOXIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:08:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43157 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:08:20 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 19:08:19 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 Apr 2014 01:08:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] firewire: ohci: enable MSI for VIA VT6315 rev 1, drop
 cycle timer quirk
Message-ID: <20140416010808.2ab9d416@stein>
In-Reply-To: <20140416010100.786a4c04@stein>
References: <20140416010100.786a4c04@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: ohci: enable MSI for VIA VT6315 rev 1, drop cycle timer quirk

Commit af0cdf494781 "firewire: ohci: fix regression with VIA VT6315,
disable MSI" acted upon a report against VT6315 rev 0:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-12/msg02301.html
$ lspci -nn
VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]

I now got a card with
$ lspci -nn
VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403] (rev 01)
and this works fine with MSI enabled.

Second, I tested this VT6315 rev 1 without CYCLE_TIMER quirk flag using
http://me.in-berlin.de/~s5r6/linux1394/utils/test_cycle_time_v20100125.c
and found that this chip does in fact access the cycle timer atomically.

Things I can't test because I don't have the hardware:
  - whether VT6315 rev 0 really needs QUIRK_CYCLE_TIMER,
  - whether the VT6320 PCI device needs QUIRK_CYCLE_TIMER,
  - whether the VT6325 and VT6330 PCIe devices need QUIRK_CYCLE_TIMER
    and QUIRK_NO_MSI.

Hence, just add a whitelist entry specifically for VT6315 rev >= 1
without any quirk flags.  Before this entry we need an extra entry to
catch VT6315 rev <= 0 due to how our ID matching logic works.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
v2: Oops, a table entry is applied if dev->revision <= table[i].revision.

 drivers/firewire/ohci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -282,6 +282,7 @@ static char ohci_driver_name[] = KBUILD_
 #define PCI_DEVICE_ID_TI_TSB82AA2	0x8025
 #define PCI_DEVICE_ID_VIA_VT630X	0x3044
 #define PCI_REV_ID_VIA_VT6306		0x46
+#define PCI_DEVICE_ID_VIA_VT6315	0x3403
 
 #define QUIRK_CYCLE_TIMER		0x1
 #define QUIRK_RESET_PACKET		0x2
@@ -334,6 +335,12 @@ static const struct {
 	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT630X, PCI_REV_ID_VIA_VT6306,
 		QUIRK_CYCLE_TIMER | QUIRK_IR_WAKE},
 
+	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT6315, 0,
+		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
+
+	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT6315, PCI_ANY_ID,
+		0},
+
 	{PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
 };


-- 
Stefan Richter
-=====-====- -=-- =----
http://arcgraph.de/sr/
