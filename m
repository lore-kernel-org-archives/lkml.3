Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbaAaS7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:59:11 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32749 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaAaS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:59:08 -0500
Message-ID: <52EBF276.1020505@hp.com>
Date: Fri, 31 Jan 2014 13:59:02 -0500
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
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock implementation
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com> <20140130130453.GB2936@laptop.programming.kicks-ass.net> <20140130151715.GA5126@laptop.programming.kicks-ass.net> <20140131092616.GC5126@laptop.programming.kicks-ass.net>
In-Reply-To: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 04:26 AM, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 04:17:15PM +0100, Peter Zijlstra wrote:
>> The below is still small and actually works.
> OK, so having actually worked through the thing; I realized we can
> actually do a version without MCS lock and instead use a ticket lock for
> the waitqueue.
>
> This is both smaller (back to 8 bytes for the rwlock_t), and should be
> faster under moderate contention for not having to touch extra
> cachelines.
>
> Completely untested and with a rather crude generic ticket lock
> implementation to illustrate the concept:
>

Using a ticket lock instead will have the same scalability problem as 
the ticket spinlock as all the waiting threads will spin on the lock 
cacheline causing a lot of cache bouncing traffic. That is the reason 
why I want to replace ticket spinlock with queue spinlock. If the 
16-byte size is an issue, I can use the same trick in the queue spinlock 
patch to reduce its size down to 8 bytes with a bit more overhead in the 
slowpath.

Another thing I want to discuss about is whether a bit more overhead in 
moderate contention cases is really such a bit deal. With moderate 
contention, I suppose the amount of time spent in the locking functions 
will be just a few percent at most for real workloads. It won't really 
be noticeable if the locking functions take, maybe, 50% more time to 
finish. Anyway, I am going to do more performance testing on low end 
machines.

-Longman
