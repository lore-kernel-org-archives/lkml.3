Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaEPG20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:28:26 -0400
Received: from ns.horizon.com ([71.41.210.147]:44236 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754424AbaEPG2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:28:25 -0400
Date: 16 May 2014 02:28:23 -0400
Message-ID: <20140516062823.15105.qmail@ns.horizon.com>
From: colin@horizon.com
To: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 00/15] PCI/iommu: Fix DMA alias problems
Cc: acooks@gmail.com, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux@horizon.com
In-Reply-To: <400175834.3289.65.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> Wow, I didn't think that kind of broken was possible.  Maybe instead of
> a bitmap of function aliases we could have a single devfn alias for a
> device.  That means we'd only be able to support a single alias for a
> device, but since I don't think we've seen devices that use more than a
> single alias, maybe that's ok.

In my (never finished) patch set for the same problem, the first thing
I did was

diff --git a/include/linux/pci.h b/include/linux/pci.h
index a13d6825..7788870a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -251,12 +251,13 @@ struct pci_dev {
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/pci */
 	struct pci_slot	*slot;		/* Physical slot this device is in */
 
-	unsigned int	devfn;		/* encoded device & function index */
 	unsigned short	vendor;
 	unsigned short	device;
 	unsigned short	subsystem_vendor;
 	unsigned short	subsystem_device;
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
+	u8		devfn;		/* encoded device & function index */
+	u8		devfn_quirk;	/* zero is non-quirky */
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
 	u8		pcie_cap;	/* PCIe capability offset */

I encoded "devfn_quirk" as a delta to devfn, so that zero would mean
"no quirk", and no existing intialization would need changing.
