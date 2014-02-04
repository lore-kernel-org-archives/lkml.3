Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBDHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 02:13:23 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33728 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaBDHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 02:13:15 -0500
Message-ID: <1391497992.2774.17.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Date: Mon, 03 Feb 2014 23:13:12 -0800
In-Reply-To: <20140203192525.GN8874@twins.programming.kicks-ass.net>
References: <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	 <1390949495.2807.52.camel@j-VirtualBox>
	 <20140129115142.GE9636@twins.programming.kicks-ass.net>
	 <1391138977.6284.82.camel@j-VirtualBox>
	 <20140131140941.GF4941@twins.programming.kicks-ass.net>
	 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
	 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
	 <1391374883.3164.8.camel@j-VirtualBox>
	 <20140202211230.GX5002@laptop.programming.kicks-ass.net>
	 <1391452760.7498.26.camel@j-VirtualBox>
	 <20140203192525.GN8874@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 20:25 +0100, Peter Zijlstra wrote:

> +void m_spin_unlock(struct m_spinlock **lock)
> +{
> +	struct m_spinlock *node = this_cpu_ptr(&m_node);
> +	struct m_spinlock *next;
> +
> +	if (likely(cmpxchg(lock, node, NULL) == node))
> +		return;

At this current point, (node->next != NULL) is a likely scenario.
Perhaps we can also add the following code here:

	next = xchg(&node->next, NULL);
	if (next) {
		ACCESS_ONCE(next->locked) = 1;
		return;
	}

> +	next = m_spin_wait_next(lock, node, NULL);
> +	if (next)
> +		ACCESS_ONCE(next->locked) = 1;
> +}


