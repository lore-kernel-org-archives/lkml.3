Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3IXMU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:20:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35521 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3IXMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:20:55 -0400
Message-ID: <524183A2.9050301@gmail.com>
Date: Tue, 24 Sep 2013 21:20:50 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: snitzer@redhat.com
CC: ruby.wktk@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, cesarb@cesarb.net, joe@perches.com,
        akpm@linux-foundation.org, agk@redhat.com, m.chehab@samsung.com,
        ejt@redhat.com, dan.carpenter@oracle.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com>
In-Reply-To: <523E3522.2060607@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

I am now working on redesigning and implementation
of dm-writeboost.

This is a progress report. 

Please run
git clone https://github.com/akiradeveloper/dm-writeboost.git 
to see full set of the code.

* 1. Current Status
writeboost in new design passed my test.
Documentations are ongoing.

* 2. Big Changes 
- Cache-sharing purged
- All Sysfs purged.
- All Userland tools in Python purged.
-- dmsetup is the only user interface now.
- The daemon in userland is ported to kernel.
- On-disk metadata are in little endian.
- 300 lines of codes shed in kernel
-- Python scripts were 500 LOC so 800 LOC in total.
-- It is now about 3.2k LOC all in kernel.
- Comments are added neatly.
- Reorder the codes so that it gets more readable.

* 3. Documentation in Draft
This is a current document that will be under Documentation/device-mapper

dm-writeboost
=============
writeboost target provides log-structured caching.
It batches random writes into a big sequential write to a cache device.

It is like dm-cache but the difference is
that writeboost focuses on handling bursty writes and lifetime of SSD cache device.

Auxiliary PDF documents and Quick-start scripts are available in
https://github.com/akiradeveloper/dm-writeboost

Design
======
There are foreground path and 6 background daemons.

Foreground
----------
It accepts bios and put writes to RAM buffer.
When the buffer is full, it creates a "flush job" and queues it.

Background
----------
* Flush Daemon
Pop a flush job from the queue and executes it.

* Deferring ACK for barrier writes
Barrier flags such as REQ_FUA and REQ_FLUSH are handled lazily.
Immediately handling these bios badly slows down writeboost.
It surveils the bios with these flags and forcefully flushes them
at worst case within `barrier_deadline_ms` period.

* Migration Daemon
It migrates, writes back cache data to backing store,
the data on the cache device in segment granurality.

If `allow_migrate` is true, it migrates without impending situation.
Being in impending situation is that there are no room in cache device
for writing further flush jobs.

Migration at a time is done batching `nr_max_batched_migration` segments at maximum.
Therefore, unlike existing I/O scheduler,
two dirty writes distant in time space can be merged.

* Migration Modulator
Migration while the backing store is heavily loaded
grows the device queue and thus makes the situation ever worse.
This daemon modulates the migration by switching `allow_migrate`.

* Superblock Recorder
Superblock record is a last sector of first 1MB region in cache device.
It contains what id of the segment lastly migrated.
This daemon periodically update the region every `update_record_interval` seconds.

* Cache Synchronizer
This daemon forcefully makes all the dirty writes persistent
every `sync_interval` seconds.
Since writeboost correctly implements the bio semantics
writing the dirties out forcefully out of the main path is needless.
However, some user want to be on the safe side by enabling this.

Target Interface
================
All the operations are via dmsetup command.

Constructor
-----------
writeboost <backing dev> <cache dev>

backing dev : slow device holding original data blocks.
cache dev   : fast device holding cached data and its metadata.

Note that cache device is re-formatted
if the first sector of the cache device is zeroed out.

Status
------
<#dirty caches> <#segments>
<id of the segment lastly migrated>
<id of the segment lastly flushed>
<id of the current segment>
<the position of the cursor>
<16 stat info (r/w) x (hit/miss) x (on buffer/not) x (fullsize/not)>
<# of kv pairs>
<kv pairs>

Messages
--------
You can tune up writeboost via message interface.

* barrier_deadline_ms (ms)
Default: 3
All the bios with barrier flags like REQ_FUA or REQ_FLUSH
are guaranteed to be acked within this deadline.

* allow_migrate (bool)
Default: 1
Set to 1 to start migration.

* enable_migration_modulator (bool) and
  migrate_threshold (%)
Default: 1
Set to 1 to run migration modulator.
Migration modulator surveils the load of backing store
and set the migration started when the load is
lower than the migrate_threshold.

* nr_max_batched_migration (int)
Default: 1
Number of segments to migrate simultaneously and atomically.
Set higher value to fully exploit the capacily of the backing store.

* sync_interval (sec)
Default: 60
All the dirty writes are guaranteed to be persistent by this interval.

* update_record_interval (sec)
Default: 60
The superblock record is updated every update_record_interval seconds.

Example
=======
dd if=/dev/zero of=${CACHE} bs=512 count=1 oflag=direct
sz=`blockdev --getsize ${BACKING}`
dmsetup create writeboost-vol --table "0 ${sz} writeboost ${BACKING} {CACHE}"

* 4. TODO
- rename struct arr
-- It is like flex_array but lighter by eliminating the resizableness.
   Maybe, bigarray is a next candidate but I don't have a judge on this.
   I want to make an agreement on this renaming issue before doing it.
- resume, preresume and postsuspend possibly have to be implemented.
-- But I have no idea at all.
-- Maybe, I should make a research on other target implementing these methods.
- dmsetup status is like that of dm-cache
-- Please look at the example in the reference below.
-- It is far less understandable. Moreover inflexible to changes. 
-- If I may not change the output format in the future 
   I think I should make an agreement on the format.
- Splitting the code is desireble.
-- Should I show you a plan of splitting immediately?
-- If so, I will start it immediately.
- Porting the current implementation to linux-next
-- I am working on my portable kernel with version switches.
-- I want to make an agreement on the basic design with maintainers
   before going to the next step.
-- WB* macros will be purged for sure.

* 5. References 
- Example of `dmsetup status`
-- the number 7 before the barrier_deadline_ms is a number of K-V pairs 
   but they are of fixed number in dm-writeboost unlike dm-cache.
   I am thinking of removing it.
   Even K such as barrier_deadline_ms and allow_migrate are also meaningless
   for the same reason.
# root@Hercules:~/dm-writeboost/testing/1# dmsetup status perflv
0 6291456 writeboost 0 3 669 669 670 0 21 6401 24 519 0 0 13 7051 1849 63278 29 11 0 0 6 7 barrier_deadline_ms 3 allow_migrate 1 enable_migration_modulator 1 migrate_threshold 70 nr_cur_batched_migration 1 sync_interval 3 update_record_interval 2


Thanks,
Akira
