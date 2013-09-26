Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3IZBml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:42:41 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50028 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3IZBmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:42:39 -0400
Message-ID: <52439107.70901@gmail.com>
Date: Thu, 26 Sep 2013 10:42:31 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: snitzer@redhat.com
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com, ejt@redhat.com, dan.carpenter@oracle.com,
        ruby.wktk@gmail.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130925173757.GA24076@redhat.com>
In-Reply-To: <20130925173757.GA24076@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

I have made another progress yesterday:
Splitting the monolithic source code into
meaningful pieces is done.
It will follow in the next mail.

> Yes, please share your plan.  Anything that can simplify the code layout
> is best done earlier to simplfy code review.
Sorry, should have been done in earlier stage.

First, I reply to each of your comments.

> OK, but the thing is upper level consumers in the IO stack, like ext4,
> expect that when the REQ_FLUSH completes that the device has in fact
> flushed any transient state in memory.  So I'm not seeing how handling
> these lazily is an option.  Though I do appreciate that dm-cache (and
> dm-thin) do take similar approaches.  Would like to get Joe Thornber's
> insight here.
When the upper level consumers receives
the completion of bio with REQ_FLUSH sent
all the transient states are persistent.
writeboost do four steps to accomplish this:
1. queue the flush job with the current transient state (RAM buffer).
2. wait for the completion of the flush job to be written in cache device.
3. blkdev_issue_flush() to the cache device to make all the writes persistent.
4. bio_endio() to the said flagged bios.

If the implementation isn't wrong
It could be working as the consumers expect is what I believe.


> These seem reasonable to me.  Will need to have a look at thread naming
> to make sure the names reflect they are part of a dm-writeboost service.
I change former "Cache Synchronizer" to "Dirty Synchronizer"
but it sounds little bit odd still.
Naming is truly difficult.


> You don't allow user to specify the "segment size"?  I'd expect tuning
> that could be important based on the underlying storage capabilities
> (e.g. having the segment size match that of the SSD's erase block or
> matching the backing device's full stripe width?).  SO something similar
> to what we have in dm-cache's blocksize.
For the current implementation, No.
The segment size is hard-coded in the source code and
one has to re-compile the module to change the segment size.

But hard-coding the size has reasonable background
for performance and simplification.

Please look at the code fragment from .map method which does
(1) writeboost first sees hit/miss. Get metablock (mb).
(2) And then have to get the segment_header "logically" containing the metablock.

        mb = ht_lookup(cache, head, &key); // (1)
        if (mb) {
                seg = ((void *) mb) - (mb->idx % NR_CACHES_INSEG) * // (2)
                                      sizeof(struct metablock);
                atomic_inc(&seg->nr_inflight_ios);
        }

#define NR_CACHES_INSEG ((1 << (WB_SEGMENTSIZE_ORDER - 3)) - 1)

(3)
struct segment_header {
        struct metablock mb_array[NR_CACHES_INSEG];

In the current implementation
I place metablocks especially "physically" in the segment header (3)
so calculation of the segment header containing the metablock
is a just a simple address calculation which performs good.
Since writeboost focuses on the peak write performance
the light-weighted lookup is the lifeline.

If I re-design writeboost to accept segment size in .ctr
this technique will be impossible
since knowing NR_CACHES_INSEG before accepting it is impossible.

It is just a matter of tradeoff.

But probably,
having purged cache-sharing gave me some another chance of
fancy technique to do the same thing with reasonable overhead
and code complexity. I will try to think of it.
I know forcing re-compiling the kernel
to the ordinary users sounds harsh.


> I'll look at the code but it strikes me as odd that the first sector of
> the cache device is checked yet the last sector of the first MB of the
> cache is wher ethe superblock resides.  I'd think you'd want to have the
> check on whether to format or not to be the same location as the
> superblock?
The first sector of the first 1MB is called Superblock Header and
the last sector of the first 1MB is called Superblock Record.
The former contains information fixed at initialization and
the latter contains information updated runtime
by Superblock Recorder daemon.

The latter is also checked in initialization step.
The logic is in recover_cache().
If it contains `last_migrated_segment_id` updated,
the time for recover_cache() becomes short.


> So this "<16 stat info (r/w)", is that like /proc/diskstats ?  Are you
> aware that dm-stats exists now and can be used instead of needing to
> tracking these stats in dm-writeboost?
Sort of.
But the difference is that
these information is relevant to
how a bio went through the path in writeboost.
They are like "read hits", "read misses" ... in dm-cache status.
So I don't think I need to discard it.

I read through the document of statistics
https://lwn.net/Articles/566273/
and I understand the dm-stats only surveils the
external I/O statistics
but not the internal conditional branch in detail.


> Whatever name you come up with, please add a "dm_" prefix.
add dm_ prefix to only struct or
to including all filenames and function names?
If so, needs really big fixing.


> Yes, these will be important to make sure state is synchronized at
> proper places.  Big rule of thumb is you don't want to do any
> memory allocations outside of the .ctr method.  Otherwise you can run
> into theoretical deadlocks when DM devices are stacked.
> 
> But my review will focus on these aspects of dm-writeboost (safety
> relative to suspend and resume) rather than the other dm-writeboost
> specific implementation.  So we'll sort it out if something needs
> fixing.
I will be waiting for you reviewing.

For your information,
writeboost can
makes all the transient state to persistent and
stops all the daemon such as migration daemon
at postsuspend to "freeze" the logical device.
But I don't have an idea what state strictly
the logical device should be in after suspending.
I couldn't understand that by simple look at
how the other targets implement these methods.


> But you're welcome to use the latest released final kernel instead
> (currently v3.11).  Given you don't seem to be needing to modify DM core
> it isn't a big deal which kernel you develop against (provided it is
> pretty recent).  Whatever is easiest for you.
I am using v3.11.



> But will this always be the case?  Couldn't it be that you add another
> K-V pair sometime in the future?

> I'm not following why you feel including the key name in the status is
> meaningless.

I understand.
I forgot the possibility of adding another daemon that is tunable.
However, I don't see the reason not to
add "read-miss" key to the #read-miss in dm-cache status for example.
Only tunable parameters are in K-V pair format is the implicit design rule?

Akira

On 9/26/13 2:37 AM, Mike Snitzer wrote:
> On Tue, Sep 24 2013 at  8:20am -0400,
> Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> 
>> Hi, Mike
>>
>> I am now working on redesigning and implementation
>> of dm-writeboost.
>>
>> This is a progress report. 
>>
>> Please run
>> git clone https://github.com/akiradeveloper/dm-writeboost.git 
>> to see full set of the code.
> 
> I likely won't be able to look closely at the code until Monday (9/30);
> I have some higher priority reviews and issues to take care of this
> week.
> 
> But I'm very encouraged by what you've shared below; looks like things
> are moving in the right direction.  Great job.
> 
>> * 1. Current Status
>> writeboost in new design passed my test.
>> Documentations are ongoing.
>>
>> * 2. Big Changes 
>> - Cache-sharing purged
>> - All Sysfs purged.
>> - All Userland tools in Python purged.
>> -- dmsetup is the only user interface now.
>> - The daemon in userland is ported to kernel.
>> - On-disk metadata are in little endian.
>> - 300 lines of codes shed in kernel
>> -- Python scripts were 500 LOC so 800 LOC in total.
>> -- It is now about 3.2k LOC all in kernel.
>> - Comments are added neatly.
>> - Reorder the codes so that it gets more readable.
>>
>> * 3. Documentation in Draft
>> This is a current document that will be under Documentation/device-mapper
>>
>> dm-writeboost
>> =============
>> writeboost target provides log-structured caching.
>> It batches random writes into a big sequential write to a cache device.
>>
>> It is like dm-cache but the difference is
>> that writeboost focuses on handling bursty writes and lifetime of SSD cache device.
>>
>> Auxiliary PDF documents and Quick-start scripts are available in
>> https://github.com/akiradeveloper/dm-writeboost
>>
>> Design
>> ======
>> There are foreground path and 6 background daemons.
>>
>> Foreground
>> ----------
>> It accepts bios and put writes to RAM buffer.
>> When the buffer is full, it creates a "flush job" and queues it.
>>
>> Background
>> ----------
>> * Flush Daemon
>> Pop a flush job from the queue and executes it.
>>
>> * Deferring ACK for barrier writes
>> Barrier flags such as REQ_FUA and REQ_FLUSH are handled lazily.
>> Immediately handling these bios badly slows down writeboost.
>> It surveils the bios with these flags and forcefully flushes them
>> at worst case within `barrier_deadline_ms` period.
> 
> OK, but the thing is upper level consumers in the IO stack, like ext4,
> expect that when the REQ_FLUSH completes that the device has in fact
> flushed any transient state in memory.  So I'm not seeing how handling
> these lazily is an option.  Though I do appreciate that dm-cache (and
> dm-thin) do take similar approaches.  Would like to get Joe Thornber's
> insight here.
> 
>> * Migration Daemon
>> It migrates, writes back cache data to backing store,
>> the data on the cache device in segment granurality.
>>
>> If `allow_migrate` is true, it migrates without impending situation.
>> Being in impending situation is that there are no room in cache device
>> for writing further flush jobs.
>>
>> Migration at a time is done batching `nr_max_batched_migration` segments at maximum.
>> Therefore, unlike existing I/O scheduler,
>> two dirty writes distant in time space can be merged.
>>
>> * Migration Modulator
>> Migration while the backing store is heavily loaded
>> grows the device queue and thus makes the situation ever worse.
>> This daemon modulates the migration by switching `allow_migrate`.
>>
>> * Superblock Recorder
>> Superblock record is a last sector of first 1MB region in cache device.
>> It contains what id of the segment lastly migrated.
>> This daemon periodically update the region every `update_record_interval` seconds.
>>
>> * Cache Synchronizer
>> This daemon forcefully makes all the dirty writes persistent
>> every `sync_interval` seconds.
>> Since writeboost correctly implements the bio semantics
>> writing the dirties out forcefully out of the main path is needless.
>> However, some user want to be on the safe side by enabling this.
> 
> These seem reasonable to me.  Will need to have a look at thread naming
> to make sure the names reflect they are part of a dm-writeboost service.
> 
>> Target Interface
>> ================
>> All the operations are via dmsetup command.
>>
>> Constructor
>> -----------
>> writeboost <backing dev> <cache dev>
>>
>> backing dev : slow device holding original data blocks.
>> cache dev   : fast device holding cached data and its metadata.
> 
> You don't allow user to specify the "segment size"?  I'd expect tuning
> that could be important based on the underlying storage capabilities
> (e.g. having the segment size match that of the SSD's erase block or
> matching the backing device's full stripe width?).  SO something similar
> to what we have in dm-cache's blocksize.
> 
>> Note that cache device is re-formatted
>> if the first sector of the cache device is zeroed out.
> 
> I'll look at the code but it strikes me as odd that the first sector of
> the cache device is checked yet the last sector of the first MB of the
> cache is wher ethe superblock resides.  I'd think you'd want to have the
> check on whether to format or not to be the same location as the
> superblock?
> 
>> Status
>> ------
>> <#dirty caches> <#segments>
>> <id of the segment lastly migrated>
>> <id of the segment lastly flushed>
>> <id of the current segment>
>> <the position of the cursor>
>> <16 stat info (r/w) x (hit/miss) x (on buffer/not) x (fullsize/not)>
>> <# of kv pairs>
>> <kv pairs>
> 
> So this "<16 stat info (r/w)", is that like /proc/diskstats ?  Are you
> aware that dm-stats exists now and can be used instead of needing to
> tracking these stats in dm-writeboost?
>  
>> Messages
>> --------
>> You can tune up writeboost via message interface.
>>
>> * barrier_deadline_ms (ms)
>> Default: 3
>> All the bios with barrier flags like REQ_FUA or REQ_FLUSH
>> are guaranteed to be acked within this deadline.
>>
>> * allow_migrate (bool)
>> Default: 1
>> Set to 1 to start migration.
>>
>> * enable_migration_modulator (bool) and
>>   migrate_threshold (%)
>> Default: 1
>> Set to 1 to run migration modulator.
>> Migration modulator surveils the load of backing store
>> and set the migration started when the load is
>> lower than the migrate_threshold.
>>
>> * nr_max_batched_migration (int)
>> Default: 1
>> Number of segments to migrate simultaneously and atomically.
>> Set higher value to fully exploit the capacily of the backing store.
>>
>> * sync_interval (sec)
>> Default: 60
>> All the dirty writes are guaranteed to be persistent by this interval.
>>
>> * update_record_interval (sec)
>> Default: 60
>> The superblock record is updated every update_record_interval seconds.
> 
> OK to the above.
>  
>> Example
>> =======
>> dd if=/dev/zero of=${CACHE} bs=512 count=1 oflag=direct
>> sz=`blockdev --getsize ${BACKING}`
>> dmsetup create writeboost-vol --table "0 ${sz} writeboost ${BACKING} {CACHE}"
>>
>> * 4. TODO
>> - rename struct arr
>> -- It is like flex_array but lighter by eliminating the resizableness.
>>    Maybe, bigarray is a next candidate but I don't have a judge on this.
>>    I want to make an agreement on this renaming issue before doing it.
> 
> Whatever name you come up with, please add a "dm_" prefix.
> 
>> - resume, preresume and postsuspend possibly have to be implemented.
>> -- But I have no idea at all.
>> -- Maybe, I should make a research on other target implementing these methods.
> 
> Yes, these will be important to make sure state is synchronized at
> proper places.  Big rule of thumb is you don't want to do any
> memory allocations outside of the .ctr method.  Otherwise you can run
> into theoretical deadlocks when DM devices are stacked.
> 
> But my review will focus on these aspects of dm-writeboost (safety
> relative to suspend and resume) rather than the other dm-writeboost
> specific implementation.  So we'll sort it out if something needs
> fixing.
> 
>> - dmsetup status is like that of dm-cache
>> -- Please look at the example in the reference below.
>> -- It is far less understandable. Moreover inflexible to changes. 
>> -- If I may not change the output format in the future 
>>    I think I should make an agreement on the format.
> 
> Yes, that is one major drawback but generally speaking it is for upper
> level tools to consume this info (e.g. lvm2).  So human readability
> isn't of primary concern.
> 
>> - Splitting the code is desireble.
>> -- Should I show you a plan of splitting immediately?
>> -- If so, I will start it immediately.
> 
> Yes, please share your plan.  Anything that can simplify the code layout
> is best done earlier to simplfy code review.
> 
>> - Porting the current implementation to linux-next
>> -- I am working on my portable kernel with version switches.
>> -- I want to make an agreement on the basic design with maintainers
>>    before going to the next step.
>> -- WB* macros will be purged for sure.
> 
> I'd prefer you focus on getting the code working on a stable baseline of
> your choosing.  For instance you could build on the linux-dm.git
> "for-linus" branch, see:
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git
> 
> But you're welcome to use the latest released final kernel instead
> (currently v3.11).  Given you don't seem to be needing to modify DM core
> it isn't a big deal which kernel you develop against (provided it is
> pretty recent).  Whatever is easiest for you.
> 
>> * 5. References 
>> - Example of `dmsetup status`
>> -- the number 7 before the barrier_deadline_ms is a number of K-V pairs 
>>    but they are of fixed number in dm-writeboost unlike dm-cache.
>>    I am thinking of removing it.
> 
> But will this always be the case?  Couldn't it be that you add another
> K-V pair sometime in the future?
> 
>>    Even K such as barrier_deadline_ms and allow_migrate are also meaningless
>>    for the same reason.
> 
> I'm not following why you feel including the key name in the status is
> meaningless.
> 
>> # root@Hercules:~/dm-writeboost/testing/1# dmsetup status perflv
>> 0 6291456 writeboost 0 3 669 669 670 0 21 6401 24 519 0 0 13 7051 1849 63278 29 11 0 0 6 7 barrier_deadline_ms 3 allow_migrate 1 enable_migration_modulator 1 migrate_threshold 70 nr_cur_batched_migration 1 sync_interval 3 update_record_interval 2
> 
> Yeah, it certainly isn't easy for a human to zero in on what is
> happening here.. but like I said above, that isn't a goal of dmsetup
> status output ;)
> 

