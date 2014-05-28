Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaE1Aky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:40:54 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43115 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaE1Akx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140527224002.GB25781@cerebellum.variantweb.net>
References: <1399499496-3216-1-git-send-email-ddstreet@ieee.org>
 <1400958369-3588-1-git-send-email-ddstreet@ieee.org> <1400958369-3588-7-git-send-email-ddstreet@ieee.org>
 <20140527224002.GB25781@cerebellum.variantweb.net>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 27 May 2014 20:40:29 -0400
X-Google-Sender-Auth: __A5OzIqO_HtIalAtfrLCWx07w0
Message-ID: <CALZtONDhkoxXa2o1eDN_7siJ53MEPhNwp5RLg8SOH4pph+t2Og@mail.gmail.com>
Subject: Re: [PATCH 6/6] mm/zpool: prevent zbud/zsmalloc from unloading when used
To: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>, Weijie Yang <weijie.yang@samsung.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 6:40 PM, Seth Jennings <sjennings@variantweb.net> wrote:
> On Sat, May 24, 2014 at 03:06:09PM -0400, Dan Streetman wrote:
>> Add try_module_get() to pool creation functions for zbud and zsmalloc,
>> and module_put() to pool destruction functions, since they now can be
>> modules used via zpool.  Without usage counting, they could be unloaded
>> while pool(s) were active, resulting in an oops.
>
> I like the idea here, but what about doing this in the zpool layer? For
> me, it is kinda weird for a module to be taking a ref on itself.  Maybe
> this is excepted practice.  Is there precedent for this?

It's done in some places already:
git grep try_module_get\(THIS_MODULE | wc -l
83

but it definitely could be done in zpool, and since other users of
zbud/zsmalloc would be calling directly to their functions, instead of
indirectly by driver registration, I believe the module dependency
there would prevent zbud/zsmalloc unloading while a using module was
still loaded (if I understand module usage counting correctly).

>
> What about having the zbud/zsmalloc drivers pass their module pointers
> to zpool_register_driver() as an additional field in struct zpool_driver
> and have zpool take the reference?  Since zpool is the one in trouble if
> the driver is unloaded.

Yep this seems to be the other common way of doing it, with a ->owner
field in the registered struct.  Either way is fine with me, and zpool
definitely is the one in trouble if its driver is unloaded.  I'll
update for v4 of this patch set.

>
> Seth
>
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>> Cc: Seth Jennings <sjennings@variantweb.net>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Nitin Gupta <ngupta@vflare.org>
>> Cc: Weijie Yang <weijie.yang@samsung.com>
>> ---
>>
>> New for this patch set.
>>
>>  mm/zbud.c     | 5 +++++
>>  mm/zsmalloc.c | 5 +++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/mm/zbud.c b/mm/zbud.c
>> index 8a72cb1..2b3689c 100644
>> --- a/mm/zbud.c
>> +++ b/mm/zbud.c
>> @@ -282,6 +282,10 @@ struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
>>       pool = kmalloc(sizeof(struct zbud_pool), GFP_KERNEL);
>>       if (!pool)
>>               return NULL;
>> +     if (!try_module_get(THIS_MODULE)) {
>> +             kfree(pool);
>> +             return NULL;
>> +     }
>>       spin_lock_init(&pool->lock);
>>       for_each_unbuddied_list(i, 0)
>>               INIT_LIST_HEAD(&pool->unbuddied[i]);
>> @@ -302,6 +306,7 @@ struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
>>  void zbud_destroy_pool(struct zbud_pool *pool)
>>  {
>>       kfree(pool);
>> +     module_put(THIS_MODULE);
>>  }
>>
>>  /**
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 07c3130..2cc2647 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -946,6 +946,10 @@ struct zs_pool *zs_create_pool(gfp_t flags)
>>       pool = kzalloc(ovhd_size, GFP_KERNEL);
>>       if (!pool)
>>               return NULL;
>> +     if (!try_module_get(THIS_MODULE)) {
>> +             kfree(pool);
>> +             return NULL;
>> +     }
>>
>>       for (i = 0; i < ZS_SIZE_CLASSES; i++) {
>>               int size;
>> @@ -985,6 +989,7 @@ void zs_destroy_pool(struct zs_pool *pool)
>>               }
>>       }
>>       kfree(pool);
>> +     module_put(THIS_MODULE);
>>  }
>>  EXPORT_SYMBOL_GPL(zs_destroy_pool);
>>
>> --
>> 1.8.3.1
>>
