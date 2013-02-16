Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3BPPQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 10:16:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3BPPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 10:16:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130201144345.4f5f0d74.akpm@linux-foundation.org>
References: <1359721392-7956-1-git-send-email-ming.lei@canonical.com>
	<20130201144345.4f5f0d74.akpm@linux-foundation.org>
Date: Sat, 16 Feb 2013 23:16:39 +0800
Message-ID: <CACVXFVPt-pJEer-BMdsNPRkLkfrHqWyrTbSOcHLmYJu8uJu5Ng@mail.gmail.com>
Subject: Re: [PATCH v1] block: partition: optimize memory allocation in check_partition
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Felipe Balbi <balbi@ti.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 6:43 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri,  1 Feb 2013 20:23:12 +0800

I just return from holiday, sorry for the delay, and thanks for the review.

> Ming Lei <ming.lei@canonical.com> wrote:
>
>> Currently, sizeof(struct parsed_partitions) may be 64KB in 32bit arch,
>> so it is easy to trigger page allocation failure by check_partition,
>> especially in hotplug block device situation(such as, USB mass storage,
>> MMC card, ...), and Felipe Balbi has observed the failure.
>>
>> This patch does below optimizations on the allocation of struct
>> parsed_partitions to try to address the issue:
>>
>> - make parsed_partitions.parts as pointer so that the pointed memory
>> can fit in 32KB buffer, then approximate 32KB memory can be saved
>>
>> - vmalloc the buffer pointed by parsed_partitions.parts because
>> 32KB is still a bit big for kmalloc
>>
>> - given that many devices have the partition count limit, so only
>> allocate disk_max_parts() partitions instead of 256 partitions
>
> This is only true when !(disk->flags & GENHD_FL_EXT_DEVT) in
> disk_max_parts().  Which I suspect is basically "never".  Oh well.

At first glance, I knew mmc block device don't set the flag. In fact, only
very few block devices have set the flag:

$git grep -n GENHD_FL_EXT_DEVT drivers/
drivers/block/loop.c:1654:      disk->flags |= GENHD_FL_EXT_DEVT;
drivers/ide/ide-gd.c:418:       g->flags |= GENHD_FL_EXT_DEVT;
drivers/md/md.c:4881:   disk->flags |= GENHD_FL_EXT_DEVT;
drivers/scsi/sd.c:2827: gd->flags = GENHD_FL_EXT_DEVT;

>
>> Cc: stable@vger.kernel.org
>
> I don't think I agree with the -stable backport.  The bug isn't
> terribly serious and the patch is far more extensive than it really
> needed to be.
>
> If we do think the fix should be backported then it would be better to
> do it as a series of two patches.  A nice simple one (say, a basic
> s/kmalloc/vmalloc/) for 3.8 and -stable, then a more extensive
> optimise-things patch for 3.9-rc1.

OK, I will remove the stable tag considered that it is not easy to
reproduce.

>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>
> A Reported-by:Felipe would be nice here.  We appreciate bug reports and
> this little gesture is the least we can do.

OK, will add it.

>
>>
>> ...
>>
>>  struct parsed_partitions *
>>  check_partition(struct gendisk *hd, struct block_device *bdev)
>>  {
>>       struct parsed_partitions *state;
>>       int i, res, err;
>>
>> -     state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
>> +     i = disk_max_parts(hd);
>> +     state = allocate_partitions(i);
>>       if (!state)
>>               return NULL;
>> +     state->limit = i;
>
> I suggest this assignment be performed in allocate_partitions() itself.
> That's better than requiring that all allocate_partitions() callers
> remember to fill it in.

OK.

>
>>       state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
>>       if (!state->pp_buf) {
>> -             kfree(state);
>> +             free_partitions(state);
>>               return NULL;
>>       }
>>       state->pp_buf[0] = '\0';
>>
>> ...
>>
>> --- a/block/partitions/check.h
>> +++ b/block/partitions/check.h
>> @@ -15,13 +15,15 @@ struct parsed_partitions {
>>               int flags;
>>               bool has_info;
>>               struct partition_meta_info info;
>> -     } parts[DISK_MAX_PARTS];
>> +     } *parts;
>>       int next;
>>       int limit;
>>       bool access_beyond_eod;
>>       char *pp_buf;
>>  };
>
> With this change, DISK_MAX_PARTS becomes a rather dangerous thing - do
> we have code floating around which does
>
>         for (i = 0; i < DISK_MAX_PARTS; i++)
>                 access(parsed_partitions.parts[i]);
>
> ?
>
> If so, we should do s/DISK_MAX_PARTS/parsed_partitions.limit/.
>
> The only such code I can find is in
> block/partitions/mac.c:mac_partition().  And with your patch, this code
> is potentially buggy, I suspect.  We could do
> s/DISK_MAX_PARTS/state->limit/, but would that work?  What happens if
> disk_max_parts() returned a value which is smaller than blocks_in_map?

IMO, looks it is safe to do s/DISK_MAX_PARTS/state->limit/ for
block/partitions/mac.c:mac_partition(). If the driver sets the
flag of GENHD_FL_EXT_DEVT, the replacement has no effect.
If the flag isn't set, drivers just want to put an limit on access to the
partitions, and device node of the partitions above the limit aren't
visible for users too. So could we do the below replacement?

diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index 11f688b..c7d2da5 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -59,10 +59,12 @@ int mac_partition(struct parsed_partitions *state)
 		return 0;		/* not a MacOS disk */
 	}
 	blocks_in_map = be32_to_cpu(part->map_count);
-	if (blocks_in_map < 0 || blocks_in_map >= DISK_MAX_PARTS) {
+	if (blocks_in_map < 0) {
 		put_dev_sector(sect);
 		return 0;
-	}
+	} else if (blocks_in_map >= state->limit)
+		blocks_in_map = state->limit - 1;
+
 	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
 	for (slot = 1; slot <= blocks_in_map; ++slot) {
 		int pos = slot * secsize;


Thanks,
--
Ming Lei
