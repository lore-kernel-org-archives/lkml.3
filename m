Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaKYUX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:23:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:47572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKYUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:23:27 -0500
Date: Tue, 25 Nov 2014 21:23:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rik van Riel <riel@redhat.com>
cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
In-Reply-To: <5474D121.4070905@redhat.com>
Message-ID: <alpine.DEB.2.11.1411252115460.3961@nanos>
References: <20141125172108.992070524@redhat.com> <20141125172329.435080075@redhat.com> <5474D121.4070905@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Rik van Riel wrote:
> On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
> > The problem:
> > 
> > On -RT, an emulated LAPIC timer instances has the following path:
> > 
> > 1) hard interrupt
> > 2) ksoftirqd is scheduled
> > 3) ksoftirqd wakes up vcpu thread
> > 4) vcpu thread is scheduled
> > 
> > This extra context switch introduces unnecessary latency in the 
> > LAPIC path for a KVM guest.
> > 
> > The solution:
> > 
> > Allow waking up vcpu thread from hardirq context,
> > thus avoiding the need for ksoftirqd to be scheduled.
> > 
> > Normal waitqueues make use of spinlocks, which on -RT 
> > are sleepable locks. Therefore, waking up a waitqueue 
> > waiter involves locking a sleeping lock, which 
> > is not allowed from hard interrupt context.
> > 
> 
> What are the consequences for the realtime kernel of
> making waitqueue traversal non-preemptible?
> 
> Is waitqueue traversal something that ever takes so
> long we need to care about it being non-preemptible?

__wake_up
	lock_irq_save()
	__wake_up_common()
		for_each_entry(curr)
			curr->func()
	unlock_irq_save()

There are two issues here:

1) Long waiter chains. We probably could work around that in some
   creative way

2) The non default callbacks. default is default_wake_function.

   The non default callbacks, which are used by nfsd and other stuff
   are calling the world and some more and take preemptible locks and
   do other fancy stuff which falls flat on its nose when called under
   a raw lock on rt

So I created the swait replacement which has a smaller memory
footprint, less featuritis and a raw lock because its only wakes up,
no custom callbacks.

The still suffer #1, but most use cases on RT are single waiter
scenarios anyway.

Hope that helps.

Thanks,

	tglx


