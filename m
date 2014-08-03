Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaHCDja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 23:39:30 -0400
Received: from webmail.tpnet.fi ([62.106.63.33]:46024 "EHLO webmail.tpnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaHCDj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 23:39:29 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2014 23:39:28 EDT
Message-ID: <53DDAD9F.6010306@iki.fi>
Date: Sun, 03 Aug 2014 06:33:51 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
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

03.08.2014, 05:10, Pranith Kumar kirjoitti:
> Corrently adding Anssi this time.
> 
> On Sat, Aug 2, 2014 at 10:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>> Hello Anssi, Joe, Mike,

Hi,

>> I just found your patch in the latest rc and wanted to ask a few
>> questions. I am not sure how this patch helps at all other than luck in
>> that dm_cblock_t type is of type int32_t, which should guarantee that it
>> is atomic on most platforms. Which begs the question, what platform did
>> you encounter this problem?

On x86_64. Regular integer increment/decrement/addition/subtraction are
not atomic on x86(_64).

Assembly for increment without patch is
	addl   $0x1,0x108(%rdi)
and for decrement
	subl   $0x1,0x108(%rbx)

while with patch:
	lock incl 0x108(%rdi)
and
	mov    $0xffffffff,%eax
	lock xadd %eax,0x108(%rbx)
.


>> The patch purports to solve a race condition by making use of atomic_t.
>> I am not sure that is enough. If indeed there is a race you need to use
>> smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
>> atomic_set().

The issue was only about concurrent increments/decrements getting lost
completely from time to time, which atomic_inc/dec will prevent without
any explicit barriers.

>> Also I have a concern about why this mail was not CC'ed on LKML. I had
>> to go to some difficulty in finding this patch. So please CC LKML for
>> such patches.

I don't usually CC LKML if there is a subsystem-specific mailing list
unless there is a specific reason to CC LKML as well. I thought this was
standard practice, but I'm happy to spam LKML as well from now on if
that is preferred by others as well.


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
>>
>> ---
>>
>> So here's a patch for the issue I reported a few days ago.
>>
>> I'm not sure what the actual effects of having wrong nr_dirty are
>> beyond the wrong value reported to userspace. Having wrong nr_dirty
>> causes dm_table_event(cache->ti->table) to be called at incorrect times,
>> but I'm not sure what the implications of that are.
>>
>> So someone more knowledged should really amend my commit message
>> accordingly so that it explains the user-visible issues :)
>>
>> I did notice that after a reboot (after having incorrect nr_dirty) the
>> entire cache was considered to be dirty and a full writeback occurred,
>> but I don't know if that was related at all.
>>
>>
>>  drivers/md/dm-cache-target.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
>> index 0df3ec085ebb..83a7eb5ef113 100644
>> --- a/drivers/md/dm-cache-target.c
>> +++ b/drivers/md/dm-cache-target.c
>> @@ -154,7 +154,7 @@ struct cache {
>>         /*
>>          * cache_size entries, dirty if set
>>          */
>> -       dm_cblock_t nr_dirty;
>> +       atomic_t nr_dirty;
>>         unsigned long *dirty_bitset;
>>
>>         /*
>> @@ -403,7 +403,7 @@ static bool is_dirty(struct cache *cache, dm_cblock_t b)
>>  static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
>>  {
>>         if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
>> -               cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
>> +               atomic_inc(&cache->nr_dirty);
>>                 policy_set_dirty(cache->policy, oblock);
>>         }
>>  }
>> @@ -412,8 +412,7 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
>>  {
>>         if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
>>                 policy_clear_dirty(cache->policy, oblock);
>> -               cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
>> -               if (!from_cblock(cache->nr_dirty))
>> +               if (atomic_dec_return(&cache->nr_dirty) == 0)
>>                         dm_table_event(cache->ti->table);
>>         }
>>  }
>> @@ -2003,7 +2002,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>>         init_waitqueue_head(&cache->migration_wait);
>>
>>         r = -ENOMEM;
>> -       cache->nr_dirty = 0;
>> +       atomic_set(&cache->nr_dirty, 0);
>>         cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
>>         if (!cache->dirty_bitset) {
>>                 *error = "could not allocate dirty bitset";
>> @@ -2513,7 +2512,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
>>                        (unsigned) atomic_read(&cache->stats.demotion),
>>                        (unsigned) atomic_read(&cache->stats.promotion),
>>                        (unsigned long long) from_cblock(residency),
>> -                      cache->nr_dirty);
>> +                      (unsigned) atomic_read(&cache->nr_dirty));
>>
>>                 if (cache->features.write_through)
>>                         DMEMIT("1 writethrough ");
>> --
>> 1.8.4.5
>>
>> -- End forwarded Message --
>>
> 
> 
> 


-- 
Anssi Hannula
