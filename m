Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaKYTbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:31:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaKYTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:31:18 -0500
Date: Tue, 25 Nov 2014 17:30:54 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
Message-ID: <20141125193054.GA12902@amt.cnet>
References: <20141125172108.992070524@redhat.com>
 <20141125172329.435080075@redhat.com>
 <5474D121.4070905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474D121.4070905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 01:57:37PM -0500, Rik van Riel wrote:
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

commit d872cfa018625071a3a6b1ea8a62a2790d2c157a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Dec 12 12:29:04 2011 +0100

    wait-simple: Simple waitqueue implementation

    wait_queue is a swiss army knife and in most of the cases the
    complexity is not needed. For RT waitqueues are a constant source of
    trouble as we can't convert the head lock to a raw spinlock due to
    fancy and long lasting callbacks.

Unsure about the details...

