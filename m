Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaGKWcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:32:50 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49786 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaGKWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140711094333.GG16041@linux.vnet.ibm.com>
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com> <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com> <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
 <20140711094333.GG16041@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 11 Jul 2014 18:32:17 -0400
Message-ID: <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 5:43 AM, Paul E. McKenney  wrote:
> On Thu, Jul 10, 2014 at 09:17:33PM -0400, Pranith Kumar wrote:
>> On Wed, Jul 9, 2014 at 3:56 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> <snip>
>> > OK, so ->dynticks_snap is accessed by only one task, namely the
>> > corresponding RCU grace-period kthread.  So it can be accessed without
>> > any atomic instructions or memory barriers, since all accesses to it are
>> > single-threaded.  On the other hand, ->dynticks is written by one CPU
>> > and potentially accessed from any CPU.  Therefore, accesses to it must
>> > take concurrency into account.  Especially given that any confusion can
>> > fool RCU into thinking that a CPU is idle when it really is not, which
>> > could result in too-short grace periods, which could in turn result in
>> > random memory corruption.
>>
>> Yes, I missed reading the call-chain for accessing dynticks_snap. It
>> does not need any synchronization/barriers.
>>
>> Here since we are reading ->dynticks, doesn't having one barrier
>> before reading make sense? like
>>
>> smp_mb();
>> dynticks_snap = atomic_read(...->dynticks);
>>
>> instead of having two barriers with atomic_add_return()? i.e.,
>> why is the second barrier necessary?
>
> I suggest looking at the docbook comment headers for call_rcu() and
> synchronize_rcu() and thinking about the memory-barrier guarantees.
> Those guarantees are quite strong, and so if you remove any one of a
> large number of memory barriers (either explicit or, as in this case,
> implicit in some other operation), you will break RCU.
>
> Now, there might well be some redundant memory barriers somewhere in
> RCU, but the second memory barrier implied by this atomic_add_return()
> most certainly is not one of them.

One reason I could think of having barriers on both sides here is to
disable the read to float around. But in these two particular cases
that does not seem to be necessary.

Could you please clarify why a barrier after this atomic read is
required? Almost all the barriers are commented about why they are
necessary. Would be good to have that here too.

<snip>
>>
>> Sorry to ask you about such an old change. But I am not able to see
>> why we need atomic_t for dynticks here since per-cpu operations are
>> guaranteed to be atomic.
>
> Per-CPU operations are guaranteed to be atomic?  When one CPU is accessing
> another CPU's per-CPU variable, as is the case here?  Can't say that I
> believe you.  ;-)

this_cpu_ops() are guaranteed to be atomic when operating on local
per-cpu variables. When we are operating on other CPU's per-cpu
variables directly this does not hold.

dynticks here is a per-cpu variable. I don't understand why one CPU
needs to access another CPU's dynticks variable.

>
>> It gets twisted pretty fast trying to understand the RCU code. No
>> wonder people say that rcu is scary black magic :)
>
> Well, let's just say that this isn't one of the parts of the RCU code
> that should be randomly hacked.  Lots and lots of ways to get it wrong,
> and very few ways to get it right.  And most of the ways of getting it
> right are too slow or too non-scalable to be useful.

I am definitely not trying to hack randomly. Reading the code is very
educating. I tried looking up why this was being done and it was not
clear from the code and history. I was thinking of getting hold of you
on IRC, but was not sure if that is such a good idea. I'll ask
questions instead of sending RFCs from now on.

>
> Speaking of portions of RCU that are more susceptible to local-knowledge
> hacking, how are things going on that rcutorture printing fixup?
>
>                                                         Thanx, Paul
>

It must have reached your inbox by now :)

-- 
Pranith
