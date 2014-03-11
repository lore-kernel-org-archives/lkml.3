Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaCKAKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:10:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39107 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaCKAKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:10:07 -0400
Date: Mon, 10 Mar 2014 18:10:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers
 during rescan
Message-ID: <20140311001003.GA14367@google.com>
References: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
 <CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
 <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
 <20140308010456.GA30660@google.com>
 <CAMxnaaVfpJCW7e-b80y4wmVWcRDK5t7qY+pNn71CsLPRN2ojnA@mail.gmail.com>
 <CAErSpo4MQsAer7FM0kU5mMOGRok0oFMWX1FqFijmswutjyNoRg@mail.gmail.com>
 <CAMxnaaWr0z1zbpFQPX6UvYbnxhfA+3aj4ffhCBpp1i4ZLsGTPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaWr0z1zbpFQPX6UvYbnxhfA+3aj4ffhCBpp1i4ZLsGTPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 12:10:02AM +0100, Andreas Noever wrote:
> On Mon, Mar 10, 2014 at 9:43 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Sat, Mar 8, 2014 at 2:55 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
> >> On Sat, Mar 8, 2014 at 2:04 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >
> >>> If we did that, INTX_DISABLE would be cleared by the first
> >>> pci_enable_device() and pci_reenable_device() wouldn't do anything,
> >>> leaving it cleared.  The resulting state (cleared) would be the same,
> >>> but the transitions would be gone, and maybe those are important.
> >> Just a quick note: With pci_intx_for_msi removed no hotplug events are
> >> ever delivered. Everything else still works though. So it is either a
> >> problem specific to Thunderbolt bridges or maybe it just affects
> >> hotplug (and PME?) interrupts.
> >
> > Interesting.  This is on a MacBook, isn't it?  If you have Mac OS on
> > it, is there a way you can do the equivalent of lspci on it?  I'm
> > curious about whether it sets INTx_DISABLE when it enables MSI.
> 
> lspci -vv and lspci -vv -xxxx attached (yes, someone made a port).
> 
> It looks like Mac OS sets DisINTx for all devices that have MSI
> enabled. The only exception is the Thunderbolt controller (no
> idea...). But the hotplug bridges all have DisINTx+.

OK, thanks.  I don't know what to make of that.

Here's a possible patch; can you try it out?


PCI: Do not enable INTx in pci_reenable_device()

From: Bjorn Helgaas <bhelgaas@google.com>

Previously we cleared the Interrupt Disable bit in do_pci_enable_device(),
which is used by both pci_enable_device() and pci_reenable_device().  But
we use pci_reenable_device() after the driver may have enabled MSI or
MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.

The pciehp hot-plug path uses pci_reenable_device() on the hotplug bridge,
and clearing its Interrupt Disable bit makes its hotplug event-reporting
MSI stop working.

Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
Link: https://bugzilla.kernel.org/show_bug.cgi?id=71691
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8dc3e701ec57..79fc89c6c3f3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1192,6 +1192,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	if (dev->msi_enabled || dev->msix_enabled)
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
