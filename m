Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3FKSmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:42:15 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3074 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3FKSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:42:14 -0400
Message-ID: <51B76F77.6020004@hp.com>
Date: Tue, 11 Jun 2013 14:41:59 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <20130609193657.GA13392@linux.vnet.ibm.com> <51B748DA.2070306@hp.com> <20130611163607.GG5146@linux.vnet.ibm.com>
In-Reply-To: <20130611163607.GG5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:36 PM, Paul E. McKenney wrote:
>
>> I am a bit concern about the size of the head queue table itself.
>> RHEL6, for example, had defined CONFIG_NR_CPUS to be 4096 which mean
>> a table size of 256. Maybe it is better to dynamically allocate the
>> table at init time depending on the actual number of CPUs in the
>> system.
> But if your kernel is built for 4096 CPUs, the 32*256=8192 bytes of memory
> is way down in the noise.  Systems that care about that small an amount
> of memory probably have a small enough number of CPUs that they can just
> turn off queueing at build time using CONFIG_TICKET_LOCK_QUEUED=n, right?

My concern is more about the latency on the table scan than the actual 
memory that was used.

>
>>> +/*
>>> + * Return a pointer to the queue header associated with the specified lock,
>>> + * or return NULL if there is no queue for the lock or if the lock's queue
>>> + * is in transition.
>>> + */
>>> +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
>>> +{
>>> +	int i;
>>> +	int start;
>>> +
>>> +	start = i = tkt_q_hash(asp);
>>> +	do
>>> +		if (tkt_q_heads[i].ref == asp)
>>> +			return&tkt_q_heads[i];
>>> +	while ((i = tkt_q_next_slot(i)) != start);
>>> +	return NULL;
>>> +}
>> With a table size of 256 and you have to scan the whole table to
>> find the right head queue. This can be a significant overhead. I
>> will suggest setting a limiting of how many entries it scans before
>> it aborts rather than checking the whole table.
> But it will scan 256 entries only if there are 256 other locks in queued
> mode, which is -very- unlikely, even given 4096 CPUs.  That said, if you
> show me that this results in a real latency problem on a real system,
> I would be happy to provide a way to limit the search.

Looking at the code more carefully, the chance of actually scanning 256 
entries is very small. However, I now have some concern on the way you 
set up the initial queue.

+/*
+ * Start handling a period of high contention by finding a queue to associate
+ * with this lock.  Returns true if successful (in which case we hold the
+ * lock) and false otherwise (in which case we do -not- hold the lock).
+ */
+bool tkt_q_start_contend(arch_spinlock_t *asp, struct __raw_tickets inc)
+{
+	int i;
+	int start;
+
+	/* Hash the lock address to find a starting point. */
+	start = i = tkt_q_hash(asp);
+
+	/*
+	 * Each pass through the following loop attempts to associate
+	 * the lock with the corresponding queue.
+	 */
+	do {
+		/*
+		 * Use 0x1 to mark the queue in use, but also avoiding
+		 * any spinners trying to use it before we get it all
+		 * initialized.
+		 */
+		if (cmpxchg(&tkt_q_heads[i].ref,
+			    NULL,
+			    (arch_spinlock_t *)0x1) == NULL) {
+
+			/* Succeeded, now go initialize it. */
+			return tkt_q_init_contend(i, asp, inc);
+		}
+
+		/* If someone beat us to it, go spin on their queue. */
+		if (ACCESS_ONCE(asp->tickets.head)&  0x1)
+			return tkt_q_do_spin(asp, inc);
+	} while ((i = tkt_q_next_slot(i)) != start);
+
+	/* All the queues are in use, revert to spinning on the ticket lock. */
+	return false;
+}
+

Unconditional cmpxchg() can be a source of high contention by itself. 
Considering that 16 threads may be doing cmpxchg() more or less 
simultaneously on the same cache line, it can cause a lot of contention. 
It will be better if you check to see if tkt_q_heads[i] is NULL first 
before doing cmpxchg.

Another point is that the 16 threads maybe setting up the queues in 
consecutive slots in the head table. This is both a source of contention 
and a waste of effort. One possible solution is to add one more field 
(set to cpuid + 1, for example) to indicate that that setup is being 
done with asp set to the target lock address immediately. We will need 
to use cmpxchg128() for 64-bit machine, though. Another solution is to 
have only that thread with ticket number that is a fixed distance from 
head (e.g. 16*2) to do the queue setup while the rest wait until the 
setup is done before spinning on the queue.

As my colleague Davidlohr had reported there are more regressions than 
performance improvement in the AIM7 benchmark. I believe that queue 
setup contention is likely a source of performance regression.

Regards,
Longman
