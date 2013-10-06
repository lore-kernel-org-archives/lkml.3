Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3JFAu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3JFAuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:50:55 -0400
Date: Sat, 5 Oct 2013 20:50:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org,
        ruby.wktk@gmail.com
Subject: A review of dm-writeboost
Message-ID: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I looked at dm-writeboost source code and here I'm sending the list of 
problems I found:


Polling for state
-----------------

Some of the kernel threads that you spawn poll for data in one-second 
interval - see migrate_proc, modulator_proc, recorder_proc, sync_proc.

flush_proc correctly contains wait_event, but there is still some 100ms 
polling timeout in flush_proc that shouldn't be there.


Don't do this. You can do polling in a piece of code that is executed 
infrequently, such as driver unload, but general functionality must not 
depend on polling.


If you set the polling interval too low, it wastes CPU cycle and it wastes 
energy due to CPU wake-ups. If you set the polling interval too high, it 
causes artifical delays. For example, current middle-class SSDs can do 
writes at a rate 500MB/s. Now, think that the user uses 400MB partition 
for the cache - the partition is filled up in 0.8s and the kernel waits 
for additional 0.2s doing absolutely nothing, until your polling code 
wakes up and notices that it should start flusing the cache.

So - the polling code introduces artifical delays that can cause 
performance degradation. You may think about lowering the polling interval 
to lessen the performance impact, but if you lower the polling interval, 
it increases CPU and power consumption when the driver is idle. Either 
way, it is wrong. Just don't use polling.


Lack of locking/barriers
------------------------

migrate_proc lacks any lock or barrier. Note that processors may execute 
instructions out of order, and thus concurrent access without locks or 
barriers is always wrong.

Think of this piece of code:
nr_mig_candidates = cache->last_flushed_segment_id -
                    cache->last_migrated_segment_id;
...
nr_mig = min(nr_mig_candidates,
             cache->nr_cur_batched_migration);
...
for (i = 1; i <= nr_mig; i++) {
	        seg = get_segment_header_by_id(
                        cache,
                        cache->last_migrated_segment_id + i);
        list_add_tail(&seg->migrate_list, &cache->migrate_list);
}

The processor may reorder all memory accesses - for example it may read 
the data accessed in the "for" cycle before reading the variables 
"cache->last_flushed_segment_id" and "cache->last_migrated_segment_id". If 
this happens, the code may work with invalid data.

Similarly, the processor that updates cache->last_flushed_segment_id can 
update it before updating the segment variables itself.

You need to use smp_wmb() before incrementing 
cache->last_flushed_segment_id in the producer process and smp_rmb() after 
reading cache->last_flushed_segment_id in the consumer process. Read 
Documentation/memory-barriers.txt for full explanation.

You can use locks instead of memory barriers, locks are simpler to use and 
simpler to verify, but they are usually slower than memory barriers.


Nonatomic 64-bit variables
--------------------------

Note that 64-bit variables are not atomic on 32-bit architectures.

Linux assumes that 32-bit variables are atomic on 32-bit architectures and 
64-bit or 32-bit variables are atomic on 64-bit architectures. That is, 
variables having the "long" or "int" type are atomic. Atomicity means that 
if you read and modify the variable at the same time, you read either the 
old value or the new values.

64-bit variables on 32-bit architectures are usually read and written in 
two steps, and thus the atomicity requirement isn't true.

For example, suppose that you change cache->last_flushed_segment_id from 
0x00000000ffffffff to 0x0000000100000000. Now, the function migrate_proc 
that asynchronously reads cache->last_flushed_segment_id can read 
0x00000000ffffffff or 0x0000000100000000 (if it reads one of these values, 
it behaves correctly), but it can also read 0x0000000000000000 or 
0x00000001ffffffff - if migrate_proc reads one of these two values, it 
goes wild, migrating segments that weren't ever supposed to be migrated, 
and likely causes a crash or data corruption.

I found this bug in migrate_proc and update_superblock_record (but it may 
be also in other parts of the code).

You can use atomic64_t type for atomic 64-bit variables (plus memory 
barriers as explained in the previous section). Or you can use locks.

reserving_segment_id is also affected. However, you never actually need 
the value of reserving_segment_id, you only compare it to zero. Thus, you 
can change this variable to the "int" type and set it to "0" or "1". (you 
must use int and not bool, see the next section).


Variables smaller than 32 bits must not be asynchronously modified
------------------------------------------------------------------

Early Alpha processors can't access memory objects smaller than 32 bits - 
so, for example, if your code writes 8-bit char or bool variable, the 
processor reads 32 bits to a register, modifies 8-bit part of the register 
and writes 32 bits from the register back to memory. Now, if you define
something like
unsigned char a;
unsigned char b;
and modify "a" from one "thread 1" and modify "b" from "thread 2", the 
threads could destroy each other's modification - the "thread 1" can 
destroy "b" (although in the C code it never references "b") and "thread 
2" can destroy "a" (although in the C code it never references "a") - for 
this reason - if you have variables that you modify asynchronously, they 
shouldn't have a type smaller than 32 bits.

bool allow_migrate, bool enable_migration_modulator, bool on_terminate 
have this problem, change them to int.


Lack of ACCESS_ONCE
-------------------

You can read a variable while you modify it (the variable must not be 
bigger than "long" type, see the section "Nonatomic 64-bit variables").

However, if you read a variable that may be modified, you must use the 
ACCESS_ONCE macro.

For example see this:
if (cache->on_terminate)
        return;
cache->on_terminate may change while you are reading it, so you should use
if (ACCESS_ONCE(cache->on_terminate))
	return;

There are many other variables that are read while modifying them and that 
need ACCESS_ONCE, for example cache->allow_migrate. There are plenty of 
other variables in your code that may be read and modified at the same 
time.

The reason why you need ACCESS_ONCE is that the C compiler assumes that 
the variable that you read doesn't change. Thus, it can perform certain 
optimizations. ACCESS_ONCE suppresses these optimizations.

In most cases, omitting ACCESS_ONCE doesn't cause any misbehavior, for the 
reason that the compiler doesn't use the assumption, that the variable 
doesn't change, to perform optimizations. But the compiler may use this 
assumption, and if it does, it triggers a hard to find bug.


GFP_NOIO allocations
--------------------

If possible, you should use mempool instead. Mempool allocation doesn't 
fail (if memory is exhausted, it waits until some objects are returned to 
the mempool).

kmalloc_retry is not needed - there's a flag __GFP_NOFAIL that does 
infinite retry.

The problem with GFP_IO is that if the system is in such a state when all 
memory is dirty and the only way how to free memory is to write pages to 
the swap, it deadlocks - the memory manager waits for your driver to write 
some data to the swap - and your driver is waiting for the memory manager 
to free some memory so that you can allocate memory and process the write.

To avoid this problem, use mempools.


64-bit divide and modulo
------------------------

You can't use divide and modulo operators ('/' and '%') on 64-bit values. 
On 32-bit architectures, these operators need library functions and these 
functions are not present in the kernel. You need to use div64_u64 
(divides 64-bit value by 64-bit value), div64_u64_rem (divides 64-bit 
value by 64-bit value and also returns a remainder), You can also use 
do_div (it divides a 64-bit value by a 32-bit value), or sector_div (it 
divides sector_t by a 32-bit value).

Try to compile your driver with 32-bit kernel and you will see that '/' 
and '%' doesn't work on 64-bit values.


Wrong printf arguments
----------------------

Try to compile your driver on 32-bit system. You get some warnings.

size_t x;
printf("%lu", x) - this is wrong because %lu says that the type is 
unsigned long and the type is size_t (size_t may be unsigned or unsigned 
long on different architectures). It should be
printf("%zu", z);

sector_t s;
printf("%lu", s) - this is wrong because the sector_t may not have the 
same type as unsigned long. (on 32-bit architectures, you can select 
32-bit sector_t or 64-bit sector_t in kernel configuration). It should be
printf("%llu", (unsigned long long)s);

DMEMIT("%lu ", atomic64_read(v)); - wrong, because format is unsigned long 
and type is 64-bit. It should be
DMEMIT("%llu ", (unsigned long long)atomic64_read(v));


Infinite retry on I/O error in dm_safe_io_retry
-----------------------------------------------

Don't do this. If the cache disk fails for some reason, it kills the 
system by doing inifinite retry.

Generally, I/O retry is handler by the lowest level driver (for example, 
if ATA disk fails to respond, the driver tries to reset the disk and 
reissue the request). If you get I/O error, you can assume that the lowest 
level driver retried as much as it could and you shouldn't do additional 
retry.

If you can't handle a specific I/O request failure gracefully, you should 
mark the driver as dead, don't do any more I/Os to the disk or cache 
device and return -EIO on all incoming requests.

Always think that I/O failures can happen because of connection problems, 
not data corruption problems - for example, a disk cable can go loose, a 
network may lose connectivity, etc. In these cases, it is best to stop 
doing any I/O at all and let the user resolve the situation.

I think that you should always stop the driver on write error (stopping it 
minimizes data damage when there is connectivity problem such as loose 
cable). On read error you should stop the driver if the error is 
non-recoverable (for example, when you get error when reading the cache 
device in the migration process). You don't have to stop on read error, if 
it is recoverable (for example, when you see read error on the disk, you 
can just return -EIO to the user without stopping the driver).


Pointless modulator_proc
------------------------

This thread does no work, it just turns cache->allow_migrate on and off. 
Thus, the thread is useless, you can just remove it. In the place where 
you read cache->allow_migrate (in migrate_proc) you could just do the work 
that used to be performed in modulator_proc.


Rewrite consideration
---------------------

Some of the above problems can be fixed easily, but others can't - for 
example, if the code uses timed polling, it is not trivial to convert it 
to event-based processing. Similarly, the lack of locks or memory barriers 
when acessing shared data can't be easily fixed - I pinpointed some cases 
where they are missing, but I didn't find all the problems - if you wrote 
the code without considering the need for synchronization primitives, it 
is not trivial to add them afterwards.

I think the best thing would be two rewrite the code and take the above 
notes into account (in the rewriting you can use pieces of code already 
written).


First, you must design some event model - (a bunch of threads polling in 1 
second interval doesn't seem viable). For example, you can use workqueues 
correctly this way:

* You create a workqueue for migration, but you don't submit any work to 
  it.
* If you fill the cache device above the watermark, you submit a work item 
  to the migration workqueue (you can submit the same work item to the 
  same workqueue multiple times - if the work item is still queued and 
  hasn't started executing, the second submit is ignored; if the work item 
  has started executing, the second submit causes that it is executed once
  more).
* The work item does a little bit of work, it finds data to be migrated, 
  submits the bios to do the migration and exits. (you can use dm-kcopyd 
  to do actual migration, it simplifies your code)
* If you need more migration, you just submit the work item again.

If you design it this way, you avoid the polling timers (migration starts 
as soon as it is needed) and also you avoid the problem with the looping 
workqueue.


Next, you need to design some locking - which variables are protected by 
which locks. If you use shared variables without locks, you need to use 
memory barriers (it is harder to design code using memory barriers than 
locks).


Mikulas
