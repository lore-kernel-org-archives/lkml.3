Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3KYOkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:40:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3KYOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:40:04 -0500
Date: Mon, 25 Nov 2013 15:39:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: Re: Add memory barrier when waiting on futex
Message-ID: <20131125143952.GB10022@twins.programming.kicks-ass.net>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:15:17PM +0000, Ma, Xindong wrote:
> We encountered following panic several times:

> [   74.671982] BUG: unable to handle kernel NULL pointer dereference at 00000008
> [   74.672101] IP: [<c129bb27>] wake_futex+0x47/0x80

> [   74.674144]  [<c129bc29>] futex_wake+0xc9/0x110
> [   74.674195]  [<c129da0b>] do_futex+0xeb/0x950
> [   74.674484]  [<c129e30b>] SyS_futex+0x9b/0x140
> [   74.674582]  [<c195a718>] syscall_call+0x7/0xb
> 
> On smp systems, setting current task to q->task in queue_me() may
> not visible immediately to another cpu, some times this will
> cause panic in wake_futex(). Adding memory barrier to avoid this.
> 
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> ---
>  kernel/futex.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 80ba086..792cd41 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1529,6 +1529,7 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
>  	plist_node_init(&q->list, prio);
>  	plist_add(&q->list, &hb->chain);
>  	q->task = current;
> +	smp_mb();
>  	spin_unlock(&hb->lock);
>  }

This is wrong, because an uncommented barrier is wrong per definition.

This is further wrong because wake_futex() is always called with
hb->lock held, and since queue_me also has hb->lock held, this is in
fact guaranteed.

This is even more wrong for adding stable.
