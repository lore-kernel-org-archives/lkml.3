Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3FODhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 23:37:01 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:34669 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3FODhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 23:37:00 -0400
Message-ID: <51BBE14D.2050605@hp.com>
Date: Fri, 14 Jun 2013 23:36:45 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>  <1370974231.9844.212.camel@gandalf.local.home>  <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>  <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>  <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>  <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>  <20130612233224.GH4165@ZenIV.linux.org.uk>  <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>  <20130613002058.GI4165@ZenIV.linux.org.uk>  <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>  <20130613004941.GJ4165@ZenIV.linux.org.uk>  <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com>  <51BB2FFC.8060209@hp.com>  <CA+55aFxmdPAeknSVH8fhdJW4VH=EcJ4dfBQUuQp_M_hnrr295g@mail.gmail.com>  <51BB5E27.5010009@hp.com> <1371259580.21896.18.camel@pasglop>
In-Reply-To: <1371259580.21896.18.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:26 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2013-06-14 at 14:17 -0400, Waiman Long wrote:
>> With some minor changes, the current patch can be modified to support
>> debugging lock for 32-bit system. For 64-bit system, we can apply a
>> similar concept for debugging lock with cmpxchg_double. However, for
>> architecture that does not have cmpxchg_double support, it will be out
>> of luck and we probably couldn't support the same feature in debugging
>> mode. It will have to fall back to taking the lock.
> That means only x86_64 and s390 would benefit from it ... I'm sure we can do better :-)
>
> Cheers,
> Ben.

On second thought, using cmpxchg_double may not be such a good idea 
after all as it requires a 16-byte alignment, at least for x86-64. 
Another possible alternative is to integrate the reference count 
directly into the spinlock_t data structure immediately after 
arch_spinlock_t for this special case. If CONFIG_GENERIC_LOCKBREAK is 
not defined, there will be a 4-byte hole that can be used. Otherwise, 
the spinlock_t structure will have an 8 byte size increase. I suppose 
that others won't be too upset for an 8-byte increase in size when 
spinlock debugging is turned on.

Regards,
Longman
