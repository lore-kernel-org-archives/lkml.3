Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaDMMfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:35:48 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46889 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaDMMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:35:46 -0400
Date: Sun, 13 Apr 2014 08:35:43 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] fs: FAT: Add support for DOS 1.x formatted volumes
Message-ID: <20140413083543.2436eee0@m>
In-Reply-To: <87zjjpvq2x.fsf@devron.myhome.or.jp>
References: <1396279369-17855-1-git-send-email-cse.cem@gmail.com>
	<1396315037-12725-1-git-send-email-cse.cem@gmail.com>
	<87zjjpvq2x.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 12:57:42 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Conrad Meyer <cemeyer@uw.edu> writes:
> 
> Hi,
> 
> Sorry for late reply.
> 
> > +
> > +	bd_sects =
> > part_nr_sects_read(sb->s_bdev->bd_part);
> 
> This would be better to use
> i_read_size(&sb->s_bdev->bd_inode->i_size)

Ok, easy to fix.

> 
> > +		if (!fat_bpb_is_zero(b)) {
> > +			fat_msg(sb, KERN_ERR, "%s; DOS
> > 2.x BPB is non-zero",
> > +				notdos1x);
> > +			brelse(bh);
> > +			goto out_invalid;
> > +		}
> 
> Please don't message if silent. While auto detection, user
> don't want to see message from kernel.

Okay, fixed.

> 
> > +	if (sbi->options.dos1xfloppy) {
> > +		/* 16-bit DOS 1.x reliably wrote
> > bootstrap short-jmp code */
> > +		if (b->ignored[0] != 0xeb ||
> > b->ignored[2] != 0x90) {
> > +			fat_msg(sb, KERN_ERR, "%s; no
> > bootstrapping code",
> > +				notdos1x);
> > +			brelse(bh);
> > +			goto out_invalid;
> > +		}
> 
> [...]
> 
> Looks like I was not explain my suggestion correctly. I was
> intended to allow dos1xfloppy by option, not allow
> dos1xfloppy only.
> 
> I.e.
> 
> 	err = read-from-bpb();
> 	if (err == -ENOTFATFS)
> 		if (dos1xfloppy)
> 			err = read-from-static-bpb();
> 	if (err)
> 		goto error;
> 
> > +	if (sbi->options.dos1xfloppy)
> > +		total_sectors = fdefaults->nr_sectors;
> > +	else
> > +		total_sectors =
> > get_unaligned_le16(&b->sectors); if (total_sectors == 0)
> >  		total_sectors =
> > le32_to_cpu(b->total_sect);
> 
> Can we make 2 helpers to read from BPB and static BPB? If
> possible, we would not be bothered by if (dos1xfloppy),
> like above crappy pseudo.
> 
> Thanks.


We would have to duplicate, replace, or skip large parts of
fat_fill_super(). This is why my initial approach was to just
fill in BPB values in the SB copy in memory. We read from BPB
over the course of 215 lines of code, ending here:

> @@ -1527,7 +1659,10 @@ int fat_fill_super(struct
> super_block *sb, void *data, int silent, int isvfat,
> rootdir_sectors = sbi->dir_entries
>  		* sizeof(struct msdos_dir_entry) /
> sb->s_blocksize; sbi->data_start = sbi->dir_start +
> rootdir_sectors;
> -	total_sectors = get_unaligned_le16(&b->sectors);
> +	if (sbi->options.dos1xfloppy)
> +		total_sectors = fdefaults->nr_sectors;
> +	else
> +		total_sectors =
> get_unaligned_le16(&b->sectors); if (total_sectors == 0)
>  		total_sectors =
> le32_to_cpu(b->total_sect); 


I will make an attempt at it.

Thanks,
Conrad
