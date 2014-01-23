Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaAWFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:41:43 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47576 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaAWFlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:41:42 -0500
Message-ID: <52E0AA5D.6070908@linux.vnet.ibm.com>
Date: Thu, 23 Jan 2014 11:06:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Michel Lespinasse <walken@google.com>,
        ego@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com> <87r47z2zxu.fsf@rustcorp.com.au>
In-Reply-To: <87r47z2zxu.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012305-8256-0000-0000-00000B219FB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 07:59 AM, Rusty Russell wrote:
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>> On 01/22/2014 02:00 PM, Srivatsa S. Bhat wrote:
>>> Hi Paul,
> 
> I find an old patch for register_allcpu_notifier(), but the "bool
> replay_history" should be eliminated (always true): it's too weird.
> 

Sorry, I didn't get this part. Why do you say that replay_history
will always be true?

replay_history will be set to true whenever the caller wants to
get notified of CPU_UP_PREPARE and CPU_ONLINE notifications for the
already online CPUs, or wants to run a custom setup-routine of its
own. And it will be false whenever the caller simply wants to just
register the callback.

Note that passing NULL for the setup-routine, by itself isn't enough
to make a decision. NULL + replay_history == True will invoke the normal
CPU_UP_PREPARE/CPU_ONLINE notifiers for the already online CPUs before
registering the callback. NULL + replay_history == False will just
register the callback and do nothing else.

> Then we should get rid of register_cpu_notifier, or at least hide it.
> 

Why? Isn't it easier to use (since you don't have to pass 2 additional
parameters)? I see register_allcpu_notifier (or whatever better name
we can give it), as an API for special cases where there is something
more to be done than just registering the callback. And register_cpu_notifier
will continue to be the API for the regular case when the caller wants
to just register the callback. This latter case is the majority in the
kernel. So I don't think eliminating the regular API would be a good idea.


By the way, I'm still tempted to try out the simpler-looking alternative
idea of exporting cpu_maps_update_begin() and cpu_maps_update_done()
and then mandating that the callers do:

cpu_maps_update_begin();
for_each_online_cpu(cpu) {
	...
}

__register_cpu_notifier(); // this doesn't take the add_remove_lock
cpu_maps_update_done();


I'm working on a patchset that does this and performs a tree-wide
conversion. Please let me know if you have any objections to exporting
cpu_maps_update_begin/done() in this manner.

I thought I'd give this solution a try first, before going to the much
fancier register_allcpu_notifier() method.

Regards,
Srivatsa S. Bhat

