Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3JHNRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:17:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61696 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:17:42 -0400
Message-ID: <525405F0.8050407@gmail.com>
Date: Tue, 08 Oct 2013 22:17:36 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: mpatocka@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org, tj@kernel.org,
        agk@redhat.com, joe@perches.com, akpm@linux-foundation.org,
        ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com,
        ruby.wktk@gmail.com
Subject: Re: [dm-devel] A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52515BD6.5000701@gmail.com> <alpine.LRH.2.02.1310071327390.19115@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310071327390.19115@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

Let me ask you about this comment
of choosing the best API.
For the rest, I will reply later.

> BTW. You should use wait_event_interruptible_lock_irq instead of 
> wait_event_interruptible and wait_event_interruptible_lock_irq_timeout 
> instead of wait_event_interruptible_timeout. The functions with "lock_irq" 
> automatically drop and re-acquire the spinlock, so that the condition is 
> tested while the lock is held - so that there are no asynchronous accesses 
> to !list_empty(&cache->flush_queue).

wait_event_interruptible_lock_irq_timeout is
added to the kernel since 3.12 by this patch.
https://lkml.org/lkml/2013/8/21/362
However, it is only used by zfcp itself.

I am afraid I want to refrain from this new API
and keep the code as it is now.
Later if this API is widely accepted
it is time to use it in writeboost
is my opinion.
The fact this API is not added for a long time
makes me feel it should not be used at least at this moment of time.
I want to use only those truly stable.
writeboost as a storage kernel module should be stable.
I believe depending only on the stable APIs is a
good way of making a software stable.

All said, I tried to fix this.
Is this change what you meant?

@@ -24,10 +24,10 @@ int flush_proc(void *data)

                spin_lock_irqsave(&cache->flush_queue_lock, flags);
                while (list_empty(&cache->flush_queue)) {
-                       spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
-                       wait_event_interruptible_timeout(
+                       wait_event_interruptible_lock_irq_timeout(
                                cache->flush_wait_queue,
-                               (!list_empty(&cache->flush_queue)),
+                               !list_empty(&cache->flush_queue),
+                               cache->flush_queue_lock,
                                msecs_to_jiffies(100));

                        /*
@@ -36,8 +36,6 @@ int flush_proc(void *data)
                         */
                        if (kthread_should_stop())
                                return 0;
-                       else
-                               spin_lock_irqsave(&cache->flush_queue_lock, flags);
                }

Akira
