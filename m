Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3FMKJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab3FMKJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:09:38 -0400
Date: Thu, 13 Jun 2013 12:09:17 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Linux PCI development list <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: pcie aspm link setup, grandparent instead of parent?
Message-ID: <20130613100917.GA14089@hpx.cz>
References: <20130612172132.GG27284@hpx.cz>
 <CAErSpo5XvTHFf+ZO0GAxKm0xk+fo9Hm_G6Ebz1UmMkLUi8CPyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo5XvTHFf+ZO0GAxKm0xk+fo9Hm_G6Ebz1UmMkLUi8CPyw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-12 15:54-0600, Bjorn Helgaas:
> [+cc linux-pci, Myron, Joe]

I'll remember it.

> On Wed, Jun 12, 2013 at 11:21 AM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> > Hello,
> >
> > as a consequence of hitting a NULL dereference bug[1] while downstream
> > aspm is setting up link_state, I started to wonder why is the code
> > skipping its parent bus in favour of grandparent's link_state.[2]
> >
> > Is this right? (I have no device to test on ...)

No,
pcie_link_state covers both upstream and downstream port, so we skip
upstream port of current device.

Must the "parent device" (grandparent) have valid "->self"?
(qemu allows even topologies without the upstream port, so it does not
count for much ...)

> > Thanks.
> >
> > ---
> > 1: https://bugzilla.redhat.com/show_bug.cgi?id=972381
> >    The bug is hit because "pdev->bus->parent" has NULL "->parent" and thus
> >    NULL "->self".
> > 2: "pdev = bus->self", so "pdev->bus->parent == bus->parent->parent"
> >
> >
> > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > index 403a443..d58e282 100644
> > --- a/drivers/pci/pcie/aspm.c
> > +++ b/drivers/pci/pcie/aspm.c
> > @@ -527,7 +527,7 @@ static struct pcie_link_state *alloc_pcie_link_state(struct pci_dev *pdev)
> >         link->pdev = pdev;
> >         if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM) {
> >                 struct pcie_link_state *parent;
> > -               parent = pdev->bus->parent->self->link_state;
> > +               parent = pdev->bus->self->link_state;
> >                 if (!parent) {
> >                         kfree(link);
> >                         return NULL;
