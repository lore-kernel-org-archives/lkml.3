Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3LQX7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:59:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50690 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3LQX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:59:42 -0500
MIME-Version: 1.0
In-Reply-To: <CANP1eJHLP=-OVT3GVe5ZBZFB15PXZs8U4ztJgwihhoR9XB-8-A@mail.gmail.com>
References: <20131111221804.23212.30560.stgit@warthog.procyon.org.uk>
	<CANP1eJHLP=-OVT3GVe5ZBZFB15PXZs8U4ztJgwihhoR9XB-8-A@mail.gmail.com>
Date: Tue, 17 Dec 2013 18:59:40 -0500
Message-ID: <CANP1eJFt_A30hYxA+8scEuPrnw_B=pOBojrkGicPH0gvB90SMQ@mail.gmail.com>
Subject: Re: [PATCH] FS-Cache: Fix handling of an attempt to store a page that
 is now beyond EOF
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hate to be that guy and keep bugging you guys. Can I get an
acknowledgment of the original patch? It fixed a very real issue for
fscache users that occurs semi-frequently under moderate concurrency.

- M

On Mon, Dec 16, 2013 at 12:20 PM, Milosz Tanski <milosz@adfin.com> wrote:
> Hey guys it looks like this patch got lost in the shuffle. I checked
> out a recent kernel and learned this wasn't applied the hard way (by
> running into it).
>
> Can this please get applied to master as it fixes a real issue?
>
> Thanks,
> - Milosz
>
> On Mon, Nov 11, 2013 at 5:18 PM, David Howells <dhowells@redhat.com> wrote:
>> Fix the handling of an attempt to store a page that is now beyond EOF.  This
>> may happen, for example, if the page got pushed for storage before the netfs
>> file got truncated on the server.  In such a case, we should just remove the
>> excessive pages from the cookie->stores radix tree and wake up the waiter.
>>
>> This can be seen in /proc/fs/fscache/stats on this line:
>>
>>         Stores : ops=350 run=1895 pgs=1545 rxd=1727 olm=9
>>
>> where olm=N has N > 0.
>>
>> Reported-by: Milosz Tanski <milosz@adfin.com>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> Acked-by: Milosz Tanski <milosz@adfin.com>
>> ---
>>
>>  fs/fscache/page.c |   37 ++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
>> index 7f5c658af755..b4730cf52aec 100644
>> --- a/fs/fscache/page.c
>> +++ b/fs/fscache/page.c
>> @@ -755,6 +755,7 @@ static void fscache_write_op(struct fscache_operation *_op)
>>         struct fscache_object *object = op->op.object;
>>         struct fscache_cookie *cookie;
>>         struct page *page;
>> +       pgoff_t index;
>>         unsigned n;
>>         void *results[1];
>>         int ret;
>> @@ -803,7 +804,7 @@ static void fscache_write_op(struct fscache_operation *_op)
>>         _debug("gang %d [%lx]", n, page->index);
>>         if (page->index > op->store_limit) {
>>                 fscache_stat(&fscache_n_store_pages_over_limit);
>> -               goto superseded;
>> +               goto page_beyond_limit;
>>         }
>>
>>         radix_tree_tag_set(&cookie->stores, page->index,
>> @@ -829,6 +830,40 @@ static void fscache_write_op(struct fscache_operation *_op)
>>         _leave("");
>>         return;
>>
>> +page_beyond_limit:
>> +       spin_unlock(&object->lock);
>> +
>> +page_beyond_limit_unlocked:
>> +       /* pages that are now beyond the end of the storage object must have
>> +        * their pending storage records cleared.
>> +        */
>> +       index = page->index;
>> +       radix_tree_tag_clear(&cookie->stores, page->index,
>> +                            FSCACHE_COOKIE_PENDING_TAG);
>> +       if (!radix_tree_tag_get(&cookie->stores, page->index,
>> +                               FSCACHE_COOKIE_STORING_TAG)) {
>> +               fscache_stat(&fscache_n_store_radix_deletes);
>> +               radix_tree_delete(&cookie->stores, page->index);
>> +               page_cache_release(page);
>> +       }
>> +       if (!need_resched()) {
>> +               n = radix_tree_gang_lookup_tag(&cookie->stores, results,
>> +                                              index + 1, 1,
>> +                                              FSCACHE_COOKIE_PENDING_TAG);
>> +               if (n == 1) {
>> +                       page = results[0];
>> +                       goto page_beyond_limit_unlocked;
>> +               }
>> +               spin_unlock(&cookie->stores_lock);
>> +               wake_up_bit(&cookie->flags, 0);
>> +       } else {
>> +               spin_unlock(&cookie->stores_lock);
>> +       }
>> +
>> +       fscache_enqueue_operation(&op->op);
>> +       _leave("");
>> +       return;
>> +
>>  superseded:
>>         /* this writer is going away and there aren't any more things to
>>          * write */
>>
>
>
>
> --
> Milosz Tanski
> CTO
> 10 East 53rd Street, 37th floor
> New York, NY 10022
>
> p: 646-253-9055
> e: milosz@adfin.com



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com
