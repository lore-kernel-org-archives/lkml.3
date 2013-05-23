Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3EWGb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:31:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41746 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3EWGbz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 23 May 2013 02:31:55 -0400
Message-Id: <519DD3F502000078000D8565@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 23 May 2013 07:31:49 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Chien Yen" <chien.yen@oracle.com>, "Feng Jin" <joe.jin@oracle.com>,
        "Yuval Shaia" <yuval.shaia@oracle.com>,
        "Zhenzhong Duan" <zhenzhong.duan@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated
 when driver load first time
References: <20130520203855.GA30616@phenom.dumpdata.com>
 <519B474E.4000202@citrix.com> <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
 <20130521204245.GA7073@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305212242540.4799@kaball.uk.xensource.com>
 <20130521224125.GA3483@phenom.dumpdata.com>
 <519CAE0302000078000D807A@nat28.tlf.novell.com>
 <20130522151437.GC8162@phenom.dumpdata.com>
 <519CFF7602000078000D82E6@nat28.tlf.novell.com>
 <20130522164122.GB9712@phenom.dumpdata.com>
In-Reply-To: <20130522164122.GB9712@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.05.13 at 18:41, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Wed, May 22, 2013 at 04:25:10PM +0100, Jan Beulich wrote:
>> Okay, that clarifies it quite a bit. For one, I'll leave any of the
>> emuirq stuff to Stefano, who wrote this originally. And then, from
>> the beginning of this thread, I'm not convinced that freeing a pirq
>> is really the right thing here: unmap_pirq() is the counterpart of
>> map_pirq(), not get_free_pirq(). I would think that is a guest
>> allocates a pirq and then unmaps it without first mapping it, it's
>> the guest's fault that it now lost one pirq resource. It should not
>> have allocated one in the first place if it didn't mean to use it for
>> anything.
> 
> It does use it, but if you do run this in a loop:
>   rmmod e1000e;modprobe e1000e
> 
> it ends up doing thse three hypercalls: PHYSDEVOP_get_free_pirq,
> PHYSDEVOP_map_pirq, PHYSDEVOP_unmap_pirq and so on.

Yeah, my comment was more towards your simplified repro
module...

> The reason is that
> drivers/xen/events.c keeps track of the Linux IRQ <-> PIRQ just as long
> as needed - if the driver does a free_irq, well, then the mapping is
> de-allocated and lost.
> 
> One patch I posted (for Linux) keeps track of the PIRQ so that if
> free_irq is called and we remove the Linux IRQ <-> PIRQ association,
> we still have the PIRQ saved away and can re-use it.
> 
> In other words, the loop ends up doing:
>  PHYSDEVOP_map_pirq, PHYSDEVOP_unmap_pirq

And that's the right solution here imo. Remember that
get_free_pirq was introduced only for the pv-ops kernel, the
classic one never needed it (and hence couldn't leak pIRQ-s).

>> That setting to a negative value is not causing the slot to be
>> permanently lost, it merely defers its freeing. It was the only
>> way I could find back then to reasonably handle an unmap
>> being done before the matched unbind.
> 
> Ah, so pt_irq_destroy_bind (XEN_DOMCTL_unbind_pt_irq) is the counterpart
> to PHYSDEVOP_get_free_pirq in some form. Which looks to be on QEMU side
> only called when the PCI device is put in sleep or pulled out of the guest.
> 
> It probably shouldn't be called when the device is merely de-activated.

Right.

Jan

