Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaC2St4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:49:56 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48110 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaC2Sty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:49:54 -0400
Date: Sat, 29 Mar 2014 14:49:50 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Conrad Meyer <cemeyer@uw.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: FAT: Add support for DOS 1.x formatted volumes
Message-ID: <20140329144950.25f5955e@m>
In-Reply-To: <87mwg8ga75.fsf@devron.myhome.or.jp>
References: <1396045290-9795-1-git-send-email-cse.cem@gmail.com>
	<87mwg8ga75.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2014 02:56:46 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Conrad Meyer <cemeyer@uw.edu> writes:
> 
> Hi,
> 
> > When possible, infer DOS 2.x BIOS Parameter Block from
> > block device geometry (for floppies and floppy images).
> > Update in-memory only. We only perform this update when
> > the entire BPB region is zeroed, like produced by DOS
> > 1.x-era FORMAT (and other OEM variations on DOS).
> >
> > Fixes kernel.org bug #42617.
> >
> > BPB default values are inferred from media size and a
> > table.[0] Media size is assumed to be static for archaic
> > FAT volumes. See also [1].
> >
> > [0]:
> > https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
> > [1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html
> 
> [...]
> 
> > +static void fat_update_archaic_boot_sector(struct
> > super_block *sb,
> > +	struct fat_boot_sector *b)
> > +{
> > +	sector_t bd_sects;
> > +
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
> > +
> > +	bd_sects =
> > part_nr_sects_read(sb->s_bdev->bd_part);
> > +	switch (bd_sects) {
> > +	case 160 * KB_IN_SECTORS:
> > +		b->sec_per_clus = 1;
> > +		put_unaligned_le16(64, &b->dir_entries);
> > +		b->media = 0xFE;
> > +		b->fat_length = cpu_to_le16(1);
> > +		break;
> 
> [...]
> 
> Hm, this looks like check the volume size. But if there is
> newer fat format on same volume size, how to detect it? Or,
> it is conflicting?

Newer fat volumes will have some non-zero values in the BPB
-- see the early return at the top of the update function. So
this code will ignore them.

> 
> [BTW, we should avoid to mount if it doesn't seem fatfs, to
> prevent mis-mount as fatfs (auto mount is depending on this
> detection).]
> 
> Thanks.

Hmm, good point. The checks for zero values in 0x0b through
~0x19 (BPB 2 with some of the BPB 3 fields) should help
prevent conflicts, to some degree. We can also check the
3-byte field "ignored" in struct fat_boot_sector -- it is
commonly "eb xx 90" (x86: JMP [rel8] ; NOP) but can also be
"e9 xx xx xx xx" (x86: JMP [rel32]).

These old floppies were only ever created on 16-bit machines,
so I think we can conditionalize on "eb xx 90". I will fix and
resend.

The first three bytes are on all the images from 1985 I have
are: eb 1c 90.

Here's the full boot sector. Perhaps we can also
conditionalize on the "Not system boot floppy" string?
Probably not, we want to support mounting boot floppies as
well.

0000000: eb1c 9000 0000 0000 0000 0000 0000 0000  ................
0000010: 0000 0000 0000 0000 0000 0000 0000 fa33  ...............3
0000020: c08e d0bc 0006 fb0e e846 00b4 06b0 00b7  .........F......
0000030: 07b9 0000 ba4f 18cd 10b4 02ba 0000 b700  .....O..........
0000040: cd10 beb8 102e 8a04 0ac0 74f9 56b4 0ebb  ..........t.V...
0000050: 0700 cd10 5e46 ebed 074e 6f74 2073 7973  ....^F...Not sys
0000060: 7465 6d20 626f 6f74 2066 6c6f 7070 792e  tem boot floppy.
0000070: 0058 5bba 8b10 8bca 2bd0 d1fa d1fa d1fa  .X[.....+.......
0000080: d1fa 2bda 5351 cb00 0000 0000 0000 0000  ..+.SQ..........

The rest (0x090-0x1ff) is zeroes.

And here's the disassembly of the address signified by "JMP
+0x1c" (0x1e):

0x0000001e	fa	cli
0x0000001f	33c0	xor %ax,%ax
0x00000021	8ed0	mov %ax,%ss
0x00000023	bc0006	mov $0x600,%sp
0x00000026	fb	sti
0x00000027	0e	push %cs
0x00000028	e84600	call func_00000071

Not sure how common that is among FAT images; mkfs.fat does not
appear to generate valid code, other than eb 3c 90 at the
beginning of the sector.

Thanks,
Conrad
