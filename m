Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3GQUfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:35:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3GQUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:35:29 -0400
Date: Wed, 17 Jul 2013 13:35:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-Id: <20130717133527.32772c099b8b1c67729dae0e@linux-foundation.org>
In-Reply-To: <1373316896-6045-2-git-send-email-maximlevitsky@gmail.com>
References: <1373292716.32554.5.camel@maxim-laptop>
	<1373316896-6045-1-git-send-email-maximlevitsky@gmail.com>
	<1373316896-6045-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Jul 2013 23:54:55 +0300 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Based partially on MS standard spec quotes from Alex Dubov.
> 
> As any code that works with user data this driver isn't
> recommended to use to write cards that contain valuable data.
> 
> It tries its best though to avoid data corruption
> and possible damage to the card.
> 
> Tested on MS DUO 64 MB card on Ricoh R592 card reader.
> 
> ...
>
> +config MS_BLOCK
> +	tristate "MemoryStick Standard device driver"
> +	depends on BLOCK
> +	help
> +	  Say Y here to enable the MemoryStick Standard device driver
> +	  support. This provides a block device driver, which you can use
> +	  to mount the filesystem.
> +	  This driver works with old (bulky) MemoryStick and MemoryStick Duo
> +	  but not PRO. Say Y if you have such card.
> +	  Driver is new and not yet well tested, thus it can damage your card
> +	  (even permanently)

Yikes.  How true is this?

> 
> ...
>
> +static size_t msb_sg_copy(struct scatterlist *sg_from,
> +	struct scatterlist *sg_to, int to_nents, size_t offset, size_t len)
> +{
> +	size_t copied = 0;
> +
> +	while (offset > 0) {
> +		if (offset >= sg_from->length) {
> +			if (sg_is_last(sg_from))
> +				return 0;
> +
> +			offset -= sg_from->length;
> +			sg_from = sg_next(sg_from);
> +			continue;
> +		}
> +
> +		copied = min(len, sg_from->length - offset);
> +		sg_set_page(sg_to, sg_page(sg_from),
> +			copied, sg_from->offset + offset);
> +
> +		len -= copied;
> +		offset = 0;
> +
> +		if (sg_is_last(sg_from) || !len)
> +			goto out;
> +
> +		sg_to = sg_next(sg_to);
> +		to_nents--;
> +		sg_from = sg_next(sg_from);
> +	}
> +
> +	while (len > sg_from->length && to_nents--) {
> +		len -= sg_from->length;
> +		copied += sg_from->length;
> +
> +		sg_set_page(sg_to, sg_page(sg_from),
> +				sg_from->length, sg_from->offset);
> +
> +		if (sg_is_last(sg_from) || !len)
> +			goto out;
> +
> +		sg_from = sg_next(sg_from);
> +		sg_to = sg_next(sg_to);
> +	}
> +
> +	if (len && to_nents) {
> +		sg_set_page(sg_to, sg_page(sg_from), len, sg_from->offset);
> +		copied += len;
> +	}
> +out:
> +	sg_mark_end(sg_to);
> +	return copied;
> +}

There's nothing memstick-specific about this.  Did you consider placing
it in lib/?


> +/*
> + * Compares section of 'sg' starting from offset 'offset' and with length 'len'
> + * to linear buffer of length 'len' at address 'buffer'
> + * Returns 0 if equal and  -1 otherwice
> + */
> +static int msb_sg_compare_to_buffer(struct scatterlist *sg,
> +					size_t offset, u8 *buffer, size_t len)
> +{
> +	int retval = 0, cmplen;
> +	struct sg_mapping_iter miter;
> +
> +	sg_miter_start(&miter, sg, sg_nents(sg),
> +					SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +
> +	while (sg_miter_next(&miter) && len > 0) {
> +		if (offset >= miter.length) {
> +			offset -= miter.length;
> +			continue;
> +		}
> +
> +		cmplen = min(miter.length - offset, len);
> +		retval = memcmp(miter.addr + offset, buffer, cmplen) ? -1 : 0;
> +		if (retval)
> +			break;
> +
> +		buffer += cmplen;
> +		len -= cmplen;
> +		offset = 0;
> +	}
> +
> +	if (!retval && len)
> +		retval = -1;
> +
> +	sg_miter_stop(&miter);
> +	return retval;
> +}

And this, perhaps.

> 
> ...
>
> +static void msb_mark_block_used(struct msb_data *msb, int pba)
> +{
> +	int zone = msb_get_zone_from_pba(pba);
> +
> +	if (test_bit(pba, msb->used_blocks_bitmap)) {
> +		pr_err(
> +		"BUG: attempt to mark already used pba %d as used", pba);
> +		msb->read_only = true;
> +		return;
> +	}
> +
> +	if (msb_validate_used_block_bitmap(msb))
> +		return;
> +
> +	/* No races because all IO is single threaded */

What guarantees that all IO is single threaded?  Big lock?  All done by
a single kernel thread?

> +	__set_bit(pba, msb->used_blocks_bitmap);
> +	msb->free_block_count[zone]--;
> +}
> +
> 
> ...
>
> +static int msb_read_int_reg(struct msb_data *msb, long timeout)
> +{
> +	struct memstick_request *mrq = &msb->card->current_mrq;
> +
> +	WARN_ON(msb->state == -1);
> +
> +	if (!msb->int_polling) {
> +		msb->int_timeout = jiffies +
> +			msecs_to_jiffies(timeout == -1 ? 500 : timeout);

All callers pass timeout=-1, so there's some pointless code here.

> +		msb->int_polling = true;
> +	} else if (time_after(jiffies, msb->int_timeout)) {
> +		mrq->data[0] = MEMSTICK_INT_CMDNAK;
> +		return 0;
> +	}
> +
> +	if ((msb->caps & MEMSTICK_CAP_AUTO_GET_INT) &&
> +				mrq->need_card_int && !mrq->error) {
> +		mrq->data[0] = mrq->int_reg;
> +		mrq->need_card_int = false;
> +		return 0;
> +	} else {
> +		memstick_init_req(mrq, MS_TPC_GET_INT, NULL, 1);
> +		return 1;
> +	}
> +}

Generally speaking, one wya in whcih kernel code gets real confusing
real fast is when it uses a mixture of time units: jiffies and
milliseconds and seconds, etc.  This code falls into that trap, a
little bit.  One really good way to clarify things is to embed the
units within the variable names.  So s/timeout/timeout_ms/ and
s/int_timeout/int_timeout_jifs/ would be good.

> 
> ...
>
> +static int msb_switch_to_parallel(struct msb_data *msb)
> +{
> +	int error;
> +
> +	error = msb_run_state_machine(msb, h_msb_parallel_switch);
> +	if (error) {
> +		pr_err("Switch to parallel failed");

Might want to display the value of `error' here.

> +		msb->regs.param.system &= ~MEMSTICK_SYS_PAM;
> +		msb_reset(msb, true);
> +		return -EFAULT;

EFAULT is just wrong, surely.  Can't we propagate `error' here?

> +	}
> +
> +	msb->caps |= MEMSTICK_CAP_AUTO_GET_INT;
> +	return 0;
> +}
> +
> 
> ...
>
> +static u16 msb_get_free_block(struct msb_data *msb, int zone)
> +{
> +	u16 pos;
> +	int pba = zone * MS_BLOCKS_IN_ZONE;
> +	int i;
> +
> +	get_random_bytes(&pos, sizeof(pos));

This isn't good.  get_random_bytes() is the high-quality random number
generator.  If memstick calls this frequently it will degrade the
entropy pool, thus impacting the quality (ie: security) of key
generation, TCP sequence numbers, etc.  It's also slow.

Do you really require cryptographic quality randomness here, or would
prandom_bytes() suffice?

> +	if (!msb->free_block_count[zone]) {
> +		pr_err("NO free blocks in the zone %d, to use for a write, (media is WORN out) switching to RO mode", zone);
> +		msb->read_only = true;
> +		return MS_BLOCK_INVALID;
> +	}
> +
> +	pos %= msb->free_block_count[zone];
> +
> +	dbg_verbose("have %d choices for a free block, selected randomally: %d",
> +		msb->free_block_count[zone], pos);
> +
> +	pba = find_next_zero_bit(msb->used_blocks_bitmap,
> +							msb->block_count, pba);
> +	for (i = 0; i < pos; ++i)
> +		pba = find_next_zero_bit(msb->used_blocks_bitmap,
> +						msb->block_count, pba + 1);
> +
> +	dbg_verbose("result of the free blocks scan: pba %d", pba);
> +
> +	if (pba == msb->block_count || (msb_get_zone_from_pba(pba)) != zone) {
> +		pr_err("BUG: cant get a free block");
> +		msb->read_only = true;
> +		return MS_BLOCK_INVALID;
> +	}
> +
> +	msb_mark_block_used(msb, pba);
> +	return pba;
> +}
> 
> ...
>
> +static int msb_cache_write(struct msb_data *msb, int lba,
> +	int page, bool add_to_cache_only, struct scatterlist *sg, int offset)
> +{
> +	int error;
> +	struct scatterlist sg_tmp[10];

That's a lot of stack.

> +
> +	if (msb->read_only)
> +		return -EROFS;
> +
> +	if (msb->cache_block_lba == MS_BLOCK_INVALID ||
> +						lba != msb->cache_block_lba)
> +		if (add_to_cache_only)
> +			return 0;
> +
> +	/* If we need to write different block */
> +	if (msb->cache_block_lba != MS_BLOCK_INVALID &&
> +						lba != msb->cache_block_lba) {
> +		dbg_verbose("first flush the cache");
> +		error = msb_cache_flush(msb);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (msb->cache_block_lba  == MS_BLOCK_INVALID) {
> +		msb->cache_block_lba  = lba;
> +		mod_timer(&msb->cache_flush_timer,
> +			jiffies + msecs_to_jiffies(cache_flush_timeout));
> +	}
> +
> +	dbg_verbose("Write of LBA %d page %d to cache ", lba, page);
> +
> +	sg_init_table(sg_tmp, ARRAY_SIZE(sg_tmp));
> +	msb_sg_copy(sg, sg_tmp, ARRAY_SIZE(sg_tmp), offset, msb->page_size);
> +
> +	sg_copy_to_buffer(sg_tmp, sg_nents(sg_tmp),
> +		msb->cache + page * msb->page_size, msb->page_size);
> +
> +	set_bit(page, &msb->valid_cache_bitmap);
> +	return 0;
> +}
> 
> ...
>
> +static int msb_bd_open(struct block_device *bdev, fmode_t mode)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	struct msb_data *msb = disk->private_data;
> +
> +	dbg_verbose("block device open");
> +
> +	mutex_lock(&msb_disk_lock);
> +
> +	if (msb && msb->card)
> +		msb->usage_count++;

hm, what are we refcounting here?  Unfortunately the rather important
msb_data is undocumented :(  What is an msb_data?

> +	mutex_unlock(&msb_disk_lock);
> +	return 0;
> +}
> +
> 
> ...
>

