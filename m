Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaBDQmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:42:07 -0500
Received: from sh.osrg.net ([192.16.179.4]:60319 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbaBDQl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:41:57 -0500
Date: Wed, 05 Feb 2014 01:41:37 +0900 (JST)
Message-Id: <20140205.014137.417300930.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Rohner <andreas.rohner@gmx.net>, linux-kernel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 3/4] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20140203133818.5b78761c08846f2d1216b6e2@linux-foundation.org>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1391446244-1435-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140203133818.5b78761c08846f2d1216b6e2@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Wed, 05 Feb 2014 01:41:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014 13:38:18 -0800, Andrew Morton wrote:
> On Tue,  4 Feb 2014 01:50:43 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> From: Andreas Rohner <andreas.rohner@gmx.net>
>> 
>> This patch introduces the nilfs_sufile_set_suinfo function, which
>> expects an array of nilfs_suinfo_update structures and updates the
>> segment usage information accordingly.
>> 
>> This is basically a helper function for the newly introduced
>> NILFS_IOCTL_SET_SUINFO ioctl.
>> 
>> ..
>>
>> --- a/fs/nilfs2/sufile.c
>> +++ b/fs/nilfs2/sufile.c
>> @@ -870,6 +870,137 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
>>  }
>>  
>>  /**
>> + * nilfs_sufile_set_suinfo - sets segment usage info
>> + * @sufile: inode of segment usage file
>> + * @buf: array of suinfo_update
>> + * @supsz: byte size of suinfo_update
>> + * @nsup: size of suinfo_update array
>> + *
>> + * Description: Takes an array of nilfs_suinfo_update structs and updates
>> + * segment usage accordingly. Only the fields indicated by the sup_flags
>> + * are updated.
>> + *
>> + * Return Value: On success, 0 is returned. On error, one of the
>> + * following negative error codes is returned.
>> + *
>> + * %-EIO - I/O error.
>> + *
>> + * %-ENOMEM - Insufficient amount of memory available.
>> + *
>> + * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
>> + */
>> +ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
>> +				unsigned supsz, size_t nsup)
>> +{
>> +	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
>> +	struct buffer_head *header_bh, *bh;
>> +	struct nilfs_suinfo_update *sup, *supend = buf + supsz * nsup;
>> +	struct nilfs_segment_usage *su;
>> +	void *kaddr;
>> +	unsigned long blkoff, prev_blkoff;
>> +	int cleansi, cleansu, dirtysi, dirtysu;
>> +	long ncleaned = 0, ndirtied = 0;
>> +	int ret = 0;
>> +
>> +	if (unlikely(nsup == 0))
>> +		return ret;
>> +
>> +	for (sup = buf; sup < supend; sup = (void *)sup + supsz) {
>> +		if (sup->sup_segnum >= nilfs->ns_nsegments
>> +			|| (sup->sup_flags &
>> +				(~0UL << __NR_NILFS_SUINFO_UPDATE_FIELDS))
>> +			|| (nilfs_suinfo_update_nblocks(sup) &&
>> +				sup->sup_sui.sui_nblocks >
>> +				nilfs->ns_blocks_per_segment))
>> +			return -EINVAL;
>> +	}
>> +
>> +	down_write(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
>> +	if (ret < 0)
>> +		goto out_sem;
>> +
>> +	sup = buf;
>> +	blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>> +	ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
>> +	if (ret < 0)
>> +		goto out_header;
>> +
>> +	for (;;) {
>> +		kaddr = kmap_atomic(bh->b_page);
> 
> Can this buffer_head really be in highmem?

Yes, data blocks of metadata files can be allocated in highmem.  This
buffer head is one of them.

>> +		su = nilfs_sufile_block_get_segment_usage(
>> +			sufile, sup->sup_segnum, bh, kaddr);
> 
> Returns an address wthin the kmapped page.  I really hope
> nilfs_sufile_block_get_segment_usage() cannot return an address outside
> that page - it appears to do quite a lot of unchecked arithmetic which
> is dependent on stuff which was read from the disk.  What it that was
> interfered with or otherwise corrupted?

That's right.  Several range checks looks to be needed, for instance,
for segment usage size, checkpoint size, dat entry size, and inode
size.  I will try to add these missing checks.

>> +		if (nilfs_suinfo_update_lastmod(sup))
>> +			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
>> +
>> +		if (nilfs_suinfo_update_nblocks(sup))
>> +			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
>> +
>> +		if (nilfs_suinfo_update_flags(sup)) {
>> +			/*
>> +			 * Active flag is a virtual flag projected by running
>> +			 * nilfs kernel code - drop it not to write it to
>> +			 * disk.
>> +			 */
>> +			sup->sup_sui.sui_flags &=
>> +					~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
>> +
>> +			cleansi = nilfs_suinfo_clean(&sup->sup_sui);
>> +			cleansu = nilfs_segment_usage_clean(su);
>> +			dirtysi = nilfs_suinfo_dirty(&sup->sup_sui);
>> +			dirtysu = nilfs_segment_usage_dirty(su);
>> +
>> +			if (cleansi && !cleansu)
>> +				++ncleaned;
>> +			else if (!cleansi && cleansu)
>> +				--ncleaned;
>> +
>> +			if (dirtysi && !dirtysu)
>> +				++ndirtied;
>> +			else if (!dirtysi && dirtysu)
>> +				--ndirtied;
>> +
>> +			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
>> +		}
>> +
>> +		kunmap_atomic(kaddr);
> 
> flush_dcache_page()?  Can the page be mapped by userspace?

This page is never mapped to userspace, so flush_dcache_page() looks
unnecessary here.

>> +		sup = (void *)sup + supsz;
>> +		if (sup >= supend)
>> +			break;
>> +
>> +		prev_blkoff = blkoff;
>> +		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>> +		if (blkoff == prev_blkoff)
>> +			continue;
>> +
>> +		/* get different block */
>> +		mark_buffer_dirty(bh);
>> +		brelse(bh);
> 
> put_bh() will suffice - we know bh != NULL.

Agreed.  I will fix it later.

>> +		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
>> +		if (unlikely(ret < 0))
>> +			goto out_mark;
>> +	}
>> +	mark_buffer_dirty(bh);
>> +	brelse(bh);
> 
> ditto

Thank you for your review and comments.

Regards,
Ryusuke Konishi


>> + out_mark:
>> +	if (ncleaned || ndirtied) {
>> +		nilfs_sufile_mod_counter(header_bh, (u64)ncleaned,
>> +				(u64)ndirtied);
>> +		NILFS_SUI(sufile)->ncleansegs += ncleaned;
>> +	}
>> +	nilfs_mdt_mark_dirty(sufile);
>> + out_header:
>> +	brelse(header_bh);
>> + out_sem:
>> +	up_write(&NILFS_MDT(sufile)->mi_sem);
>> +	return ret;
>> +}
>> +
>> +/**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
