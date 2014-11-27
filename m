Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaK0VwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:52:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:58990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0VwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:52:18 -0500
Date: Thu, 27 Nov 2014 22:52:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
In-Reply-To: <20141127161905.7c6220ee@thinkpad-w530>
Message-ID: <alpine.DEB.2.11.1411272246110.3961@nanos>
References: <20141126151729.GB9612@redhat.com> <20141126152334.GA9648@redhat.com> <20141126163207.63810fcb@thinkpad-w530> <20141126154717.GB10568@redhat.com> <5475FAB1.1000802@de.ibm.com> <20141126163216.GB10850@redhat.com> <547604FC.4030300@de.ibm.com>
 <20141126170447.GC11202@redhat.com> <20141127070919.GA4390@osiris> <20141127090301.3ddc3077@thinkpad-w530> <20141127120441.GB4390@osiris> <alpine.DEB.2.11.1411271602320.3961@nanos> <20141127161905.7c6220ee@thinkpad-w530>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, David Hildenbrand wrote:
> > OTOH, there is no reason why we need to disable preemption over that
> > page_fault_disabled() region. There are code pathes which really do
> > not require to disable preemption for that.
> > 
> > We have that seperated in preempt-rt for obvious reasons and IIRC
> > Peter Zijlstra tried to distangle it in mainline some time ago. I
> > forgot why that never got merged.
> > 
> 
> Of course, we can completely separate that in our page fault code by doing
> pagefault_disabled() checks instead of in_atomic() checks (even in add on
> patches later).
> 
> > We tie way too much stuff on the preemption count already, which is a
> > mightmare because we have no clear distinction of protection
> > scopes. 
> 
> Although it might not be optimal, but keeping a separate counter for
> pagefault_disable() as part of the preemption counter seems to be the only
> doable thing right now.

It needs to be seperate, if it should be useful. Otherwise we just
have a extra accounting in preempt_count() which does exactly the same
thing as we have now: disabling preemption.

Now you might say, that we could mask out that part when checking
preempt_count, but that wont work on x86 as x86 has the preempt
counter as a per cpu variable and not as a per thread one.

But if you want to distangle pagefault disable from preempt disable
then you must move it to the thread, because it is a property of the
thread. preempt count is very much a per cpu counter as you can only
go through schedule when it becomes 0.

Btw, I find the x86 representation way more clear, because it
documents that preempt count is a per cpu BKL and not a magic thread
property. And sadly that is how preempt count is used ...

> I am not sure if a completely separated counter is even possible,
> increasing the size of thread_info.

And adding a ulong to thread_info is going to create exactly which
problem?

Thanks,

	tglx
