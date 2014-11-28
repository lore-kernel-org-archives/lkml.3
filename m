Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaK1HfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 02:35:07 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39947 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaK1HfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 02:35:04 -0500
Date: Fri, 28 Nov 2014 08:34:54 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141128083454.403d5620@thinkpad-w530>
In-Reply-To: <alpine.DEB.2.11.1411272246110.3961@nanos>
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
	<alpine.DEB.2.11.1411272246110.3961@nanos>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112807-0013-0000-0000-000002050F03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 27 Nov 2014, David Hildenbrand wrote:
> > > OTOH, there is no reason why we need to disable preemption over that
> > > page_fault_disabled() region. There are code pathes which really do
> > > not require to disable preemption for that.
> > > 
> > > We have that seperated in preempt-rt for obvious reasons and IIRC
> > > Peter Zijlstra tried to distangle it in mainline some time ago. I
> > > forgot why that never got merged.
> > > 
> > 
> > Of course, we can completely separate that in our page fault code by doing
> > pagefault_disabled() checks instead of in_atomic() checks (even in add on
> > patches later).
> > 
> > > We tie way too much stuff on the preemption count already, which is a
> > > mightmare because we have no clear distinction of protection
> > > scopes. 
> > 
> > Although it might not be optimal, but keeping a separate counter for
> > pagefault_disable() as part of the preemption counter seems to be the only
> > doable thing right now.
> 
> It needs to be seperate, if it should be useful. Otherwise we just
> have a extra accounting in preempt_count() which does exactly the same
> thing as we have now: disabling preemption.
> 
> Now you might say, that we could mask out that part when checking
> preempt_count, but that wont work on x86 as x86 has the preempt
> counter as a per cpu variable and not as a per thread one.

Ah right, it's per cpu on x86. So it really belongs to a thread if we want to
demangle preemption and pagefault_disable.

Would work for now, but for x86 not on the long run.

> 
> But if you want to distangle pagefault disable from preempt disable
> then you must move it to the thread, because it is a property of the
> thread. preempt count is very much a per cpu counter as you can only
> go through schedule when it becomes 0.

Thinking about it, this makes perfect sense!

> 
> Btw, I find the x86 representation way more clear, because it
> documents that preempt count is a per cpu BKL and not a magic thread
> property. And sadly that is how preempt count is used ...
> 
> > I am not sure if a completely separated counter is even possible,
> > increasing the size of thread_info.
> 
> And adding a ulong to thread_info is going to create exactly which
> problem?

If we're allowed to increase the size of thread_info - absolutely fine with me!
(I am not sure if some archs have special constraints on the size)

Will see what I can come up with.

Thanks!

> 
> Thanks,
> 
> 	tglx
> 

