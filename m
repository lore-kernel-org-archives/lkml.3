Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3A2Crl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:47:41 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:53668 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3A2Crj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:47:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6WpF22FFwAvo=GUnPugT4WSeR88=mKN4ZpXDbJRWVdkg@mail.gmail.com>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114225.6698.42016.stgit@zurg>
 <CAErSpo4Z-qz18T0WQ3M8MHTGz_S1SAtK9KeTMBDvM2X4Ohs-tA@mail.gmail.com> <CAErSpo6WpF22FFwAvo=GUnPugT4WSeR88=mKN4ZpXDbJRWVdkg@mail.gmail.com>
From: Khalid Aziz <hikerockies@gmail.com>
Date: Mon, 28 Jan 2013 19:47:17 -0700
Message-ID: <CABeg+=KNNtQdoDV8FarfaYwbaC+tt+nFXkss0KFsHfa3KR0BDw@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI: don't touch enable_cnt in pci_device_shutdown()
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry about the resend. gmail sent my original reply in html by
default which didn't go through to all mailing lists]

On Mon, Jan 28, 2013 at 4:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> [+cc Khalid new email addr]
>
> On Mon, Jan 28, 2013 at 4:40 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> > <khlebnikov@openvz.org> wrote:
> >> comment in commit b566a22c23327f18ce941ffad0ca907e50a53d41
> >> ("PCI: disable Bus Master on PCI device shutdown") says:
> >>
> >> | Disable Bus Master bit on the device in pci_device_shutdown() to ensure PCI
> >> | devices do not continue to DMA data after shutdown.  This can cause memory
> >> | corruption in case of a kexec where the current kernel shuts down and
> >> | transfers control to a new kernel while a PCI device continues to DMA to
> >> | memory that does not belong to it any more in the new kernel.
> >>
> >> Seems like pci_clear_master() must be used here instead of pci_disable_device(),
> >> because it disables Bus Muster unconditionally and doesn't changes enable_cnt.
> >>
> >> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> >> Cc: linux-pci@vger.kernel.org
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Khalid Aziz <khalid.aziz@hp.com>
> >> ---
> >>  drivers/pci/pci-driver.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> >> index 030dbf0..853d605 100644
> >> --- a/drivers/pci/pci-driver.c
> >> +++ b/drivers/pci/pci-driver.c
> >> @@ -392,7 +392,7 @@ static void pci_device_shutdown(struct device *dev)
> >>          * Turn off Bus Master bit on the device to tell it to not
> >>          * continue to do DMA
> >>          */
> >> -       pci_disable_device(pci_dev);
> >> +       pci_clear_master(pci_dev);
> >
> > We currently only call pci_enable_device() and pci_disable_device()
> > from drivers, and I think that's a nice division that's worth keeping.
> >  It keeps the core's mitts off device operation and helps preserve the
> > enable_cnt integrity.  So I like this change from that perspective.
> >
> > Any objections to this, Khalid?

Just turning the Bus Master bit off on a device does worry me. For
well behaved PCI devices this should not be an issue at all, but it
has been brought up before that there are misbehaved PCI devices that
do not respond well when Bus Master bit is cleared on them while they
are active. Turning interrupts off as well on them seems to help with
being able to re-initialize them in the new kernel.  As a result, I
wanted to make sure we at least call  pcibios_disable_irq() to turn
off their interrupt and hence I chose to call pci_disable_device()
instead of pci_clear_master(). I understand the concern around messing
up enable_cnt. Would it be better to replace pci_disable_device() with
these two instead:

pci_clear_master(pci_dev);
pcibios_disable_device(pci_dev);

--
Khalid
