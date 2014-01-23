Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbaAWXjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 18:39:25 -0500
Received: from ozlabs.org ([203.10.76.45]:58137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbaAWXjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 18:39:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Michel Lespinasse <walken@google.com>,
        ego@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
In-Reply-To: <52E0AA5D.6070908@linux.vnet.ibm.com>
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com> <87r47z2zxu.fsf@rustcorp.com.au> <52E0AA5D.6070908@linux.vnet.ibm.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Jan 2014 09:31:29 +1030
Message-ID: <87wqhq1ewm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> On 01/23/2014 07:59 AM, Rusty Russell wrote:
>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>>> On 01/22/2014 02:00 PM, Srivatsa S. Bhat wrote:
>>>> Hi Paul,
>> 
>> I find an old patch for register_allcpu_notifier(), but the "bool
>> replay_history" should be eliminated (always true): it's too weird.
>> 
>
> Sorry, I didn't get this part. Why do you say that replay_history
> will always be true?

OK, let me start again and try to explain myself properly:

register_cpu_notifier is a bad API.  It's hard to get right because:
1) You need to loop over online (or present) cpus once before you call
   it.
2) You have to beware the race between the loop and registration, but
   much example code happens at boot time where it doesn't matter,
   so random author is likely to copy that and have a race.
3) You have two paths doing the same thing: the loop which is run on
   every machine (cpu hotplug or not), and the notifier callback which
   is run far less rarely.

What we actually *want* is a routine which will reliably call for every
current and future CPU, and then there are very few places which should
use the current register_cpu_notifier().

ie. halfway between register_cpu_notifier() (too racy) and
register_allcpu_notifier() (too simplified).

Let's call it register_cpu_callback / unregister_cpu_callback?

> By the way, I'm still tempted to try out the simpler-looking alternative
> idea of exporting cpu_maps_update_begin() and cpu_maps_update_done()
> and then mandating that the callers do:
>
> cpu_maps_update_begin();
> for_each_online_cpu(cpu) {
> 	...
> }
>
> __register_cpu_notifier(); // this doesn't take the add_remove_lock
> cpu_maps_update_done();

Sure, fix this one for -stable.  But let's create an idiom we can be
proud of for the longer term.

Thanks,
Rusty.
