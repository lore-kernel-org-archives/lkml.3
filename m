Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaIYUXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:23:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63513 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaIYUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:23:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
Date: Thu, 25 Sep 2014 22:22:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <201409252126.38945.arnd@arndb.de> <CAErSpo5rhL7pLha-yWt7sZUBmAnwA6FkacL+sWXBKkSzsuC7Sg@mail.gmail.com>
In-Reply-To: <CAErSpo5rhL7pLha-yWt7sZUBmAnwA6FkacL+sWXBKkSzsuC7Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201409252222.23825.arnd@arndb.de>
X-Provags-ID: V02:K0:VIHCfkdrHllkx+aL1Go+EPTAjNzOHG6ZiTaK5OuzXhd
 /Id3I5b54267nqB1D/JFIGPWHAJ8H+oTpMojVS+Twi7opdoHDm
 yCtU5KpG/bY/ZFj6zYhxTJLzdysuX/6L221P2IOFGIttoSscb1
 GAFN213nrc6DJDyCBP+FiNaUyN11ny56mZQtcTe1wMZvzolR1R
 qI1GMlbZ0aWJzB0zVub7HlkNlf8QkJeI4hdxGNrHYj78AKq/IN
 GbWmSocdlwlswgRf2cvTnGmPGkg83eRsc+w9YauQwc0chs5d25
 ZTHXzVBA4QfZRf+s7dBLtLX1Zt/UWNAThFhl4vUuiorXwcL7Wh
 ldGKLx2QKwlEKfR8Qf0Q=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014, Bjorn Helgaas wrote:
> OK.  You said "a range that has the nonrelocatable flag set should be
> used for IORESOURCE_PCI_FIXED mappings."  I thought you meant that the
> range was a bridge window, and somehow PCI_FIXED BARs should be put in
> that window.
> 
> But maybe you meant that nonrelocatable ranges should have the
> IORESOURCE_PCI_FIXED bit set in their struct resources.  That would
> mean we couldn't move the window, but we could put relocatable BARs
> inside the window.
> 
> What needs to be implemented?  Just the code that would set
> IORESOURCE_PCI_FIXED for nonrelocatable ranges?

It might be more complex than I thought. Let's see what the original
hack does:

+/*
+ * All PCIe devices in Thunder have fixed resources, shouldn't be reassigned.
+ * Also claim the device's valid resources to set 'res->parent' hierarchy.
+ */
+static void pci_dev_resource_fixup(struct pci_dev *dev)
+{
+       struct resource *res;
+       int resno;
+
+       for (resno = 0; resno < PCI_NUM_RESOURCES; resno++)
+               dev->resource[resno].flags |= IORESOURCE_PCI_FIXED;
+
+       for (resno = 0; resno < PCI_BRIDGE_RESOURCES; resno++) {
+               res = &dev->resource[resno];
+               if (res->parent || !(res->flags & IORESOURCE_MEM))
+                       continue;
+               pci_claim_resource(dev, resno);
+       }
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID,
+                       pci_dev_resource_fixup);

This actually looks harmful, because it means that any kernel that contains
the thunder host controller driver will do the above for any device made
by Cavium, whether it's connected to this bridge or not.

What I think we want instead is to mark any resource whose parent
resource is IORESOURCE_PCI_FIXED to have the same flag, and mark
the PCI host controller resources IORESOURCE_PCI_FIXED when the
nonrelocatable flag is set, and that should all be done in core
code, not in a driver fixup.

The part that still looks weird is the pci_claim_resource() that
Sunil mentioned. This is currently done for resources that do not
have a parent, but AFAICT all PCI device resources should have a
parent that connects it to the upstream bridge.

	Arnd
