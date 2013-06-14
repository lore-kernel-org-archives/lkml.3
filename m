Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3FNSR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:17:26 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:37935 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3FNSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:17:24 -0400
Message-ID: <51BB5E27.5010009@hp.com>
Date: Fri, 14 Jun 2013 14:17:11 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, ????????? <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net> <1370974231.9844.212.camel@gandalf.local.home> <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net> <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com> <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net> <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com> <20130612233224.GH4165@ZenIV.linux.org.uk> <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com> <20130613002058.GI4165@ZenIV.linux.org.uk> <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com> <20130613004941.GJ4165@ZenIV.linux.org.uk> <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com> <51BB2FFC.8060209@hp.com> <CA+55aFxmdPAeknSVH8fhdJW4VH=EcJ4dfBQUuQp_M_hnrr295g@mail.gmail.com>
In-Reply-To: <CA+55aFxmdPAeknSVH8fhdJW4VH=EcJ4dfBQUuQp_M_hnrr295g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 11:37 AM, Linus Torvalds wrote:
> On Fri, Jun 14, 2013 at 8:00 AM, Waiman Long<waiman.long@hp.com>  wrote:
>> On 06/12/2013 08:59 PM, Linus Torvalds wrote:
>>> Ho humm.. interesting. I was talking about wanting to mix atomics and
>>> spinlocks earlier in this thread due to space constraints, and it
>>> strikes me that that would actually help this case a lot. Having the
>>> dentry count mix d_lock and the count in one word would allow for
>>> atomic ops like "increment if not locked", and we'd avoid this whole
>>> race entirely..
>>>
>>> Something like "low bit of count is the lock bit" would end up being
>>> lovely for this case. Of course, that's not how our spinlocks work ..
>>>
>>>                 Linus
>>
>> I have created another patch to do exactly the "increment if not locked"
>> operation as suggested. It did help a lot. See the patch below for more
>> information. Any additional comment will be appreciated.
> Hmm. This is interesting and proves the concept, and the numbers look
> very promising.
>
> The patch is not mergable, though, since it clearly depends on the
> spinlock/d_count fitting in a u64, which is normally true, but not the
> case of debugging locks etc, we'd need to generalize and fix the whole
> concept of "refcount+lock".

With some minor changes, the current patch can be modified to support 
debugging lock for 32-bit system. For 64-bit system, we can apply a 
similar concept for debugging lock with cmpxchg_double. However, for 
architecture that does not have cmpxchg_double support, it will be out 
of luck and we probably couldn't support the same feature in debugging 
mode. It will have to fall back to taking the lock.

I was thinking about generalizing the fix, but one issue that I was 
aware of was that the d_lock member of dentry had more than 300 
references throughout the filesystem code. A general fix will require 
d_lock to be accessed in a different way. So it will be a pretty massive 
patch touching quite a lot of files even though the changes will be 
pretty straightforward in most cases.

> Generalizing it might be a good idea anyway, since there are other
> cases of "atomic_dec_and_lock()" etc behaviours where we might want to
> have these kinds of extended lock+count shenanigans.

The patch can certainly be generalized. I will see what I can do in a 
week of two.

> I also do wonder if we could perhaps fit both in 32-bits, and just not
> use the "real" spinlocks at all, but use a bitlock in the low (or
> high) bit of the refcount. We do that in some other places - we'd
> potentially lose lockdep etc, and we'd lose some of the other good
> parts of spinlocks (fairness yadda yadda), but *if* we can reduce
> contention enough that it works out, maybe it would be worth it.

As the dentry is such an important data structure for the filesystem 
layer, losing the fairness attribute and the ability to debug may be too 
high a price to pay. For other niche cases, such a combined data type 
can certainly be used.

> So this doesn't look like 3.11 material, but the numbers certainly
> make it look very promising, so with some more work on it ...
>
>                  Linus

When will be the deadline for stable patch that can be considered to be 
merged in 3.11?

Regards,
Longman
