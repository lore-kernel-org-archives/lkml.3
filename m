Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaHCEqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 00:46:19 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:61379 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaHCEqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 00:46:18 -0400
Message-ID: <53DDBE9C.3030609@gmail.com>
Date: Sun, 03 Aug 2014 00:46:20 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: anssi.hannula@iki.fi
CC: ejt@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
References: <53DD97B0.8040001@gmail.com> <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
In-Reply-To: <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 10:10 PM, Pranith Kumar wrote:
> Corrently adding Anssi this time.
> 
> On Sat, Aug 2, 2014 at 10:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>> Hello Anssi, Joe, Mike,
>>
>> I just found your patch in the latest rc and wanted to ask a few
>> questions. I am not sure how this patch helps at all other than luck in
>> that dm_cblock_t type is of type int32_t, which should guarantee that it
>> is atomic on most platforms. Which begs the question, what platform did
>> you encounter this problem?
>>
>> The patch purports to solve a race condition by making use of atomic_t.
>> I am not sure that is enough. If indeed there is a race you need to use
>> smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
>> atomic_set().
>>
>> Also I have a concern about why this mail was not CC'ed on LKML. I had
>> to go to some difficulty in finding this patch. So please CC LKML for
>> such patches.
>>
>> Thanks,
>> --
>> Pranith
>>
>> -- Begin forwarded Message --
>>
>>
>> nr_dirty is updated without locking, causing it to drift so that it is
>> non-zero (either a small positive integer, or a very large one when an
>> underflow occurs) even when there are no actual dirty blocks.
>>
>> Fix that by using an atomic type for nr_dirty.
>>
>> Signed-off-by: Anssi Hannula <anssi hannula iki fi>
>> Cc: Joe Thornber <ejt redhat com>
>> Cc: stable vger kernel org

Well, someone got their pointers mixed up. The following should help, but this is not enough if there are indeed concurrent accesses. Are you sure there are concurrent accesses?

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 2c63326..d49ce45 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1765,11 +1765,11 @@ static void destroy(struct cache *cache)
        if (cache->wq)
                destroy_workqueue(cache->wq);
 
-       if (cache->dirty_bitset)
-               free_bitset(cache->dirty_bitset);
+       if (cache.dirty_bitset)
+               free_bitset(cache.dirty_bitset);
 
-       if (cache->discard_bitset)
-               free_bitset(cache->discard_bitset);
+       if (cache.discard_bitset)
+               free_bitset(cache.discard_bitset);
 
        if (cache->copier)
                dm_kcopyd_client_destroy(cache->copier);
@@ -2269,15 +2269,15 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
        r = -ENOMEM;
        atomic_set(&cache->nr_dirty, 0);
-       cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
-       if (!cache->dirty_bitset) {
+       cache.dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
+       if (!cache.dirty_bitset) {
                *error = "could not allocate dirty bitset";
                goto bad;
        }
        clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));
 
        cache->discard_nr_blocks = cache->origin_blocks;
-       cache->discard_bitset = alloc_bitset(from_oblock(cache->discard_nr_blocks));
+       cache.discard_bitset = alloc_bitset(from_oblock(cache->discard_nr_blocks));
        if (!cache->discard_bitset) {
                *error = "could not allocate discard bitset";
                goto bad;

