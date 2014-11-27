Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaK0PHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:07:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:57280 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaK0PHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:07:13 -0500
Date: Thu, 27 Nov 2014 16:07:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: David Hildenbrand <dahi@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
In-Reply-To: <20141127120441.GB4390@osiris>
Message-ID: <alpine.DEB.2.11.1411271602320.3961@nanos>
References: <20141126151729.GB9612@redhat.com> <20141126152334.GA9648@redhat.com> <20141126163207.63810fcb@thinkpad-w530> <20141126154717.GB10568@redhat.com> <5475FAB1.1000802@de.ibm.com> <20141126163216.GB10850@redhat.com> <547604FC.4030300@de.ibm.com>
 <20141126170447.GC11202@redhat.com> <20141127070919.GA4390@osiris> <20141127090301.3ddc3077@thinkpad-w530> <20141127120441.GB4390@osiris>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Heiko Carstens wrote:
> On Thu, Nov 27, 2014 at 09:03:01AM +0100, David Hildenbrand wrote:
> > > Code like
> > > 	spin_lock(&lock);
> > > 	if (copy_to_user(...))
> > > 		rc = ...
> > > 	spin_unlock(&lock);
> > > really *should* generate warnings like it did before.
> > > 
> > > And *only* code like
> > > 	spin_lock(&lock);
> > 
> > Is only code like this valid or also with the spin_lock() dropped?
> > (e.g. the access in patch1 if I remember correctly)
> > 
> > So should page_fault_disable() increment the pagefault counter and the preempt
> > counter or only the first one?
> 
> Given that a sequence like
> 
> 	page_fault_disable();
>  	if (copy_to_user(...))
>  		rc = ...
>  	page_fault_enable();
> 
> is correct code right now I think page_fault_disable() should increase both.
> No need for surprising semantic changes.

OTOH, there is no reason why we need to disable preemption over that
page_fault_disabled() region. There are code pathes which really do
not require to disable preemption for that.

We have that seperated in preempt-rt for obvious reasons and IIRC
Peter Zijlstra tried to distangle it in mainline some time ago. I
forgot why that never got merged.

We tie way too much stuff on the preemption count already, which is a
mightmare because we have no clear distinction of protection
scopes. 

Thanks,

	tglx
