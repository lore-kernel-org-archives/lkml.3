Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbaEQNu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:50:26 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58674 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaEQNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:50:25 -0400
Message-ID: <53776918.7040402@acm.org>
Date: Sat, 17 May 2014 15:50:16 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2] kref: warn on uninitialized kref
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com> <20140517110454.GA1939@mguzik.redhat.com> <alpine.LRH.2.02.1405170836070.15837@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405170836070.15837@file01.intranet.prod.int.rdu2.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/14 14:38, Mikulas Patocka wrote:
> I found a memory leak in iSCSI target that was caused by kref initialized
> to zero (the memory object was allocated with kzalloc, kref_init was not
> called and kref_put_spinlock_irqsave was called which changed "0" to "-1"
> and didn't free the object).
> 
> Similar bugs may exist in other kernel areas, so I submit this patch that
> adds a check to kref.h. If the value is zero or negative, we can assume
> that it is uninitialized and we warn about it.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  include/linux/kref.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-3.15-rc5/include/linux/kref.h
> ===================================================================
> --- linux-3.15-rc5.orig/include/linux/kref.h	2014-05-16 19:00:18.000000000 +0200
> +++ linux-3.15-rc5/include/linux/kref.h	2014-05-17 13:19:31.000000000 +0200
> @@ -69,7 +69,7 @@ static inline int kref_sub(struct kref *
>  	     void (*release)(struct kref *kref))
>  {
>  	WARN_ON(release == NULL);
> -
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) < (int)count);
>  	if (atomic_sub_and_test((int) count, &kref->refcount)) {
>  		release(kref);
>  		return 1;
> @@ -119,6 +119,7 @@ static inline int kref_put_spinlock_irqs
>  	unsigned long flags;
>  
>  	WARN_ON(release == NULL);
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
>  	if (atomic_add_unless(&kref->refcount, -1, 1))
>  		return 0;
>  	spin_lock_irqsave(lock, flags);
> @@ -136,6 +137,7 @@ static inline int kref_put_mutex(struct 
>  				 struct mutex *lock)
>  {
>  	WARN_ON(release == NULL);
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
>  	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
>  		mutex_lock(lock);
>  		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {

This patch adds two conditional branches and one atomic read to
kref_sub(). What is the performance impact of this patch on kernel code
that uses kref_put() in the hot path ? Has it been considered to enable
the newly added code only if a CONFIG_DEBUG_* macro has been set ?

Bart.

