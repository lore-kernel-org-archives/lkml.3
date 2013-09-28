Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3I1L3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:29:13 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38303 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3I1L3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:29:08 -0400
Message-ID: <5246BD7D.2000407@gmail.com>
Date: Sat, 28 Sep 2013 20:29:01 +0900
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
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130925173757.GA24076@redhat.com> <5243922B.6070705@gmail.com> <20130927183507.GA16553@redhat.com>
In-Reply-To: <20130927183507.GA16553@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Two major progress:
1) .ctr accepts segment size so .ctr now accepts 3 arguments: <backing dev> <cache dev> <segment size order>.
2) fold the small files splitted that I suggested in the previous progress report.

For 1) 
I use zero length array to dynamically accept the segment size.
writeboost had the parameter embedded previously and one must re-compile the code
to change the parameter which badly loses usability was the problem.

For 2)
> Unfortunately I think you went too far with all these different small
> files, I was hoping to see 2 or 3 .c files and a couple .h files.
> 
> Maybe fold all the daemon code into a 1 .c and 1 .h ?
> 
> The core of the writeboost target in dm-writeboost-target.c ?
> 
> And fold all the other data structures into a 1 .c and 1 .h ?
> 
> When folding these files together feel free to use dividers in the code
> like dm-thin.c and dm-cache-target.c do, e.g.:
> 
> /*-----------------------------------------------------------------*/
As Mike pointed out splitting into almost 20 files went too far.
I aggregated these files into 3 .c files and 3 .h files in total which are shown below.

---------- Summary ----------
39 dm-writeboost-daemon.h
46 dm-writeboost-metadata.h
413 dm-writeboost.h
577 dm-writeboost-daemon.c
1129 dm-writeboost-metadata.c
1212 dm-writeboost-target.c
81 dm-writeboost.mod.c

The responsibilities of each .c file
is the policy of this splitting.

a) dm-writeboost-metadata.c
This file knows how the metadata is laid out on cache device.
It can audit/format the cache device metadata
and resume/free the in-core cache metadata from that on the cache device.
Also provides accessor to the in-core metadata resumed.

b) dm-writeboost-target.c
This file contains all the methods to define target type.
In terms of I/O processing, this files only defines
from when bio is accepted to when flush job is queued
which is described as "foreground processing" in the document.
What happens after the job is queued is defined in -daemon.c file.

c) dm-writeboost-daemon.c
This file contains all the daemons as Mike suggested.
Maybe, superblock_recorder should be in the -metadata.c file
but I chose to put it on this file since for unity.

Thanks,
Akira


followed by the current .h files.

---------- dm-writeboost-daemon.h ----------
/*
 * Copyright (C) 2012-2013 Akira Hayakawa <ruby.wktk@gmail.com>
 *
 * This file is released under the GPL.
 */

#ifndef DM_WRITEBOOST_DAEMON_H
#define DM_WRITEBOOST_DAEMON_H

/*----------------------------------------------------------------*/

void flush_proc(struct work_struct *);

/*----------------------------------------------------------------*/

void queue_barrier_io(struct wb_cache *, struct bio *);
void barrier_deadline_proc(unsigned long data);
void flush_barrier_ios(struct work_struct *);

/*----------------------------------------------------------------*/

void migrate_proc(struct work_struct *);
void wait_for_migration(struct wb_cache *, u64 id);

/*----------------------------------------------------------------*/

void modulator_proc(struct work_struct *);

/*----------------------------------------------------------------*/

void sync_proc(struct work_struct *);

/*----------------------------------------------------------------*/

void recorder_proc(struct work_struct *);

/*----------------------------------------------------------------*/

#endif

---------- dm-writeboost-metadata.h ----------
/*
 * Copyright (C) 2012-2013 Akira Hayakawa <ruby.wktk@gmail.com>
 *
 * This file is released under the GPL.
 */

#ifndef DM_WRITEBOOST_METADATA_H
#define DM_WRITEBOOST_METADATA_H

/*----------------------------------------------------------------*/

struct segment_header *get_segment_header_by_id(struct wb_cache *, u64 segment_id);
sector_t calc_mb_start_sector(struct wb_cache *, struct segment_header *, cache_nr mb_idx);
bool is_on_buffer(struct wb_cache *, cache_nr mb_idx);

/*----------------------------------------------------------------*/

struct ht_head *ht_get_head(struct wb_cache *, struct lookup_key *);
struct metablock *ht_lookup(struct wb_cache *,
			    struct ht_head *, struct lookup_key *);
void ht_register(struct wb_cache *, struct ht_head *,
		 struct lookup_key *, struct metablock *);
void ht_del(struct wb_cache *, struct metablock *);
void discard_caches_inseg(struct wb_cache *,
			  struct segment_header *);

/*----------------------------------------------------------------*/

int __must_check audit_cache_device(struct dm_dev *, struct wb_cache *,
				    bool *need_format, bool *allow_format);
int __must_check format_cache_device(struct dm_dev *, struct wb_cache *);

/*----------------------------------------------------------------*/

void prepare_segment_header_device(struct segment_header_device *dest,
				   struct wb_cache *,
				   struct segment_header *src);

/*----------------------------------------------------------------*/

int __must_check resume_cache(struct wb_cache *cache, struct dm_dev *dev);
void free_cache(struct wb_cache *cache);

/*----------------------------------------------------------------*/

#endif

---------- dm-writeboost.h ----------
/*
 * Copyright (C) 2012-2013 Akira Hayakawa <ruby.wktk@gmail.com>
 *
 * This file is released under the GPL.
 */

#ifndef DM_WRITEBOOST_H
#define DM_WRITEBOOST_H

/*----------------------------------------------------------------*/

#define DM_MSG_PREFIX "writeboost"

#include <linux/module.h>
#include <linux/version.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/mutex.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/device-mapper.h>
#include <linux/dm-io.h>

#define WBERR(f, args...) \
	DMERR("err@%d " f, __LINE__, ## args)
#define WBWARN(f, args...) \
	DMWARN("warn@%d " f, __LINE__, ## args)
#define WBINFO(f, args...) \
	DMINFO("info@%d " f, __LINE__, ## args)

/*
 * The amount of RAM buffer pool to pre-allocated.
 */
#define RAMBUF_POOL_ALLOCATED 64 /* MB */

/*
 * The Detail of the Disk Format
 *
 * Whole:
 * Superblock (1MB) + Segment + Segment ...
 * We reserve the first 1MB as the superblock.
 *
 * Superblock:
 * head <----                                     ----> tail
 * superblock header (512B) + ... + superblock record (512B)
 *
 * Segment:
 * segment_header_device +
 * metablock_device * nr_caches_inseg +
 * (aligned first 4KB region)
 * data[0] (4KB) + data{1] + ... + data{nr_cache_inseg - 1]
 */

/*
 * Superblock Header
 * First one sector of the super block region.
 * The value is fixed after formatted.
 */

 /*
  * Magic Number
  * "WBst"
  */
#define WRITEBOOST_MAGIC 0x57427374
struct superblock_header_device {
	__le32 magic;
	u8 segment_size_order;
} __packed;

/*
 * Superblock Record (Mutable)
 * Last one sector of the superblock region.
 * Record the current cache status in need.
 */
struct superblock_record_device {
	__le64 last_migrated_segment_id;
} __packed;

/*
 * Cache line index.
 *
 * dm-writeboost can supoort a cache device
 * with size less than 4KB * (1 << 32)
 * that is 16TB.
 */
typedef u32 cache_nr;

/*
 * Metadata of a 4KB cache line
 *
 * Dirtiness is defined for each sector
 * in this cache line.
 */
struct metablock {
	sector_t sector; /* key */

	cache_nr idx; /* Const */

	struct hlist_node ht_list;

	/*
	 * 8 bit flag for dirtiness
	 * for each sector in cache line.
	 *
	 * Current implementation
	 * only recovers dirty caches.
	 * Recovering clean caches complicates the code
	 * but couldn't be effective
	 * since only few of the caches are clean.
	 */
	u8 dirty_bits;
};

/*
 * On-disk metablock
 */
struct metablock_device {
	__le64 sector;

	u8 dirty_bits;

	__le32 lap;
} __packed;

#define SZ_MAX (~(size_t)0)
struct segment_header {
	/*
	 * ID uniformly increases.
	 * ID 0 is used to tell that the segment is invalid
	 * and valid id >= 1.
	 */
	u64 global_id;

	/*
	 * Segment can be flushed half-done.
	 * length is the number of
	 * metablocks that must be counted in
	 * in resuming.
	 */
	u8 length;

	cache_nr start_idx; /* Const */
	sector_t start_sector; /* Const */

	struct list_head migrate_list;

	/*
	 * This segment can not be migrated
	 * to backin store
	 * until flushed.
	 * Flushed segment is in cache device.
	 */
	struct completion flush_done;

	/*
	 * This segment can not be overwritten
	 * until migrated.
	 */
	struct completion migrate_done;

	spinlock_t lock;

	atomic_t nr_inflight_ios;

	struct metablock mb_array[0];
};

/*
 * (Locking)
 * Locking metablocks by their granularity
 * needs too much memory space for lock structures.
 * We only locks a metablock by locking the parent segment
 * that includes the metablock.
 */
#define lockseg(seg, flags) spin_lock_irqsave(&(seg)->lock, flags)
#define unlockseg(seg, flags) spin_unlock_irqrestore(&(seg)->lock, flags)

/*
 * On-disk segment header.
 *
 * Must be at most 4KB large.
 */
struct segment_header_device {
	/* - FROM - At most512 byte for atomicity. --- */
	__le64 global_id;
	/*
	 * How many cache lines in this segments
	 * should be counted in resuming.
	 */
	u8 length;
	/*
	 * On what lap in rorating on cache device
	 * used to find the head and tail in the
	 * segments in cache device.
	 */
	__le32 lap;
	/* - TO -------------------------------------- */
	/* This array must locate at the tail */
	struct metablock_device mbarr[0];
} __packed;

struct rambuffer {
	void *data;
	struct completion done;
};

enum STATFLAG {
	STAT_WRITE = 0,
	STAT_HIT,
	STAT_ON_BUFFER,
	STAT_FULLSIZE,
};
#define STATLEN (1 << 4)

struct lookup_key {
	sector_t sector;
};

struct ht_head {
	struct hlist_head ht_list;
};

struct wb_device;
struct wb_cache {
	struct wb_device *wb;

	struct dm_dev *device;
	struct mutex io_lock;
	cache_nr nr_caches; /* Const */
	u64 nr_segments; /* Const */
	u8 segment_size_order; /* Const */
	u8 nr_caches_inseg; /* Const */
	struct bigarray *segment_header_array;

	/*
	 * Chained hashtable
	 *
	 * Writeboost uses chained hashtable
	 * to cache lookup.
	 * Cache discarding often happedns
	 * This structure fits our needs.
	 */
	struct bigarray *htable;
	size_t htsize;
	struct ht_head *null_head;

	cache_nr cursor; /* Index that has been written the most lately */
	struct segment_header *current_seg;

	struct rambuffer *current_rambuf;
	size_t nr_rambuf_pool; /* Const */
	struct rambuffer *rambuf_pool;

	u64 last_migrated_segment_id;
	u64 last_flushed_segment_id;
	u64 reserving_segment_id;

	/*
	 * Flush daemon
	 *
	 * Writeboost first queue the segment to flush
	 * and flush daemon asynchronously
	 * flush them to the cache device.
	 */
	struct work_struct flush_work;
	struct workqueue_struct *flush_wq;
	spinlock_t flush_queue_lock;
	struct list_head flush_queue;
	wait_queue_head_t flush_wait_queue;

	/*
	 * Deferred ACK for barriers.
	 */
	struct work_struct barrier_deadline_work;
	struct timer_list barrier_deadline_timer;
	struct bio_list barrier_ios;
	unsigned long barrier_deadline_ms; /* param */

	/*
	 * Migration daemon
	 *
	 * Migartion also works in background.
	 *
	 * If allow_migrate is true,
	 * migrate daemon goes into migration
	 * if they are segments to migrate.
	 */
	struct work_struct migrate_work;
	struct workqueue_struct *migrate_wq;
	bool allow_migrate; /* param */

	/*
	 * Batched Migration
	 *
	 * Migration is done atomically
	 * with number of segments batched.
	 */
	wait_queue_head_t migrate_wait_queue;
	atomic_t migrate_fail_count;
	atomic_t migrate_io_count;
	struct list_head migrate_list;
	u8 *dirtiness_snapshot;
	void *migrate_buffer;
	size_t nr_cur_batched_migration;
	size_t nr_max_batched_migration; /* param */

	/*
	 * Migration modulator
	 *
	 * This daemon turns on and off
	 * the migration
	 * according to the load of backing store.
	 */
	struct work_struct modulator_work;
	bool enable_migration_modulator; /* param */

	/*
	 * Superblock Recorder
	 *
	 * Update the superblock record
	 * periodically.
	 */
	struct work_struct recorder_work;
	unsigned long update_record_interval; /* param */

	/*
	 * Cache Synchronizer
	 *
	 * Sync the dirty writes
	 * periodically.
	 */
	struct work_struct sync_work;
	unsigned long sync_interval; /* param */

	/*
	 * on_terminate is true
	 * to notify all the background daemons to
	 * stop their operations.
	 */
	bool on_terminate;

	atomic64_t stat[STATLEN];
};

struct wb_device {
	struct dm_target *ti;

	struct dm_dev *device;

	struct wb_cache *cache;

	u8 migrate_threshold;

	atomic64_t nr_dirty_caches;
};

struct flush_job {
	struct list_head flush_queue;
	struct segment_header *seg;
	/*
	 * The data to flush to cache device.
	 */
	struct rambuffer *rambuf;
	/*
	 * List of bios with barrier flags.
	 */
	struct bio_list barrier_ios;
};

#define PER_BIO_VERSION KERNEL_VERSION(3, 8, 0)
#if LINUX_VERSION_CODE >= PER_BIO_VERSION
struct per_bio_data {
	void *ptr;
};
#endif
#endif

/*----------------------------------------------------------------*/

void flush_current_buffer(struct wb_cache *);
void inc_nr_dirty_caches(struct wb_device *);
void cleanup_mb_if_dirty(struct wb_cache *,
			 struct segment_header *,
			 struct metablock *);
u8 atomic_read_mb_dirtiness(struct segment_header *,
			    struct metablock *);

/*----------------------------------------------------------------*/

extern struct workqueue_struct *safe_io_wq;
extern struct dm_io_client *wb_io_client;

void *do_kmalloc_retry(size_t size, gfp_t flags, int lineno);
#define kmalloc_retry(size, flags) \
	do_kmalloc_retry((size), (flags), __LINE__)

int dm_safe_io_internal(
		struct dm_io_request *,
		unsigned num_regions, struct dm_io_region *,
		unsigned long *err_bits, bool thread, int lineno);
#define dm_safe_io(io_req, num_regions, regions, err_bits, thread) \
	dm_safe_io_internal((io_req), (num_regions), (regions), \
			    (err_bits), (thread), __LINE__)

void dm_safe_io_retry_internal(
		struct dm_io_request *,
		unsigned num_regions, struct dm_io_region *,
		bool thread, int lineno);
#define dm_safe_io_retry(io_req, num_regions, regions, thread) \
	dm_safe_io_retry_internal((io_req), (num_regions), (regions), \
				  (thread), __LINE__)

sector_t dm_devsize(struct dm_dev *);
