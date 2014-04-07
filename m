Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaDGRAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:00:14 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:7564 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbaDGRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:00:12 -0400
Message-ID: <5342D987.5070305@hp.com>
Date: Mon, 07 Apr 2014 12:59:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock implementation
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <1396445259-27670-2-git-send-email-Waiman.Long@hp.com> <20140404130012.GE10526@twins.programming.kicks-ass.net> <20140404165727.GQ19478@phenom.dumpdata.com> <533EE700.4080408@hp.com> <20140407140953.GK10526@twins.programming.kicks-ass.net>
In-Reply-To: <20140407140953.GK10526@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 10:09 AM, Peter Zijlstra wrote:
> On Fri, Apr 04, 2014 at 01:08:16PM -0400, Waiman Long wrote:
>> Peter's patch is a rewrite of my patches 1-4, there is no PV or unfair lock
>> support in there.
> Yes, because your patches were unreadable and entirely non obvious.
>
> And while I appreciate that its not entirely your fault; the subject is
> hard, you didn't even try to make it better and explain things in a
> normal gradual fashion.
>
> So what I did was start with a 'simple' correct implementation (although
> I could have started simpler still I suppose and added 3-4 more patches)
> and then added each optimization on top and explained the what and why
> for them.
>
> The result is similar code, but the path is ever so much easier to
> understand and review.

I appreciate your time in rewriting the code to make it easier to 
review. I will based my next patch on your rewrite. However, I am going 
to make the following minor changes:

1. I would like to series to be compilable with tip/master and v3.15-rc. 
Your patches seem to use some constants like __BYTE_ORDER__ that are not 
defined there. I will make change that to make them compilable on top of 
the latest upstream code.

2. Your patch uses atomic_test_and_set_bit to set the pending bit. I 
would prefer to use atomic_cmpxchg() which will ensure that the pending 
bit won't be set when some other tasks are already on the queue. This 
will also enable me to allow the simple setting of the lock bit without 
using atomic instruction. This change doesn't change performance that 
much when I tested it on Westmere. But on IvyBridge, it had a pretty big 
performance impact.

3. I doubt it is a good idea for the queue head to use atomic_cmpxchg() 
to pound on the lock cacheline repeatedly in the waiting loop. It will 
make it much harder for the lock holder to access the lock cacheline. I 
will use a simple atomic_read to query the status of the lock before 
doing any write on it.


>
> And no, it doesn't have PV support; I spend the whole week trying to
> reverse engineer your patch 1; whereas if you'd presented it in the form
> I posted I might have agreed in a day or so.
>
> I still have to look at the PV bits; but seeing how you have shown no
> interest in writing coherent and understandable patch sets I'm less
> inclined to go stare at them for another few weeks and rewrite that code
> too.
>
> Also; theres a few subtle but important differences between the patch
> sets. Your series only makes x86_64 use the qspinlocks; the very last we
> want is i386 and x86_64 to use different spinlock implementations; we
> want less differences between them, not more.

I have no problem of making qspinlock the default for all x86 code.

>
> You stuff a whole lot of code into arch/x86 for no reason what so ever.
>
> Prior to that; I also rewrote your benchmark thing; using jiffies for
> timing is just vile. Not to mention you require a full kernel build and
> reboot (which is just stupid slow on big machines) to test anything.

Yes, using jiffies isn't the best idea, it is just an easier way. BTW, I 
don't need to reboot the machine to run my test, I only need to build 
the .ko file and use insmod to insert into the running kernel. When it 
is done, rmmod can be used to remove it. I do need to rebuild the kernel 
when I make changes to the qspinlock patch.

-Longman
