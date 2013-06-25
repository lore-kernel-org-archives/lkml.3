Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3FYLXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3FYLXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:23:11 -0400
Date: Tue, 25 Jun 2013 14:23:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
Message-ID: <20130625112348.GA13722@redhat.com>
References: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
 <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 07:38:45PM -0600, Bjorn Helgaas wrote:
> [+cc Michael, Alex, Isaku]
> 
> On Wed, Jun 19, 2013 at 12:56 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> > PCIe switch upstream port can be connected directly to the PCIe root bus
> > in QEMU; ASPM does not expect this topology and dereferences NULL pointer
> > when initializing.
> >
> > I have not confirmed this can happen on real hardware, but it is presented
> > as a feature in QEMU, so there is no reason to panic if we can recover.
> 
> This doesn't seem like a valid hardware topology to me.  If this *can*
> occur on real hardware, we should fix it in Linux.  If not, maybe QEMU
> should be changed to disallow it.

I don't think it's a spec compliant topology either.

Anything connected to an RC is either an integrated endpoint
or a root port.
There's no way to have an upstream port that is also
an integrated endpoint or a root port - these are distinct
device types.

So I don't think Linux needs to support it.

Having said that, there's all kind of broken hardware
out there - crashing is not a friendly way to tell users
that their hardware is not spec compliant.
Maybe linux can print a friendly warning and ignore
this port?


> > The dereference happens with topology defined by
> >   -M q35 -device x3130-upstream,bus=pcie.0,id=upstream \
> >   -device xio3130-downstream,bus=upstream,id=downstream,chassis=1
> > where on line drivers/pci/pcie/aspm.c:530 (alloc_pcie_link_state+13):
> >                 parent = pdev->bus->parent->self->link_state;
> > "pdev->bus->parent->self == NULL", because "pdev->bus->parent" has no
> > "->parent", hence no "->self".
> >
> > Even though discouraged by QEMU documentation, one can set up even
> > topology without the upstream port
> >   -M q35 -device xio3130-downstream,bus=pcie.0,id=downstream,chassis=1
> > so "pdev->bus->parent == NULL", because "pdev->bus" is the root bus.
> > The patch checks for this too, because I do not like *NULL.
> >
> > Right now, PCIe switch has to connect to the root port
> >   -M q35 -device ioh3420,bus=pcie.0,id=root.0 \
> >   -device x3130-upstream,bus=root.0,id=upstream \
> >   -device xio3130-downstream,bus=upstream,id=downstream,chassis=1
> >
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> >  drivers/pci/pcie/aspm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > index 403a443..1ad1514 100644
> > --- a/drivers/pci/pcie/aspm.c
> > +++ b/drivers/pci/pcie/aspm.c
> > @@ -527,8 +527,8 @@ static struct pcie_link_state *alloc_pcie_link_state(struct pci_dev *pdev)
> >         link->pdev = pdev;
> >         if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM) {
> >                 struct pcie_link_state *parent;
> > -               parent = pdev->bus->parent->self->link_state;
> > -               if (!parent) {
> > +               if (!pdev->bus->parent || !pdev->bus->parent->self ||
> > +                   !(parent = pdev->bus->parent->self->link_state)) {
> >                         kfree(link);
> >                         return NULL;
> >                 }
> > --
> > 1.8.1.4
> 
> I don't really want to further complicate the "if" statement you're
> changing.  The link state allocation is pretty obtuse already, and if
> this situation only occurs in QEMU, we're likely to break it again
> when somebody refactors this code.
> 
> Bjorn
