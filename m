Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3KWFkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:40:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:27793 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3KWFkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:40:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="432520857"
Message-ID: <1385185207.29354.166.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Fri, 22 Nov 2013 21:40:07 -0800
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
> 
> - decrement the counter at __unqueue_me() to reflect when an element is
>   removed from the queue for wakeup related purposes.

What is the problem you are trying to solve here?

The fast-path in futexes is not calling into the kernel at all, if
you've made the syscall, you've already lost. What kind of improvement
are you seeing by adding this optimization? Is it worth the introduction
of atomic operations into a file known to the state of California to
increase the risk of liver failure?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


