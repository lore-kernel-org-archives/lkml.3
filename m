Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaFKWHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbaFKWHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:07:54 -0400
Message-ID: <1402524464.14174.186.camel@ul30vt.home>
Subject: Re: [PATCH 3.14 186/228] PCI: Wrong register used to check pending
 traffic
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alex Williamson <alex.williamson@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Wed, 11 Jun 2014 16:07:44 -0600
In-Reply-To: <CAErSpo6UcObn6HVKpw82Ncfgr64w2Ws120P2WfSLqAqaROsDTw@mail.gmail.com>
References: <20140604232347.966798903@linuxfoundation.org>
	 <20140604232354.004988520@linuxfoundation.org>
	 <1402196538.23860.24.camel@deadeye.wl.decadent.org.uk>
	 <CAErSpo6UcObn6HVKpw82Ncfgr64w2Ws120P2WfSLqAqaROsDTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 15:15 -0600, Bjorn Helgaas wrote:
> On Sat, Jun 7, 2014 at 9:02 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Wed, 2014-06-04 at 16:23 -0700, Greg Kroah-Hartman wrote:
> >> 3.14-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> ------------------
> >>
> >> From: Gavin Shan <gwshan@linux.vnet.ibm.com>
> >>
> >> commit d0b4cc4e32705ff00d90d32da7783c266c702c04 upstream.
> >>
> >> The incorrect register offset is passed to pci_wait_for_pending(), which is
> >> caused by commit 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor
> >> pci_wait_for_pending_transaction())").
> >>
> >> Fixes: 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
> >> Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
> >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >> Acked-by: Alex Williamson <alex.williamson@gmail.com>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>
> >> ---
> >>  drivers/pci/pci.c |    5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -3043,7 +3043,8 @@ int pci_wait_for_pending_transaction(str
> >>       if (!pci_is_pcie(dev))
> >>               return 1;
> >>
> >> -     return pci_wait_for_pending(dev, PCI_EXP_DEVSTA, PCI_EXP_DEVSTA_TRPND);
> >> +     return pci_wait_for_pending(dev, pci_pcie_cap(dev) + PCI_EXP_DEVSTA,
> >> +                                 PCI_EXP_DEVSTA_TRPND);
> >>  }
> >>  EXPORT_SYMBOL(pci_wait_for_pending_transaction);
> >>
> >> @@ -3085,7 +3086,7 @@ static int pci_af_flr(struct pci_dev *de
> >>               return 0;
> >>
> >>       /* Wait for Transaction Pending bit clean */
> >> -     if (pci_wait_for_pending(dev, PCI_AF_STATUS, PCI_AF_STATUS_TP))
> >> +     if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
> >>               goto clear;
> >>
> >>       dev_err(&dev->dev, "transaction is not cleared; "
> >
> > This still seems to be broken because pci_wait_for_pending() does
> > pci_read_config_word() but PCI_AF_STATUS is not word-aligned.
> 
> I agree; this does seem broken.  I think pci_read_config_word() will
> return PCIBIOS_BAD_REGISTER_NUMBER without updating the value
> returned, so I think we'll test garbage from the stack.
> 
> What do you think, Alex?

Yep, looks broken.  The simple fix would be to pass the AF control
offset instead of status, shift the mask, and maybe add a BUG_ON(pos &
1) to pci_read_config_word() to better enforce it.  Alternatively we
could make the function take a width and use an appropriate accessor for
the size.  I'm inclined to double-check the current users and take the
first option unless anyone objects.  Thanks,

Alex

