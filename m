Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3FYC6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:58:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3FYC6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:58:44 -0400
Message-ID: <1372129109.30572.335.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>
Date: Mon, 24 Jun 2013 20:58:29 -0600
In-Reply-To: <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
References: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
	 <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 19:38 -0600, Bjorn Helgaas wrote:
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

I think a quad-port 82576 plugged into an express slot is likely the
same topology.

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

I don't think this is legal on real hardware.

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

I think there's an extra test in here.  Elsewhere we seem to assume that
if parent exists, then so does parent->self.  So this could be
simplified to just add:

if (pci_is_root_bus(pdev->bus) {
	kfree(link);
	return NULL;
}

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

Maybe the above plus a common exit to avoid duplicate free/return.
Thanks,

Alex


