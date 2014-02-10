Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaBJW7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:59:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaBJW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:59:48 -0500
Date: Mon, 10 Feb 2014 14:59:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 6/8] mutex: Extra reschedule point
Message-Id: <20140210145946.41a64fd9832b41e90c852e40@linux-foundation.org>
In-Reply-To: <20140210203659.734441092@infradead.org>
References: <20140210195820.834693028@infradead.org>
	<20140210203659.734441092@infradead.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 20:58:26 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> Add in an extra reschedule in an attempt to avoid getting reschedule
> the moment we've acquired the lock.
> 
> ...
>
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -468,6 +468,13 @@ __mutex_lock_common(struct mutex *lock,
>  	}
>  	osq_unlock(&lock->osq);
>  slowpath:
> +	/*
> +	 * If we fell out of the spin path because of need_resched(),
> +	 * reschedule now, before we try-lock the mutex. This avoids getting
> +	 * scheduled out right after we obtained the mutex.
> +	 */
> +	if (unlikely(need_resched()))
> +		schedule_preempt_disabled();

need_resched() already does unlikely().
