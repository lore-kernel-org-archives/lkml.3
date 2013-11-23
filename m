Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3KWHUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 02:20:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:56441 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3KWHUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 02:20:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="413450807"
Message-ID: <1385191205.29354.208.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Fri, 22 Nov 2013 23:20:05 -0800
In-Reply-To: <1385168197-8612-5-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 16:56 -0800, Davidlohr Bueso wrote:
> In futex_wake() there is clearly no point in taking the hb->lock if
> we know beforehand that there are no tasks to be woken. This comes
> at the smaller cost of doing some atomic operations to keep track of
> the list's size. Specifically, increment the counter when an element is
> added to the list, and decrement when it is removed. Of course, if the
> counter is 0, then there are no tasks blocked on a futex. Some special
> considerations:
> 
> - increment the counter at queue_lock() as we always end up calling
>   queue_me() which adds the element to the list. Upon any error,
>   queue_unlock() is called for housekeeping, for which we decrement
>   to mach the increment done in queue_lock().

      ^match

> 
> - decrement the counter at __unqueue_me() to reflect when an element is
>   removed from the queue for wakeup related purposes.

__unqueue_futex (not __unqueue_me)


> @@ -999,6 +1001,10 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
>  		goto out;
>  
>  	hb = hash_futex(&key);
> +	/* make sure we really have tasks to wakeup */

Nit, but please use proper sentence formatting for consistency with the
rest of the comments in futex.c (most of them anyway).

	/* Make sure we really have tasks to wake up. */

Now... I'm not thrilled with adding atomics if we don't need to,
especially for an optimization since the atomics themselves cause enough
problems, especially across a large number of CPUs... I'll respond to
Linus's thread though.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


