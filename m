Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3FKUxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:53:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3FKUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:53:46 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=sFt4mayCuEILOzXux4EA:9 a=QEXdDO2ut3YA:10 a=MSXsv7QPH1Of2c-W:21 a=DQvyItDMaTMvxFIC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370984023.9844.221.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Date: Tue, 11 Jun 2013 16:53:43 -0400
In-Reply-To: <20130611203256.GE5146@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <51B748DA.2070306@hp.com> <20130611163607.GG5146@linux.vnet.ibm.com>
	 <51B76F77.6020004@hp.com> <20130611194927.GX5146@linux.vnet.ibm.com>
	 <1370981396.9844.219.camel@gandalf.local.home>
	 <20130611203256.GE5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 13:32 -0700, Paul E. McKenney wrote:

> 		/*
> 		 * This lock has lots of spinners, but no queue.  Go create
> 		 * a queue to spin on.
> 		 *
> 		 * In the common case, only the single task that
> 		 * sees the head and tail tickets being different by
> 		 * exactly TKT_Q_SWITCH will come here set up the queue,
> 		 * which prevents a "thundering herd" of queue setups.
> 		 * Although it is still possible for an unfortunate series
> 		 * of lock handoffs and newly arrived tasks to result
> 		 * in more than one task performing a queue setup, this
> 		 * is unlikely.  Of course, this situation must still be
> 		 * handled correctly, which is the job of the cmpxchg()
> 		 * in tkt_q_start_contend().
> 		 */
> 		if (tkt_q_start_contend(ap, inc))
> 			return true;
> 
> Does that help?

Yes, very good.

> 
> > As TKT_Q_SWITCH doesn't have a type, I'm not sure how C will evaluate
> > this. I always screw type conversions up, and just add in the type casts
> > to be safe.
> > 
> > You could also give TKT_Q_SWITCH a type too.
> 
> This is an excellent point as well -- things might well get confused.
> My solution was to take your last suggestion and given TKT_Q_SWITCH the
> same type as inc.tail and inc.head, and also apply type-safety paranoia
> to TKT_Q_NQUEUES:
> 
> /*
>  * TKT_Q_SWITCH is twice the number of CPUs that must be spinning on a
>  * given ticket lock to motivate switching to spinning on a queue.
>  * The reason that it is twice the number is because the bottom bit of
>  * the ticket is reserved for the bit that indicates that a queue is
>  * associated with the lock.
>  */
> #define TKT_Q_SWITCH  ((__ticket_t)(CONFIG_TICKET_LOCK_QUEUED_SWITCH * 2))
> 
> /*
>  * TKT_Q_NQUEUES is the number of queues to maintain.  Large systems
>  * might have multiple highly contended locks, so provide more queues for
>  * systems with larger numbers of CPUs.
>  */
> #define TKT_Q_NQUEUES (2 * DIV_ROUND_UP(NR_CPUS + ((int)TKT_Q_SWITCH) - 1, \
> 					(int)TKT_Q_SWITCH))
> 
> Does that look OK?  (The limits on the value of TKT_Q_SWITCH should avoid
> signed integer overflow.)
> 

Looks fine.

-- Steve


