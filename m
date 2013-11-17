Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3KQLXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:23:42 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46629 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3KQLXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:23:34 -0500
Message-ID: <5288A72F.5080301@gmail.com>
Date: Sun, 17 Nov 2013 20:23:27 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org, david@fromorbit.com, mpatocka@redhat.com,
        snitzer@redhat.com, ruby.wktk@gmail.com
Subject: Re: dm-writeboost: Progress Report
References: <52772DFE.90402@gmail.com>
In-Reply-To: <52772DFE.90402@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, DM Guys,

Another progress report

1) Changed the .ctr arguments
Before changed it had two major problems

writeboost <backing dev> <cache dev>
           [segment size order]
           [rambuf pool amount]

Problem i) 
dm-writeboost will add support for persistent memory as the RAM buffer.
In detail, I will support two other types of medium as the RAM buffer:
- (a) A block device: persistent memory will first be provided with a block interface.
- (b) A persistent memory with newly designed interface: Still in discussion.

I don't like to add new target type like writeboost-nv-block and writeboost-nv
but like to switch the medium to use by a type flag in .ctr.
The reason is increasing the target types will probably increase the
implementation in userland (like LVM2).

Problem ii)
Whereas the first two arguments are essential
the successive two are only optional.
The problem is the optional arguments are ordered.
The user who want to set rambuf pool amount but keep the
segment size order as the default will be bothered.


To solve these problems I changed the .ctr design.
It has
- "type" arguments as the first argument
- key-value-like optional parameters
  (which is similar to that of dm-flakey)

writeboost <type> <backing dev> <cache dev>
           #optional args
           [segment_size_order val]
           [rambuf_pool_amount val]

Three types (0,1,2) will be supported but 
only for type 0 is implemented at present.
For type 1 (using block device as the ram buffer) 
can be implemented right now but
I want to merge this software to upstream before that
because dm-writeboost has benefit with solely type 0.

For example the arguments for type 1 will be
1 <backing dev> <cache dev> <rambuf dev> ...

2) .ctr now uses dm_arg_set. Deleted handmade ARG_EXIST macro.
dm driver should use dm_arg_set and its methods (such as dm_read_arg).
writeboost driver didn't use it but does at present.


Thanks,
Akira

On 11/4/13 2:17 PM, Akira Hayakawa wrote:
> Hi, DM Guys
> 
> Let me share a new progress report.
> I am sorry I have been off for weeks.
> 
> Writeboost is getting better I believe.
> 
> Many progress, please git pull
> https://github.com/akiradeveloper/dm-writeboost.git
> 
> 1. Removing version switch macros
> Previously the code included 10 or more version switches
> and thus is not appropriate for upstream code of course.
> Now I removed them all and Writeboost is not available for
> older version of kernel.
> 
> 2. .postsuspend and .resume implemented
> dmsetup suspend and resume works now.
> 
> I implemented .postsuspend and .resume for this purpose.
> .postsuspend is called after all I/O is submitted to
> the device. In .postsuspend I make all the transient data
> persistent.
> 
> static void writeboost_postsuspend(struct dm_target *ti)
> {
> 	int r;
> 
> 	struct wb_device *wb = ti->private;
> 	struct wb_cache *cache = wb->cache;
> 
> 	flush_current_buffer(cache);
> 	IO(blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL));
> }
> 
> .postsuspend is also called before .dtr is called.
> I removed the same code from .dtr therefore.
> 
> .resume does nothing at all. 
> 
> 3. Blocking up the device thoroughly implemented 
> How to block up the device has been my annoyance for weeks.
> Now, Writeboost can block up the device in I/O error correctly
> and elegantly.
> 
> What a dead device should satisfy are
> 1) Returns error on all incoming requests
> 2) ACK to all the requests accepted
> 3) To clean up data structures on memory
>    `dmsetup remove` must be accepted even after marked dead
> 4) Blocking up must be processed regardless of any timing issues.
> 
> The principle behind how Writeboost blocks up a device
> is really simple.
> 
> 1) All I/O to underlying devices are wrapped by IO macro (shown below)
>    which set flag WB_DEAD (using set_bit) on -EIO returned.
> 2) If WB_DEAD is set, all I/O to the underlying devices are ignored.
>    This is equivalent to having /dev/null devices underlying.
>    Processings on the memory data structures are still
>    continuing completely agnostic to the fact that
>    the underlying devices ignore their requests.
>    This ensures the logic on the data structures never corrupt
>    and data on the underlying devices never change after marked dead.
> 3) Some codes are wrapped by LIVE, DEAD or LIVE_DEAD
>    macro which switches its behavior in accordance with
>    WB_DEAD bit.
> 
> I tested the mechanism by wrapping the underlying devices (like below)
> by dm-flakey. For both cases (cache fails or backing fails) 
> it seems to be working.
> 
> sz=`blockdev --getsize ${CACHE}`
> dmsetup create cache-flakey --table "0 ${sz} flakey ${CACHE} 0 5 1"
> CACHE=/dev/mapper/cache-flakey
> 
> sz=`blockdev --getsize ${BACKING}`
> dmsetup create backing-flakey --table "0 ${sz} flakey ${BACKING} 0 20 0"
> BACKING=/dev/mapper/backing-flakey
> 
> 3.1 WARN_ONCE introduced
> IO macro branches the behavior with the return code from it wrapping procedure.
> It only treat -EIO as a trigger to block up the device and others are not.
> The problem remains is that I don't know what error
> code can return within possibility. 
> If the error code is not expected, it WARN_ONCE
> to ask user to report the error.
> 
> /*
>  * Only -EIO returned is regarded as a signal
>  * to block up the whole system.
>  *
>  * -EOPNOTSUPP could be returned if the target device is
>  * a virtual device and we request discard.
>  *
>  * -ENOMEM could be returned from blkdev_issue_discard (3.12-rc5)
>  * for example. Waiting for a while can make room for allocation.
>  *
>  * For other unknown error codes we ignore them and
>  * ask the human users to report us.
>  */
> #define IO(proc) \
> 	do { \
> 		r = 0; \
> 		LIVE(r = proc); \
> 		if (r == -EOPNOTSUPP) { \
> 			r = 0; \
> 		} else if (r == -EIO) { \
> 			set_bit(WB_DEAD, &wb->flags); \
> 			wake_up_all(&wb->dead_wait_queue); \
> 			WBERR("marked as dead"); \
> 		} else if (r == -ENOMEM) { \
> 			schedule_timeout_interruptible(msecs_to_jiffies(1000));\
> 		} else if (r) { \
> 			r = 0;\
> 			WARN_ONCE(1, "PLEASE REPORT!!! I/O FAILED FOR UNKNOWN REASON %d", r); \
> 		} \
> 	} while (r)
> 
> 3.2 dead state never recover
> As Dave's advice, I regard the error as fatal and provide no way to restart.
> Removed blockup from message.
> 
> 3.3 XFS corruption never reproduce
> I think the previously discussed error is due to the 
> misbehavior of Writeboost in blocking up.
> For example, some bios are not returned 
> which may corrupt the XFS AIL lock?
> 
> 4. On-disk metadata layout changed and
>    max segment size is reduced to 512KB from 1MB
> struct metablock_device was 13 bytes before.
> This means that the metadata may straddle two sectors
> which causes partial write.
> To avoid this, I added padding to make it 16 bytes.
> As a result, maximum log size shrinks to 512KB.
> 
> 5. `flush_supported = true` added 
> I added `flush_supported = true` to .ctr
> dm-cache and dm-thin also do this.
> There is no meaning for Writeboost to ignore flush requests.
> 
> Below is my wonderings to note and I request for comments
> 1. Daemon should stop in suspend?
> Which level below should a suspended device satisfy?
> 1) No transient data remains (currently OK)
> 2) + No any I/O to the underlying devices?
>    (although it logically irrelevant to the upper layer)
> 3) + No any process execution is admitted to
>    reduce power consumption for example?
> 
> 2. .merge, .hints and .iterate_devices correct?
> What is the correct behavior of these methods?
> 
> static void writeboost_io_hints(struct dm_target *ti,
> 				struct queue_limits *limits)
> {
> 	blk_limits_io_min(limits, 512);
> 	blk_limits_io_opt(limits, 4096);
> }
> 
> static int writeboost_iterate_devices(struct dm_target *ti,
> 				      iterate_devices_callout_fn fn, void *data)
> {
> 	struct wb_device *wb = ti->private;
> 	struct dm_dev *orig = wb->device;
> 	sector_t start = 0;
> 	sector_t len = dm_devsize(orig);
> 	return fn(ti, orig, start, len, data);
> }
> 
> static int writeboost_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> 			    struct bio_vec *biovec, int max_size)
> {
> 	struct wb_device *wb = ti->private;
> 	struct dm_dev *device = wb->device;
> 	struct request_queue *q = bdev_get_queue(device->bdev);
> 
> 	if (!q->merge_bvec_fn)
> 		return max_size;
> 
> 	bvm->bi_bdev = device->bdev;
> 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> }
> 
> 
> Thanks,
> Akira
> 

