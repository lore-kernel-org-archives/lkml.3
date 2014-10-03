Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbaJCXiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbaJCWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Gouders <dirk@gouders.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3.16 316/357] Revert "PCI: Make sure bus number resources stay within their parents bounds"
Date: Fri,  3 Oct 2014 14:31:42 -0700
Message-Id: <20141003212942.965215279@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 12d8706963f073fffad16c7c24160ef20d9aeaff upstream.

This reverts commit 1820ffdccb9b ("PCI: Make sure bus number resources stay
within their parents bounds") because it breaks some systems with LSI Logic
FC949ES Fibre Channel Adapters, apparently by exposing a defect in those
adapters.

Dirk tested a Tyan VX50 (B4985) with this device that worked like this
prior to 1820ffdccb9b:

    bus: [bus 00-7f] on node 0 link 1
    ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
    pci 0000:00:0e.0: PCI bridge to [bus 0a]
    pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07] (conflicts with (null) [bus 00-07])
    pci 0000:0a:00.0: [1000:0646] type 00 class 0x0c0400 (FC adapter)

Note that the root bridge [bus 00-07] aperture is wrong; this is a BIOS
defect in the PCI0 _CRS method.  But prior to 1820ffdccb9b, we didn't
enforce that aperture, and the FC adapter worked fine at 0a:00.0.

After 1820ffdccb9b, we notice that 00:0e.0's aperture is not contained in
the root bridge's aperture, so we reconfigure it so it *is* contained:

    pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
    pci 0000:00:0e.0: PCI bridge to [bus 06-07]

This effectively moves the FC device from 0a:00.0 to 07:00.0, which should
be legal.  But when we enumerate bus 06, the FC device doesn't respond, so
we don't find anything.  This is probably a defect in the FC device.

Possible fixes (due to Yinghai):

    1) Add a quirk to fix the _CRS information based on what amd_bus.c read
       from the hardware

    2) Reset the FC device after we change its bus number

    3) Revert 1820ffdccb9b

Fix 1 would be relatively easy, but it does sweep the LSI FC issue under
the rug.  We might want to reconfigure bus numbers in the future for some
other reason, e.g., hotplug, and then we could trip over this again.

For that reason, I like fix 2, but we don't know whether it actually works,
and we don't have a patch for it yet.

This revert is fix 3, which also sweeps the LSI FC issue under the rug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=84281
Reported-by: Dirk Gouders <dirk@gouders.net>
Tested-by: Dirk Gouders <dirk@gouders.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -775,7 +775,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 	/* Check if setup is sensible at all */
 	if (!pass &&
 	    (primary != bus->number || secondary <= bus->number ||
-	     secondary > subordinate || subordinate > bus->busn_res.end)) {
+	     secondary > subordinate)) {
 		dev_info(&dev->dev, "bridge configuration invalid ([bus %02x-%02x]), reconfiguring\n",
 			 secondary, subordinate);
 		broken = 1;
@@ -849,8 +849,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 			child = pci_add_new_bus(bus, dev, max+1);
 			if (!child)
 				goto out;
-			pci_bus_insert_busn_res(child, max+1,
-						bus->busn_res.end);
+			pci_bus_insert_busn_res(child, max+1, 0xff);
 		}
 		max++;
 		buses = (buses & 0xff000000)
@@ -909,11 +908,6 @@ int pci_scan_bridge(struct pci_bus *bus,
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
-		if (max > bus->busn_res.end) {
-			dev_warn(&dev->dev, "max busn %02x is outside %pR\n",
-				 max, &bus->busn_res);
-			max = bus->busn_res.end;
-		}
 		pci_bus_update_busn_res_end(child, max);
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
 	}


