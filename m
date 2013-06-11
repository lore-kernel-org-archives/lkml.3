Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3FKUKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:10:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3FKUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:10:00 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=XpK33T7Zv8p2HuqvWZUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370981396.9844.219.camel@gandalf.local.home>
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
Date: Tue, 11 Jun 2013 16:09:56 -0400
In-Reply-To: <20130611194927.GX5146@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <51B748DA.2070306@hp.com> <20130611163607.GG5146@linux.vnet.ibm.com>
	 <51B76F77.6020004@hp.com> <20130611194927.GX5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 12:49 -0700, Paul E. McKenney wrote:

> +bool tkt_spin_pass(arch_spinlock_t *ap, struct __raw_tickets inc)
> +{
> +	if (unlikely(inc.head & 0x1)) {
> +
> +		/* This lock has a queue, so go spin on the queue. */
> +		if (tkt_q_do_spin(ap, inc))
> +			return true;
> +
> +		/* Get here if the queue is in transition: Retry next time. */
> +

This looks better, but please add a comment, something to the likes of:

	/*
	 * Only the TKT_Q_SWITCH waiter will set up the queue to prevent
	 * a thundering herd of setups to occur. It is still possible for
	 * more than one task to perform a setup if the lock is released
	 * after this check, a waiter coming in may also match this test. But
	 * that's covered by the cmpxchg() setup in tkt_q_start_contend.
	 */


> +	} else if (inc.tail - TKT_Q_SWITCH == inc.head) {

Also shouldn't this be:

	} else if ((__ticket_t)(inc.tail - TKT_Q_SWITCH) == inc.head) {

As TKT_Q_SWITCH doesn't have a type, I'm not sure how C will evaluate
this. I always screw type conversions up, and just add in the type casts
to be safe.

You could also give TKT_Q_SWITCH a type too.

-- Steve

> +
> +		/*
> +		 * This lock has lots of spinners, but no queue.
> +		 * Go create a queue to spin on.
> +		 */
> +		if (tkt_q_start_contend(ap, inc))
> +			return true;
> +
> +		/* Get here if the queue is in transition: Retry next time. */
> +	}
> +
> +	/* Either no need for a queue or the queue is in transition.  Spin. */
> +	return false;
> +}
> +EXPORT_SYMBOL(tkt_spin_pass);


