Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3JIHj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:39:59 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45001 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3JIHj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:39:56 -0400
Message-ID: <52550841.5030001@gmail.com>
Date: Wed, 09 Oct 2013 16:39:45 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org,
        ruby.wktk@gmail.com
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

> Next, you need to design some locking - which variables are protected by 
> which locks. If you use shared variables without locks, you need to use 
> memory barriers (it is harder to design code using memory barriers than 
> locks).

First I will explain the locking and the shared variables.
writeboost doesn't have many variables shared among asynchronous threads.

1. We have HashTable for cache lookup and RAM buffer for write data transiently.
   These data structures are locked by a mutex io_lock.
   barrier_ios is a queue to push bio flagged with REQ_FUA or REQ_FLUSH.
   This queue is also locked by io_lock.
   These bios are chained to flush job inside io_lock.
   queue_flushing is a routine that makes a flush job and queues it in
   flush_queue which is protected by a spinlock flush_queue_lock.
   This foreground (.map) is a producer of flush jobs to flush daemon.
2. flush daemon loops flush_proc in single thread.
   It pops and consumes one flush job from flush_queue (writing to the cache device).
   Therefore, foreground should keep that the flush job is
   completely initialized before queues it.
   After completing the writing, it sets(actually increments) the last_flush_segment_id.
   This daemon is the only to update this shared variable.
3. migrate daemon loops migrate_proc also running in the single thread.
   It first calculates how many (nr_mig) segments from 
   last_migrated_segment_id + 1 to + nr_mig by referring
   last_flushed_segment_id and last_migrate_segment_id.
   The former is the head of the dirty log and the latter
   is the tail. Note that the head doesn't have to be synchronized
   since the last_flush_segment_id linearly increases.
   last_flush_segment_id not synced only results in less number of migration than actual.
   It doesn't collapse anything at all.
   After migrate all the nr_mig dirty segments, it increments
   last_migrated_segment_id by nr_mig.
   This daemon is the only to update this last_migrate_segment_id.
   
Other daemons don't share such variables.

> Think of this piece of code:
> nr_mig_candidates = cache->last_flushed_segment_id -
>                     cache->last_migrated_segment_id;
> ...
> nr_mig = min(nr_mig_candidates,
>              cache->nr_cur_batched_migration);
> ...
> for (i = 1; i <= nr_mig; i++) {
> 	        seg = get_segment_header_by_id(
>                         cache,
>                         cache->last_migrated_segment_id + i);
>         list_add_tail(&seg->migrate_list, &cache->migrate_list);
> }
> 
> The processor may reorder all memory accesses - for example it may read 
> the data accessed in the "for" cycle before reading the variables 
> "cache->last_flushed_segment_id" and "cache->last_migrated_segment_id". If 
> this happens, the code may work with invalid data.

True?
My understanding is that reordering does not happen
for these three blocks of code because there are sequential data dependencies.
That the last block is while loop is the point?

But, I sorted our other two points we need to insert memory barriers.

First is in queue_flushing.
We can't deny that incomplete flush job is queued and
flush_proc goes bad.
I am thinking of inserting smp_wmb before queuing and
smp_rmb after popping a job in flush_proc.

Second is in migrate_proc.
We can't deny that migrate_proc goes into migrate_linked_segments
before cache->migrate_list is properly initialized.
I am thinking of inserting smp_wmb before migrate_linked_segments.

I don't understand memory barrier well.
So, please fix if I am going the wrong way.

> Nonatomic 64-bit variables
> --------------------------
> 
> Note that 64-bit variables are not atomic on 32-bit architectures.
> 
> Linux assumes that 32-bit variables are atomic on 32-bit architectures and 
> 64-bit or 32-bit variables are atomic on 64-bit architectures. That is, 
> variables having the "long" or "int" type are atomic. Atomicity means that 
> if you read and modify the variable at the same time, you read either the 
> old value or the new values.
> 
> 64-bit variables on 32-bit architectures are usually read and written in 
> two steps, and thus the atomicity requirement isn't true.
> 
> For example, suppose that you change cache->last_flushed_segment_id from 
> 0x00000000ffffffff to 0x0000000100000000. Now, the function migrate_proc 
> that asynchronously reads cache->last_flushed_segment_id can read 
> 0x00000000ffffffff or 0x0000000100000000 (if it reads one of these values, 
> it behaves correctly), but it can also read 0x0000000000000000 or 
> 0x00000001ffffffff - if migrate_proc reads one of these two values, it 
> goes wild, migrating segments that weren't ever supposed to be migrated, 
> and likely causes a crash or data corruption.
> 
> I found this bug in migrate_proc and update_superblock_record (but it may 
> be also in other parts of the code).
> 
> You can use atomic64_t type for atomic 64-bit variables (plus memory 
> barriers as explained in the previous section). Or you can use locks.
> 
> reserving_segment_id is also affected. However, you never actually need 
> the value of reserving_segment_id, you only compare it to zero. Thus, you 
> can change this variable to the "int" type and set it to "0" or "1". (you 
> must use int and not bool, see the next section).
Yes.
reserving_segment_id will be renamed to `urge_migrate` (::int)
that will fit more.

> Variables smaller than 32 bits must not be asynchronously modified
> ------------------------------------------------------------------
> 
> Early Alpha processors can't access memory objects smaller than 32 bits - 
> so, for example, if your code writes 8-bit char or bool variable, the 
> processor reads 32 bits to a register, modifies 8-bit part of the register 
> and writes 32 bits from the register back to memory. Now, if you define
> something like
> unsigned char a;
> unsigned char b;
> and modify "a" from one "thread 1" and modify "b" from "thread 2", the 
> threads could destroy each other's modification - the "thread 1" can 
> destroy "b" (although in the C code it never references "b") and "thread 
> 2" can destroy "a" (although in the C code it never references "a") - for 
> this reason - if you have variables that you modify asynchronously, they 
> shouldn't have a type smaller than 32 bits.
> 
> bool allow_migrate, bool enable_migration_modulator, bool on_terminate 
> have this problem, change them to int.
Yes. May I use true/false to update these values or 1/0 instead?

> 64-bit divide and modulo
> ------------------------
> 
> You can't use divide and modulo operators ('/' and '%') on 64-bit values. 
> On 32-bit architectures, these operators need library functions and these 
> functions are not present in the kernel. You need to use div64_u64 
> (divides 64-bit value by 64-bit value), div64_u64_rem (divides 64-bit 
> value by 64-bit value and also returns a remainder), You can also use 
> do_div (it divides a 64-bit value by a 32-bit value), or sector_div (it 
> divides sector_t by a 32-bit value).
> 
> Try to compile your driver with 32-bit kernel and you will see that '/' 
> and '%' doesn't work on 64-bit values.
Yes.

> Wrong printf arguments
> ----------------------
> 
> Try to compile your driver on 32-bit system. You get some warnings.
> 
> size_t x;
> printf("%lu", x) - this is wrong because %lu says that the type is 
> unsigned long and the type is size_t (size_t may be unsigned or unsigned 
> long on different architectures). It should be
> printf("%zu", z);
> 
> sector_t s;
> printf("%lu", s) - this is wrong because the sector_t may not have the 
> same type as unsigned long. (on 32-bit architectures, you can select 
> 32-bit sector_t or 64-bit sector_t in kernel configuration). It should be
> printf("%llu", (unsigned long long)s);
> 
> DMEMIT("%lu ", atomic64_read(v)); - wrong, because format is unsigned long 
> and type is 64-bit. It should be
> DMEMIT("%llu ", (unsigned long long)atomic64_read(v));
Yes.

> GFP_NOIO allocations
> --------------------
> 
> If possible, you should use mempool instead. Mempool allocation doesn't 
> fail (if memory is exhausted, it waits until some objects are returned to 
> the mempool).
> 
> kmalloc_retry is not needed - there's a flag __GFP_NOFAIL that does 
> infinite retry.
> 
> The problem with GFP_IO is that if the system is in such a state when all 
> memory is dirty and the only way how to free memory is to write pages to 
> the swap, it deadlocks - the memory manager waits for your driver to write 
> some data to the swap - and your driver is waiting for the memory manager 
> to free some memory so that you can allocate memory and process the write.
> 
> To avoid this problem, use mempools.
No, I use GFP_NOIO not GFP_IO.

Yes, I understand that we don't need kmalloc_retry. I didn't know about __GFP_NOFAIL.
I will rewrite all kmalloc_retry.

> Lack of ACCESS_ONCE
> -------------------
> 
> You can read a variable while you modify it (the variable must not be 
> bigger than "long" type, see the section "Nonatomic 64-bit variables").
> 
> However, if you read a variable that may be modified, you must use the 
> ACCESS_ONCE macro.
> 
> For example see this:
> if (cache->on_terminate)
>         return;
> cache->on_terminate may change while you are reading it, so you should use
> if (ACCESS_ONCE(cache->on_terminate))
> 	return;
> 
> There are many other variables that are read while modifying them and that 
> need ACCESS_ONCE, for example cache->allow_migrate. There are plenty of 
> other variables in your code that may be read and modified at the same 
> time.
> 
> The reason why you need ACCESS_ONCE is that the C compiler assumes that 
> the variable that you read doesn't change. Thus, it can perform certain 
> optimizations. ACCESS_ONCE suppresses these optimizations.
> 
> In most cases, omitting ACCESS_ONCE doesn't cause any misbehavior, for the 
> reason that the compiler doesn't use the assumption, that the variable 
> doesn't change, to perform optimizations. But the compiler may use this 
> assumption, and if it does, it triggers a hard to find bug.
I understand.
The other variables could be the tunable parameters writeboost provides.

> Infinite retry on I/O error in dm_safe_io_retry
> -----------------------------------------------
> 
> Don't do this. If the cache disk fails for some reason, it kills the 
> system by doing inifinite retry.
> 
> Generally, I/O retry is handler by the lowest level driver (for example, 
> if ATA disk fails to respond, the driver tries to reset the disk and 
> reissue the request). If you get I/O error, you can assume that the lowest 
> level driver retried as much as it could and you shouldn't do additional 
> retry.
> 
> If you can't handle a specific I/O request failure gracefully, you should 
> mark the driver as dead, don't do any more I/Os to the disk or cache 
> device and return -EIO on all incoming requests.
> 
> Always think that I/O failures can happen because of connection problems, 
> not data corruption problems - for example, a disk cable can go loose, a 
> network may lose connectivity, etc. In these cases, it is best to stop 
> doing any I/O at all and let the user resolve the situation.
> 
> I think that you should always stop the driver on write error (stopping it 
> minimizes data damage when there is connectivity problem such as loose 
> cable). On read error you should stop the driver if the error is 
> non-recoverable (for example, when you get error when reading the cache 
> device in the migration process). You don't have to stop on read error, if 
> it is recoverable (for example, when you see read error on the disk, you 
> can just return -EIO to the user without stopping the driver).
Why I introduced infinite retry is that
I experienced a cache device connected by USB-SATA2 adapter
sometimes fails when the I/O are heavy for the cheap firmware.

So, please let me retry only once after waiting for 1 sec.
If the I/O fails again, I will stop the module marking as dead.
Or, should I immediately stop the module?

My design idea is to create a new daemon
that sets the module dead after failure reported from other daemons.
and listens to the client reports he/she fixed the problem and
this daemon starts the module again.

There is a wait queue all daemons except
this daemon are waiting for the status turns green.

The hint for fix is seen in dmesg
that is printed at the point failure happened.
It is like "in flush_proc writing to cache failed (sector xxx-yyy)"
and then the client finds something happened in writing to cache device.

Stopping the module is by rejecting all the
writes at the beginning of .map method.
Yes, if the read may not be dead we can still continues read service but
we should assume the worst case.
we should not even read a device that fails writes
since we don't guess what happens inside the storage.
Maybe, it returns crazy data and damages the applications.

Akira
