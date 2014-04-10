Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbaDJKHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbaDJKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:07:33 -0400
Message-ID: <53466D63.8080808@canonical.com>
Date: Thu, 10 Apr 2014 12:07:31 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] reservation: add suppport for read-only access
 using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com>
In-Reply-To: <53465A53.1090500@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

op 10-04-14 10:46, Thomas Hellstrom schreef:
> Hi!
>
> Ugh. This became more complicated than I thought, but I'm OK with moving
> TTM over to fence while we sort out
> how / if we're going to use this.
>
> While reviewing, it struck me that this is kind of error-prone, and hard
> to follow since we're operating on a structure that may be
> continually updated under us, needing a lot of RCU-specific macros and
> barriers.
Yeah, but with the exception of dma_buf_poll I don't think there is anything else
outside drivers/base/reservation.c has to deal with rcu.

> Also the rcu wait appears to not complete until there are no busy fences
> left (new ones can be added while we wait) rather than
> waiting on a snapshot of busy fences.
This has been by design, because 'wait for bo idle' type of functions only care
if the bo is completely idle or not.

It would be easy to make a snapshot even without seqlocks, just copy
reservation_object_test_signaled_rcu to return a shared list if test_all is set, or return pointer to exclusive otherwise.

> I wonder if these issues can be addressed by having a function that
> provides a snapshot of all busy fences: This can be accomplished
> either by including the exclusive fence in the fence_list structure and
> allocate a new such structure each time it is updated. The RCU reader
> could then just make a copy of the current fence_list structure pointed
> to by &obj->fence, but I'm not sure we want to reallocate *each* time we
> update the fence pointer.
No, the most common operation is updating fence pointers, which is why
the current design makes that cheap. It's also why doing rcu reads is more expensive.
> The other approach uses a seqlock to obtain a consistent snapshot, and
> I've attached an incomplete outline, and I'm not 100% whether it's OK to
> combine RCU and seqlocks in this way...
>
> Both these approaches have the benefit of hiding the RCU snapshotting in
> a single function, that can then be used by any waiting
> or polling function.
>

I think the middle way with using seqlocks to protect the fence_excl pointer and shared list combination,
and using RCU to protect the refcounts for fences and the availability of the list could work for our usecase
and might remove a bunch of memory barriers. But yeah that depends on layering rcu and seqlocks.
No idea if that is allowed. But I suppose it is.

Also, you're being overly paranoid with seqlock reading, we would only need something like this:

rcu_read_lock()
     preempt_disable()
     seq = read_seqcount_begin();
     read fence_excl, shared_count = ACCESS_ONCE(fence->shared_count)
     copy shared to a struct.
     if (read_seqcount_retry()) { unlock and retry }
   preempt_enable();
   use fence_get_rcu() to bump refcount on everything, if that fails unlock, put, and retry
rcu_read_unlock()

But the shared list would still need to be RCU'd, to make sure we're not reading freed garbage.

~Maarten

