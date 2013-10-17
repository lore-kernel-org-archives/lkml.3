Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3JQK14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:27:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3JQK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:27:53 -0400
Date: Thu, 17 Oct 2013 12:27:52 +0200
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?Q?P=E9ter_Andr=E1s_Felv=E9gi?= <petschy@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: fix for pathetic mount times in case of invalid
 file system
Message-ID: <20131017102752.GA5600@quack.suse.cz>
References: <CAG3eYYT_1YA+jpj68CuDUTmoe_0WgqxjZ1ser3oYVUCy4XsYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG3eYYT_1YA+jpj68CuDUTmoe_0WgqxjZ1ser3oYVUCy4XsYkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-10-13 00:36:41, Péter András Felvégi wrote:
> From: Peter A. Felvegi <petschy@gmail.com>
> 
> The UDF driver was not strict enough about checking the IDs in the
> VSDs when mounting, which resulted in reading through all the sectors
> of the block device in some unfortunate cases. Eg, trying to mount my
> uninitialized 200G SSD partition (all 0xFF bytes) took ~350 minutes to
> fail, because the code expected some of the valid IDs or a zero byte.
> During this, the mount couldn't be killed, sync from the cmdline
> blocked, and the machine froze into the shutdown. Valid filesystems
> (extX, btrfs, ntfs) were rejected by the mere accident of having a
> zero byte at just the right place in some of their sectors, close
> enough to the beginning not to generate excess I/O. The fix adds a
> hard limit on the VSD sector offset, adds the two missing VSD IDs, and
> stops scanning when encountering an invalid ID. Also replaced the
> magic number 32768 with a more meaningful #define, and supressed the
> bogus message about failing to read the first sector if no UDF fs was
> detected.
  Thanks for the patch. The code looks good but the patch got mangled by
your mailer (lines are wrapped, tabs converted to spaces). Can you please
send the patch as an attachment to avoid this? Also I've noticed you didn't
quite follow the rule of max 80 characters per line so can you please
update your patch to follow this rule? Thanks!

								Honza
> 
> Signed-off-by: Peter A. Felvegi <petschy@gmail.com>
> ---
> The fix was developed for 3.9.4, and applies to 3.12-rc3, too.
> 
> --- linux.git/fs/udf/super.c.orig    2013-10-16 23:23:33.000000000 +0200
> +++ linux.git/fs/udf/super.c    2013-10-16 23:27:21.000000000 +0200
> @@ -76,6 +76,9 @@
> 
>  #define UDF_DEFAULT_BLOCKSIZE 2048
> 
> +#define VSD_FIRST_SECTOR_OFFSET        32768
> +#define VSD_MAX_SECTOR_OFFSET        0x800000
> +
>  enum { UDF_MAX_LINKS = 0xffff };
> 
>  /* These are the "meat" - everything else is stuffing */
> @@ -672,7 +675,7 @@ out_unlock:
>  static loff_t udf_check_vsd(struct super_block *sb)
>  {
>      struct volStructDesc *vsd = NULL;
> -    loff_t sector = 32768;
> +    loff_t sector = VSD_FIRST_SECTOR_OFFSET;
>      int sectorsize;
>      struct buffer_head *bh = NULL;
>      int nsr02 = 0;
> @@ -690,8 +693,14 @@ static loff_t udf_check_vsd(struct super
>      udf_debug("Starting at sector %u (%ld byte sectors)\n",
>            (unsigned int)(sector >> sb->s_blocksize_bits),
>            sb->s_blocksize);
> -    /* Process the sequence (if applicable) */
> -    for (; !nsr02 && !nsr03; sector += sectorsize) {
> +    /* Process the sequence (if applicable). The hard limit on the
> sector offset is arbitrary,
> +     * hopefully large enough so that all valid UDF filesystems will
> be recognised. There is no
> +     * mention of an upper bound to the size of the volume
> recognition area in the standard.
> +     *  The limit will prevent the code to read all the sectors of a
> specially crafted image
> +     * (like a bluray disc full of CD001 sectors), potentially
> causing minutes or even hours of
> +     * uninterruptible I/O activity. This actually happened with
> uninitialised SSD partitions
> +     * (all 0xFF) before the check for the limit and all valid IDs
> were added */
> +    for (; !nsr02 && !nsr03 && sector < VSD_MAX_SECTOR_OFFSET; sector
> += sectorsize) {
>          /* Read a block */
>          bh = udf_tread(sb, sector >> sb->s_blocksize_bits);
>          if (!bh)
> @@ -701,10 +710,7 @@ static loff_t udf_check_vsd(struct super
>          vsd = (struct volStructDesc *)(bh->b_data +
>                            (sector & (sb->s_blocksize - 1)));
> 
> -        if (vsd->stdIdent[0] == 0) {
> -            brelse(bh);
> -            break;
> -        } else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001,
> +        if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001,
>                      VSD_STD_ID_LEN)) {
>              switch (vsd->structType) {
>              case 0:
> @@ -740,6 +746,17 @@ static loff_t udf_check_vsd(struct super
>          else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03,
>                      VSD_STD_ID_LEN))
>              nsr03 = sector;
> +        else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BOOT2,
> +                    VSD_STD_ID_LEN))
> +            ; /* nothing */
> +        else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CDW02,
> +                    VSD_STD_ID_LEN))
> +            ; /* nothing */
> +        else {
> +            /* invalid id : end of volume recognition area */
> +            brelse(bh);
> +            break;
> +        }
>          brelse(bh);
>      }
> 
> @@ -747,7 +764,7 @@ static loff_t udf_check_vsd(struct super
>          return nsr03;
>      else if (nsr02)
>          return nsr02;
> -    else if (sector - (sbi->s_session << sb->s_blocksize_bits) == 32768)
> +    else if (!bh && sector - (sbi->s_session << sb->s_blocksize_bits)
> == VSD_FIRST_SECTOR_OFFSET)
>          return -1;
>      else
>          return 0;
> @@ -1239,6 +1256,9 @@ static int udf_load_partdesc(struct supe
>       * PHYSICAL partitions are already set up
>       */
>      type1_idx = i;
> +#ifdef UDFFS_DEBUG
> +    map = NULL; /* supress 'maybe used uninitialized' warning */
> +#endif
>      for (i = 0; i < sbi->s_partitions; i++) {
>          map = &sbi->s_partmaps[i];
> 
> @@ -1819,7 +1839,7 @@ static int udf_load_vrs(struct super_blo
>              return 0;
>          }
>          if (nsr_off == -1)
> -            udf_debug("Failed to read byte 32768. Assuming open disc.
> Skipping validity check\n");
> +            udf_debug("Failed to read sector at offset %d. Assuming
> open disc. Skipping validity check\n", VSD_FIRST_SECTOR_OFFSET);
>          if (!sbi->s_last_block)
>              sbi->s_last_block = udf_get_last_block(sb);
>      } else {
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
