Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaBEIMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:12:19 -0500
Received: from relay.parallels.com ([195.214.232.42]:37893 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaBEIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:12:18 -0500
Message-ID: <52F1F25F.20402@parallels.com>
Date: Wed, 5 Feb 2014 12:12:15 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] slub: fix false-positive lockdep warning in free_partial()
References: <52F1DB81.30805@parallels.com> <1391582641-12904-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.02.1402050000180.7839@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402050000180.7839@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 12:01 PM, David Rientjes wrote:
> On Wed, 5 Feb 2014, Vladimir Davydov wrote:
>
>> Commit c65c1877bd68 ("slub: use lockdep_assert_held") requires
>> remove_partial() to be called with n->list_lock held, but free_partial()
>> called from kmem_cache_close() on cache destruction does not follow this
>> rule, leading to a warning:
>>
>>   WARNING: CPU: 0 PID: 2787 at mm/slub.c:1536 __kmem_cache_shutdown+0x1b2/0x1f0()
>>   Modules linked in:
>>   CPU: 0 PID: 2787 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #1
>>   Hardware name:
>>    0000000000000600 ffff88003ae1dde8 ffffffff816d9583 0000000000000600
>>    0000000000000000 ffff88003ae1de28 ffffffff8107c107 0000000000000000
>>    ffff880037ab2b00 ffff88007c240d30 ffffea0001ee5280 ffffea0001ee52a0
>>   Call Trace:
>>    [<ffffffff816d9583>] dump_stack+0x51/0x6e
>>    [<ffffffff8107c107>] warn_slowpath_common+0x87/0xb0
>>    [<ffffffff8107c145>] warn_slowpath_null+0x15/0x20
>>    [<ffffffff811c7fe2>] __kmem_cache_shutdown+0x1b2/0x1f0
>>    [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
>>    [<ffffffffa013a123>] xfs_destroy_zones+0x103/0x110 [xfs]
>>    [<ffffffffa0192b54>] exit_xfs_fs+0x38/0x4e4 [xfs]
>>    [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
>>    [<ffffffff816dfcd8>] ? retint_swapgs+0x13/0x1b
>>    [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
>>    [<ffffffff81359efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>    [<ffffffff816e8539>] system_call_fastpath+0x16/0x1b
>>
>> Although this cannot actually result in a race, because on cache
>> destruction there should not be any concurrent frees or allocations from
>> the cache, let's add spin_lock/unlock to free_partial() just to keep
>> lockdep happy.
>>
>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>> ---
>>  v2: add a comment explaining why we need to take the lock
>>
>>  mm/slub.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0eeea85034c8..24bf05e962ff 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3191,6 +3191,11 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
>>  {
>>  	struct page *page, *h;
>>  
>> +	/*
>> +	 * the lock is for lockdep's sake, not for any actual
>> +	 * race protection
>> +	 */
> I think Christoph was referring to altering the comment for this function 
> which still says "We must be the last thread using the cache and therefore 
> we do not need to lock anymore."

Oh, sorry, I didn't notice that. Will amend.

Thanks.

>
>> +	spin_lock_irq(&n->list_lock);
>>  	list_for_each_entry_safe(page, h, &n->partial, lru) {
>>  		if (!page->inuse) {
>>  			remove_partial(n, page);
>> @@ -3200,6 +3205,7 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
>>  			"Objects remaining in %s on kmem_cache_close()");
>>  		}
>>  	}
>> +	spin_unlock_irq(&n->list_lock);
>>  }
>>  
>>  /*

