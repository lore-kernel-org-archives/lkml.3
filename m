Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaBJVQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:16:10 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36835 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBJVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:16:04 -0500
Message-ID: <1392066959.2051.2.camel@j-VirtualBox>
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Mon, 10 Feb 2014 13:15:59 -0800
In-Reply-To: <20140210203659.671232531@infradead.org>
References: <20140210195820.834693028@infradead.org>
	 <20140210203659.671232531@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> +void osq_unlock(struct optimistic_spin_queue **lock)
> +{
> +	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
> +	struct optimistic_spin_queue *next;
> +
> +	/*
> +	 * Fast path for the uncontended case.
> +	 */
> +	if (likely(cmpxchg(lock, node, NULL) == node))
> +		return;

Can we can also add the following code here as I'm noticing next != NULL
is the much more likely scenario on my box:

        next = xchg(&node->next, NULL);
        if (next) {
                ACCESS_ONCE(next->locked) = 1;
                return;


> +	next = osq_wait_next(lock, node, NULL);
> +	if (next)
> +		ACCESS_ONCE(next->locked) = 1;
> +}

