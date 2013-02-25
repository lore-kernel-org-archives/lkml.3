Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3BYQhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:37:33 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:25226 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3BYQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:37:32 -0500
Message-ID: <1361810245.2975.14.camel@lorien2>
Subject: Re: [PATCH 1/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: dhowells@redhat.com, Joerg Roedel <joro@8bytes.org>,
        paulmck@linux.vnet.ibm.com, linasvepstas@gmail.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, shemminger@vyatta.com, jiang.liu@huawei.com,
        wangyijing@huawei.com, shuahkhan@gmail.com
Date: Mon, 25 Feb 2013 09:37:25 -0700
In-Reply-To: <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com>
References: <1360623637.2950.63.camel@lorien2>
	 <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 18:19 -0700, Bjorn Helgaas wrote:
> On Mon, Feb 11, 2013 at 4:00 PM, Shuah Khan <shuah.khan@hp.com> wrote:
> > pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
> > it doesn't have interfaces to return PCI bus and PCI device id. Drivers
> > (AMD IOMMU, and AER) implement module specific definitions for PCI_BUS()
> > and AMD_IOMMU driver also has a module specific interface to calculate PCI
> > device id from bus number and devfn.
> >
> > Add PCI_BUS and PCI_DEVID interfaces to return PCI bus number and PCI device
> > id respectively to avoid the need for duplicate definitions in other modules.
> > AER driver code and AMD IOMMU driver define PCI_BUS. AMD IOMMU driver defines
> > an interface to calculate device id from bus number, and devfn pair.
> >
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  include/uapi/linux/pci.h |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/include/uapi/linux/pci.h b/include/uapi/linux/pci.h
> > index 3c292bc0..6b2c8b3 100644
> > --- a/include/uapi/linux/pci.h
> > +++ b/include/uapi/linux/pci.h
> > @@ -30,6 +30,10 @@
> >  #define PCI_DEVFN(slot, func)  ((((slot) & 0x1f) << 3) | ((func) & 0x07))
> >  #define PCI_SLOT(devfn)                (((devfn) >> 3) & 0x1f)
> >  #define PCI_FUNC(devfn)                ((devfn) & 0x07)
> > +#define PCI_DEVID(bus, devfn)  ((((u16)bus) << 8) | devfn)
> > +
> > +/* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
> > +#define PCI_BUS(x) (((x) >> 8) & 0xff)
> >
> >  /* Ioctls for /proc/bus/pci/X/Y nodes. */
> >  #define PCIIOC_BASE            ('P' << 24 | 'C' << 16 | 'I' << 8)
> 
> David, can you point me at a description of include/uapi ... what is
> there and why, and how we should decide what new things go in
> include/uapi/linux/pci.h as opposed to include/linux/pci.h?  Maybe
> there should be something in Documentation/?
> 
> I'm guessing it's something to do with being exported to userland, but
> I'm not sure the things in this patch (PCI_DEV_ID, PCI_BUS) are really
> exportable in the sense of being used for syscalls, etc.
> 

Bjorn,David,

Looks like the following thread answers some of the questions about when
this uapi export was done on the existing defines.

https://lkml.org/lkml/2011/7/28/198 

Sounds like the concern is that the older defines PCI_DEVFN, PCI_SLOT,
PCI_FUNC,  and PCI_DEVID could be exported, but not the new ones I
added. I could find any discussion on whether these four older defines
are exportable or the reasons for the export in the above thread.

So the question is if uapi/linux.pci.h isn't the right place, do you
have a recommendation on where they belong. The only alternative I can
think of is include/linux/pci.h. It makes functional and logical sense
to add the new defines to where the existing ones are defines. At least,
not knowing the details of the change that moved PCI_DEVFN etc. to
uapi/pci.h, that is my conclusion.

-- Shuah




