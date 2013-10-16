Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703Ab3JPUV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:21:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63152 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab3JPUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:21:27 -0400
Date: Wed, 16 Oct 2013 14:21:23 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
Message-ID: <20131016202123.GA17866@google.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015024452.GA31951@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
> > [+cc Rafael, Mika, Kirill, linux-pci]
> > 
> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever
> > <andreas.noever@gmail.com> wrote:
> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
> > > crashes a few seconds later. Using
> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
> > > to remove a bridge two levels above the device triggers the fault immediately:
> > 
> > There have been significant changes in acpiphp related to Thunderbolt
> > since v3.11.
> 
> Apple don't expose Thunderbolt via ACPI, so it appears as native PCIe. 
> I'd be surprised if acpiphp makes a difference here.

Yeah, you're right; I wasn't paying attention.

We save a pci_dev pointer in the pci_pme_list, which of course has a
longer lifetime than the pci_dev itself, but we don't acquire a reference
on it, so I suspect the pci_dev got released before we got around to
doing the pci_pme_list_scan().

Andreas, can you try the patch below?  It's against v3.12-rc2, but it
should apply to v3.11, too.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ad7fc72..8b0a2f3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1580,6 +1580,7 @@ static void pci_pme_list_scan(struct work_struct *work)
 				pci_pme_wakeup(pme_dev->dev, NULL);
 			} else {
 				list_del(&pme_dev->list);
+				pci_dev_put(pme_dev->dev);
 				kfree(pme_dev);
 			}
 		}
@@ -1640,7 +1641,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 					  GFP_KERNEL);
 			if (!pme_dev)
 				goto out;
-			pme_dev->dev = dev;
+			pme_dev->dev = pci_dev_get(dev);
 			mutex_lock(&pci_pme_list_mutex);
 			list_add(&pme_dev->list, &pci_pme_list);
 			if (list_is_singular(&pci_pme_list))
@@ -1652,6 +1653,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 			list_for_each_entry(pme_dev, &pci_pme_list, list) {
 				if (pme_dev->dev == dev) {
 					list_del(&pme_dev->list);
+					pci_dev_put(pme_dev->dev);
 					kfree(pme_dev);
 					break;
 				}
