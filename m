Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbaELRaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:30:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:36565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbaELR37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:29:59 -0400
Date: Mon, 12 May 2014 19:29:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
Message-ID: <20140512172953.GF13467@laptop.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
 <20140512152208.GA12309@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140512152208.GA12309@potion.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 05:22:08PM +0200, Radim Krčmář wrote:
> 2014-05-07 11:01-0400, Waiman Long:
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > Because the qspinlock needs to touch a second cacheline; add a pending
> > bit and allow a single in-word spinner before we punt to the second
> > cacheline.
> 
> I think there is an unwanted scenario on virtual machines:
> 1) VCPU sets the pending bit and start spinning.
> 2) Pending VCPU gets descheduled.
>     - we have PLE and lock holder isn't running [1]
>     - the hypervisor randomly preempts us
> 3) Lock holder unlocks while pending VCPU is waiting in queue.
> 4) Subsequent lockers will see free lock with set pending bit and will
>    loop in trylock's 'for (;;)'
>     - the worst-case is lock starving [2]
>     - PLE can save us from wasting whole timeslice
> 
> Retry threshold is the easiest solution, regardless of its ugliness [4].
> 
> Another minor design flaw is that formerly first VCPU gets appended to
> the tail when it decides to queue;
> is the performance gain worth it?

This is all for real hardware, I've not yet stared at the (para)virt
crap.

My primary concern is that native hardware runs good and that the
(para)virt support does rape the code -- so far its failing hard on the
second.


