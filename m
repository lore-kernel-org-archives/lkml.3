Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaK0QuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:50:00 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:54699 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaK0Qt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:49:57 -0500
Date: Thu, 27 Nov 2014 17:49:25 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141127174925.53e9d7a6@thinkpad-w530>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9FDDD6@AcuExch.aculab.com>
References: <20141126151729.GB9612@redhat.com>
	<20141126152334.GA9648@redhat.com>
	<20141126163207.63810fcb@thinkpad-w530>
	<20141126154717.GB10568@redhat.com>
	<5475FAB1.1000802@de.ibm.com>
	<20141126163216.GB10850@redhat.com>
	<547604FC.4030300@de.ibm.com>
	<20141126170447.GC11202@redhat.com>
	<20141127070919.GA4390@osiris>
	<20141127090301.3ddc3077@thinkpad-w530>
	<20141127120441.GB4390@osiris>
	<alpine.DEB.2.11.1411271602320.3961@nanos>
	<20141127161905.7c6220ee@thinkpad-w530>
	<063D6719AE5E284EB5DD2968C1650D6D1C9FDD6A@AcuExch.aculab.com>
	<20141127164555.4bcebfe8@thinkpad-w530>
	<063D6719AE5E284EB5DD2968C1650D6D1C9FDDD6@AcuExch.aculab.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112716-0005-0000-0000-00000240DBC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Hildenbrand [mailto:dahi@linux.vnet.ibm.com]
> > > From: David Hildenbrand
> > > ...
> > > > Although it might not be optimal, but keeping a separate counter for
> > > > pagefault_disable() as part of the preemption counter seems to be the only
> > > > doable thing right now. I am not sure if a completely separated counter is even
> > > > possible, increasing the size of thread_info.
> > >
> > > What about adding (say) 0x10000 for the more restrictive test?
> > >
> > > 	David
> > >
> > 
> > You mean as part of the preempt counter?
> > 
> > The current layout (on my branch) is
> > 
> >  * PREEMPT_MASK:        0x000000ff
> >  * SOFTIRQ_MASK:        0x0000ff00
> >  * HARDIRQ_MASK:        0x000f0000
> >  *     NMI_MASK:        0x00100000
> >  * PREEMPT_ACTIVE:      0x00200000
> > 
> > I would have added
> >  * PAGEFAULT_MASK:      0x03C00000
> 
> I'm not sure where you'd need to add the bits.
> 
> I think the above works because disabling 'HARDIRQ' implicitly
> disables 'SOFTIRQ' and 'PREEMPT' (etc), so if 256+ threads
> disable PREEMPT everything still works.

AFAIK 256+ levels of preempt will break the system :)

Therefore with CONFIG_DEBUG_PREEMPT we verify that we don't have any
over/underflows.

But such bugs can only be found with CONFIG_DEBUG_PREEMPT enabled.

> 
> So if disabling pagefaults implies that pre-emption is disabled
> (but SOFTIRQ is still allowed) then you need to insert your bit(s)
> between 0xff00 and 0x00ff.
> OTOH if disabling pre-emption implies that pagefaults are disabled
> then you'd need to use the lsb and change all the above values.
> 
> Which makes me think that 'PREEMPT_ACTIVE' isn't right at all.
> Two threads disabling NMIs (or 32  disabling HARDIRQ) won't DTRT.

With threads you mean levels? This is a per thread information.

> 
> OTOH I'm only guessing at how this is used.
> 
> 	David
> 
> 
> 

