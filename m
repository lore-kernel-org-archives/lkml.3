Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3BAWns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:43:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3BAWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:43:46 -0500
Date: Fri, 1 Feb 2013 14:43:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Felipe Balbi <balbi@ti.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] block: partition: optimize memory allocation in
 check_partition
Message-Id: <20130201144345.4f5f0d74.akpm@linux-foundation.org>
In-Reply-To: <1359721392-7956-1-git-send-email-ming.lei@canonical.com>
References: <1359721392-7956-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Feb 2013 20:23:12 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> Currently, sizeof(struct parsed_partitions) may be 64KB in 32bit arch,
> so it is easy to trigger page allocation failure by check_partition,
> especially in hotplug block device situation(such as, USB mass storage,
> MMC card, ...), and Felipe Balbi has observed the failure.
> 
> This patch does below optimizations on the allocation of struct
> parsed_partitions to try to address the issue:
> 
> - make parsed_partitions.parts as pointer so that the pointed memory
> can fit in 32KB buffer, then approximate 32KB memory can be saved
> 
> - vmalloc the buffer pointed by parsed_partitions.parts because
> 32KB is still a bit big for kmalloc
> 
> - given that many devices have the partition count limit, so only
> allocate disk_max_parts() partitions instead of 256 partitions

This is only true when !(disk->flags & GENHD_FL_EXT_DEVT) in
disk_max_parts().  Which I suspect is basically "never".  Oh well.

> Cc: stable@vger.kernel.org

I don't think I agree with the -stable backport.  The bug isn't
terribly serious and the patch is far more extensive than it really
needed to be.

If we do think the fix should be backported then it would be better to
do it as a series of two patches.  A nice simple one (say, a basic
s/kmalloc/vmalloc/) for 3.8 and -stable, then a more extensive
optimise-things patch for 3.9-rc1.

> Signed-off-by: Ming Lei <ming.lei@canonical.com>

A Reported-by:Felipe would be nice here.  We appreciate bug reports and
this little gesture is the least we can do.

>
> ...
>
>  struct parsed_partitions *
>  check_partition(struct gendisk *hd, struct block_device *bdev)
>  {
>  	struct parsed_partitions *state;
>  	int i, res, err;
>  
> -	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
> +	i = disk_max_parts(hd);
> +	state = allocate_partitions(i);
>  	if (!state)
>  		return NULL;
> +	state->limit = i;

I suggest this assignment be performed in allocate_partitions() itself.
That's better than requiring that all allocate_partitions() callers
remember to fill it in.


>  	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
>  	if (!state->pp_buf) {
> -		kfree(state);
> +		free_partitions(state);
>  		return NULL;
>  	}
>  	state->pp_buf[0] = '\0';
>
> ...
>
> --- a/block/partitions/check.h
> +++ b/block/partitions/check.h
> @@ -15,13 +15,15 @@ struct parsed_partitions {
>  		int flags;
>  		bool has_info;
>  		struct partition_meta_info info;
> -	} parts[DISK_MAX_PARTS];
> +	} *parts;
>  	int next;
>  	int limit;
>  	bool access_beyond_eod;
>  	char *pp_buf;
>  };

With this change, DISK_MAX_PARTS becomes a rather dangerous thing - do
we have code floating around which does

	for (i = 0; i < DISK_MAX_PARTS; i++)
		access(parsed_partitions.parts[i]);

?

If so, we should do s/DISK_MAX_PARTS/parsed_partitions.limit/.

The only such code I can find is in
block/partitions/mac.c:mac_partition().  And with your patch, this code
is potentially buggy, I suspect.  We could do
s/DISK_MAX_PARTS/state->limit/, but would that work?  What happens if
disk_max_parts() returned a value which is smaller than blocks_in_map?

It needs some thought.  I'm reluctant to apply this version of the
patch due to this.

>
> ...
>

