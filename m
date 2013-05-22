Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3EVQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:41:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3EVQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:41:49 -0400
Date: Wed, 22 May 2013 12:41:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Chien Yen <chien.yen@oracle.com>, Feng Jin <joe.jin@oracle.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated when
 driver load first time
Message-ID: <20130522164122.GB9712@phenom.dumpdata.com>
References: <20130520203855.GA30616@phenom.dumpdata.com>
 <519B474E.4000202@citrix.com>
 <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
 <20130521204245.GA7073@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305212242540.4799@kaball.uk.xensource.com>
 <20130521224125.GA3483@phenom.dumpdata.com>
 <519CAE0302000078000D807A@nat28.tlf.novell.com>
 <20130522151437.GC8162@phenom.dumpdata.com>
 <519CFF7602000078000D82E6@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CFF7602000078000D82E6@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 04:25:10PM +0100, Jan Beulich wrote:
> >>> On 22.05.13 at 17:14, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > The physdev_unmap_pirq (from PHYSDEVOP_unmap_pirq), only has this
> > check:
> >  if (domain_pirq_to_emuirq(d, pirq) != IRQ_UNBOUND)
> > 
> > and since the arch.hvm.emuirq is IRQ_UNBOUND (-1), it does not
> > call unmap_domain_pirq_emuirq. It probably shouldn't, but it should
> > at least remove the info->arch.pirq = PIRQ_ALLOCATED as we are
> > telling the hypervisor: "hey, I am done with this, return to the
> > pool." But since that is not cleared, the PHYSDEVOP_get_free_pirq
> > will skip this pirq as arch.pirq is still set to PIRQ_ALLOCATED.
> 
> Okay, that clarifies it quite a bit. For one, I'll leave any of the
> emuirq stuff to Stefano, who wrote this originally. And then, from
> the beginning of this thread, I'm not convinced that freeing a pirq
> is really the right thing here: unmap_pirq() is the counterpart of
> map_pirq(), not get_free_pirq(). I would think that is a guest
> allocates a pirq and then unmaps it without first mapping it, it's
> the guest's fault that it now lost one pirq resource. It should not
> have allocated one in the first place if it didn't mean to use it for
> anything.

It does use it, but if you do run this in a loop:
  rmmod e1000e;modprobe e1000e

it ends up doing thse three hypercalls: PHYSDEVOP_get_free_pirq,
PHYSDEVOP_map_pirq, PHYSDEVOP_unmap_pirq and so on. The reason is that
drivers/xen/events.c keeps track of the Linux IRQ <-> PIRQ just as long
as needed - if the driver does a free_irq, well, then the mapping is
de-allocated and lost.

One patch I posted (for Linux) keeps track of the PIRQ so that if
free_irq is called and we remove the Linux IRQ <-> PIRQ association,
we still have the PIRQ saved away and can re-use it.

In other words, the loop ends up doing:
 PHYSDEVOP_map_pirq, PHYSDEVOP_unmap_pirq

> 
> >> I see none at all, unmap_domain_pirq() has a <= 0 check, and
> >> unmap_domain_pirq_emuirq() again doesn't appear to have any.
> > 
> > The 'unmap_domain_pirq' path would be if dom0 (so QEMU) did the
> > unmap for the guest. That is via the PHYSDEVOP_unmap_pirq. And
> > I think if that path was taken (as Stefano suggests QEMU should
> > do when a MSI or MSI-X driver is unloaded and zero is writen as
> > an PIRQ), we would end up calling clear_domain_irq_pirq, which
> > would set arch.pirq = 0.
> > 
> > Or to a negative value as you pointed out later. Which then
> > means we won't be ever able to re-use the PIRQ (as
> > PHYSDEVOP_get_free_pirq or rather get_free_pirq would skip over it
> > as arch.pirq != 0).
> 
> That setting to a negative value is not causing the slot to be
> permanently lost, it merely defers its freeing. It was the only
> way I could find back then to reasonably handle an unmap
> being done before the matched unbind.

Ah, so pt_irq_destroy_bind (XEN_DOMCTL_unbind_pt_irq) is the counterpart
to PHYSDEVOP_get_free_pirq in some form. Which looks to be on QEMU side
only called when the PCI device is put in sleep or pulled out of the guest.

It probably shouldn't be called when the device is merely de-activated.

