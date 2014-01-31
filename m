Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbaAaVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:09:42 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:33160 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaAaVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:09:41 -0500
Message-ID: <52EC110D.4030509@hp.com>
Date: Fri, 31 Jan 2014 16:09:33 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock implementation
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com> <20140130130453.GB2936@laptop.programming.kicks-ass.net> <20140130151715.GA5126@laptop.programming.kicks-ass.net> <20140131092616.GC5126@laptop.programming.kicks-ass.net> <52EBF276.1020505@hp.com> <20140131201401.GD2936@laptop.programming.kicks-ass.net>
In-Reply-To: <20140131201401.GD2936@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 03:14 PM, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 01:59:02PM -0500, Waiman Long wrote:
>> On 01/31/2014 04:26 AM, Peter Zijlstra wrote:
>>> On Thu, Jan 30, 2014 at 04:17:15PM +0100, Peter Zijlstra wrote:
>>>> The below is still small and actually works.
>>> OK, so having actually worked through the thing; I realized we can
>>> actually do a version without MCS lock and instead use a ticket lock for
>>> the waitqueue.
>>>
>>> This is both smaller (back to 8 bytes for the rwlock_t), and should be
>>> faster under moderate contention for not having to touch extra
>>> cachelines.
>>>
>>> Completely untested and with a rather crude generic ticket lock
>>> implementation to illustrate the concept:
>>>
>> Using a ticket lock instead will have the same scalability problem as the
>> ticket spinlock as all the waiting threads will spin on the lock cacheline
>> causing a lot of cache bouncing traffic.
> A much more important point for me is that a fair rwlock has a _much_
> better worst case behaviour than the current mess. That's the reason I
> was interested in the qrwlock thing. Not because it can run contended on
> a 128 CPU system and be faster at being contended.
>
> If you contend a lock with 128 CPUs you need to go fix that code that
> causes this abysmal behaviour in the first place.
>
>

I am not against the use of ticket spinlock as the queuing mechanism on 
small systems. I do have  concern about the contended performance on 
large NUMA systems which is my primary job responsibility. Depending on 
the workload, contention can happens anywhere. So it is easier said than 
done to fix whatever lock contention that may happen.

How about making the selection of MCS or ticket queuing either user 
configurable or depending on the setting of NR_CPUS, NUMA, etc?

-Longman

-Longman
