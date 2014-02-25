Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaBYT4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:56:35 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:34595 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBYT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:56:33 -0500
Message-ID: <1393358179.7727.34.camel@j-VirtualBox>
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
Date: Tue, 25 Feb 2014 11:56:19 -0800
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

> +unqueue:
> +	/*
> +	 * Step - A  -- stabilize @prev
> +	 *
> +	 * Undo our @prev->next assignment; this will make @prev's
> +	 * unlock()/unqueue() wait for a next pointer since @lock points to us
> +	 * (or later).
> +	 */
> +
> +	for (;;) {
> +		if (prev->next == node &&
> +		    cmpxchg(&prev->next, node, NULL) == node)
> +			break;
> +
> +		/*
> +		 * We can only fail the cmpxchg() racing against an unlock(),
> +		 * in which case we should observe @node->locked becomming
> +		 * true.
> +		 */
> +		if (smp_load_acquire(&node->locked))
> +			return true;
> +
> +		/*
> +		 * Or we race against a concurrent unqueue()'s step-B, in which
> +		 * case its step-C will write us a new @node->prev pointer.
> +		 */
> +		prev = ACCESS_ONCE(node->prev);

Should we also add an arch_mutex_cpu_relax() to this loop?


