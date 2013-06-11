Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3FKU4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:56:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3FKU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:56:52 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=zBYaxKdOuRR6g7Cm3kIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370984210.9844.225.camel@gandalf.local.home>
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
Date: Tue, 11 Jun 2013 16:56:50 -0400
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

> +config TICKET_LOCK_QUEUED
> +	bool "Dynamically switch between ticket and queued locking"
> +	depends on SMP
> +	default n
> +	---help---
> +	  Enable dynamic switching between ticketlock and queued locking
> +	  on a per-lock basis.  This option will slow down low-contention
> +	  acquisition and release very slightly (additional conditional
> +	  in release path), but will provide more efficient operation at
> +	  high levels of lock contention.  High-contention operation will
> +	  not be quite as efficient as would be a pure queued lock, but
> +	  this dynamic approach consumes less memory than queud locks
> +	  and also runs faster at low levels of contention.
> +
> +	  Say "Y" if you are running on a large system with a workload
> +	  that is likely to result in high levels of contention.
> +
> +	  Say "N" if you are unsure.
> +
> +config TICKET_LOCK_QUEUED_SWITCH
> +	int "When to switch from ticket to queued locking"
> +	depends on TICKET_LOCK_QUEUED
> +	default 8
> +	range 3 32
> +	---help---
> +	  Specify how many tasks should be spinning on the lock before
> +	  switching to queued mode.  Systems with low-latency memory/cache
> +	  interconnects will prefer larger numbers, while extreme low-latency
> +	  and real-time workloads will prefer a smaller number.  Of course,
> +	  extreme real-time workloads would be even happier if contention
> +	  on the locks were reduced to the point that there was never any
> +	  need for queued locking in the first place.

Are you sure real-time wants low numbers? I would think that real-time
would want this off. This is just a way to help prevent cache ping
ponging, but it adds to non-deterministic behavior. As I mentioned
before, even though you fixed the thundering herd on setup, once the
queue is set, then we will get a thundering herd of tasks trying to
queue itself, and the task that was spinning the longest could very well
become the one at the end of the FIFO.

-- Steve



> +
> +	  Take the default if you are unsure.
> diff --git a/kernel/Makefile b/kernel/Makefile


