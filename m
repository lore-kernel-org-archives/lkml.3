Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbaJCXnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:43:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbaJCWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.16 308/357] Revert "PCI: Dont scan random busses in pci_scan_bridge()"
Date: Fri,  3 Oct 2014 14:31:34 -0700
Message-Id: <20141003212942.727356256@linuxfoundation.org>
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

commit 7a0b33d4a45d30b9a838fba4efcd80b7b57d4d16 upstream.

This reverts commit fc1b253141b3 ("PCI: Don't scan random busses in
pci_scan_bridge()") because it breaks CardBus on some machines.

David tested a Dell Latitude D505 that worked like this prior to
fc1b253141b3:

    pci 0000:00:1e.0: PCI bridge to [bus 01]
    pci 0000:01:01.0: CardBus bridge to [bus 02-05]

Note that the 01:01.0 CardBus bridge has a bus number aperture of
[bus 02-05], but those buses are all outside the 00:1e.0 PCI bridge bus
number aperture, so accesses to buses 02-05 never reach CardBus.  This is
later patched up by yenta_fixup_parent_bridge(), which changes the
subordinate bus number of the 00:1e.0 PCI bridge:

    pci_bus 0000:01: Raising subordinate bus# of parent bus (#01) from #01 to #05

With fc1b253141b3, pci_scan_bridge() fails immediately when it notices that
we can't allocate a valid secondary bus number for the CardBus bridge, and
CardBus doesn't work at all:

    pci 0000:01:01.0: can't allocate child bus 01 from [bus 01]

I'd prefer to fix this by integrating the yenta_fixup_parent_bridge() logic
into pci_scan_bridge() so we fix the bus number apertures up front.  But
I don't think we can do that before v3.17, so I'm going to revert this to
avoid the problem while we're working on the long-term fix.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=83441
Link: http://lkml.kernel.org/r/1409303414-5196-1-git-send-email-david.henningsson@canonical.com
Reported-by: David Henningsson <david.henningsson@canonical.com>
Tested-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -838,16 +838,12 @@ int pci_scan_bridge(struct pci_bus *bus,
 			goto out;
 		}
 
-		if (max >= bus->busn_res.end) {
-			dev_warn(&dev->dev, "can't allocate child bus %02x from %pR\n",
-				 max, &bus->busn_res);
-			goto out;
-		}
-
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
-		/* The bus will already exist if we are rescanning */
+		/* Prevent assigning a bus number that already exists.
+		 * This can happen when a bridge is hot-plugged, so in
+		 * this case we only re-scan this bus. */
 		child = pci_find_bus(pci_domain_nr(bus), max+1);
 		if (!child) {
 			child = pci_add_new_bus(bus, dev, max+1);


