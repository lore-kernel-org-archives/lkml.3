Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaCaOV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:21:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44821 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaCaOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:21:57 -0400
Date: Mon, 31 Mar 2014 10:21:53 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Conrad Meyer <cemeyer@uw.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
Message-ID: <20140331102153.476da7b1@m>
In-Reply-To: <87ioqufom3.fsf@devron.myhome.or.jp>
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
	<87ioqufom3.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 23:07:32 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Conrad Meyer <cemeyer@uw.edu> writes:
> 
> > +static void fat_update_archaic_boot_sector(struct
> > super_block *sb,
> > +	struct fat_boot_sector *b)
> > +{
> > +	struct fat_floppy_defaults *di;
> > +	sector_t bd_sects;
> > +
> > +	/* 16-bit DOS 1.x reliably wrote bootstrap
> > short-jmp code */
> > +	if (b->ignored[0] != 0xeb || b->ignored[2] !=
> > 0x90)
> > +		return;
> > +
> > +	/*
> > +	 * If any value in this region is non-zero,
> > don't assume it is archaic
> > +	 * DOS.
> > +	 */
> > +	if (get_unaligned_le16(&b->sector_size) != 0 ||
> > b->sec_per_clus != 0 ||
> > +		b->reserved != 0 || b->fats != 0 ||
> > +		get_unaligned_le16(&b->dir_entries) != 0
> > ||
> > +		get_unaligned_le16(&b->sectors) != 0 ||
> > b->media != 0 ||
> > +		b->fat_length != 0 || b->secs_track != 0
> > || b->heads != 0 ||
> > +		b->secs_track != 0 || b->heads != 0)
> > +		return;
> 
> Probably, too weak detection to use by default. So, how
> about to use mount option to enable this?
> 
> And only if user asked to enable explicitly by mount
> option, allow this format.

Okay. Do you have a preference for option name? "archaicdos",
"dos1x", "guessbpb", other?

> > +	bd_sects =
> > part_nr_sects_read(sb->s_bdev->bd_part);
> > +	for (di = floppy_defaults; di->nr_sectors; di++)
> > {
> > +		if (di->nr_sectors == bd_sects)
> > +			break;
> > +	}
> > +	if (di->nr_sectors == 0) {
> > +		fat_msg(sb, KERN_WARNING,
> > +			"DOS volume lacks BPB and isn't
> > a recognized floppy size (%ld sectors)",
> > +			(long)bd_sects);
> > +		return;
> > +	}
> > +
> > +	fat_msg(sb, KERN_INFO,
> > +		"Volume lacks BPB but looks like archaic
> > DOS; assuming default BPB values"); +
> > +	b->sec_per_clus = di->sec_per_clus;
> > +	put_unaligned_le16(di->dir_entries,
> > &b->dir_entries);
> > +	b->media = di->media;
> > +	b->fat_length = cpu_to_le16(di->fat_length);
> > +	put_unaligned_le16(SECTOR_SIZE, &b->sector_size);
> > +	b->reserved = cpu_to_le16(1);
> > +	b->fats = 2;
> > +	put_unaligned_le16(bd_sects, &b->sectors);
> > +}
> > +
> > +/*
> >   * Read the super block of an MS-DOS FS.
> >   */
> >  int fat_fill_super(struct super_block *sb, void *data,
> > int silent, int isvfat, @@ -1297,6 +1387,8 @@ int
> > fat_fill_super(struct super_block *sb, void *data, int
> > silent, int isvfat, } 
> >  	b = (struct fat_boot_sector *) bh->b_data;
> > +	fat_update_archaic_boot_sector(sb, b);
> 
> This would be better to set sbi->* directly, not via
> modified BPB.

Hm, I thought so too, but there are lots of sbi-> fields and
I didn't want to duplicate any shared filling logic in a
different place. But I will make the change...

> 
> >  	if (!b->reserved) {
> >  		if (!silent)
> >  			fat_msg(sb, KERN_ERR, "bogus
> > number of reserved sectors"); @@ -1364,6 +1456,7 @@ int
> > fat_fill_super(struct super_block *sb, void *data, int
> > silent, int isvfat, goto out_fail; }
> >  		b = (struct fat_boot_sector *)
> > bh->b_data;
> > +		fat_update_archaic_boot_sector(sb, b);
> 
> This doesn't need. If logical_sector_size is 512, this
> format doesn't work.

Right. Okay, give me some time to revise a v3 patch.

Thanks,
Conrad
