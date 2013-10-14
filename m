Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3JNLsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:48:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab3JNLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:48:17 -0400
Date: Mon, 14 Oct 2013 13:48:15 +0200
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?Q?P=E9ter_Andr=E1s_Felv=E9gi?= <petschy@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: udf mount takes forever to fail + proposed solution
Message-ID: <20131014114815.GD19604@quack.suse.cz>
References: <CAG3eYYSNYHaKB8REe_M16tUGC3iNDjLsHES+KvTQXknnWZSGUg@mail.gmail.com>
 <20131011151842.GB27106@quack.suse.cz>
 <CAG3eYYRi=c7-vfkW9zayu4LYv_ty3kXJ8SB4T6pgAyDUXzmcYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG3eYYRi=c7-vfkW9zayu4LYv_ty3kXJ8SB4T6pgAyDUXzmcYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-10-13 23:46:37, Péter András Felvégi wrote:
> OK, I'll prepare a new patch with explicit ID checks (BEA01, BOOT2,
> CDROM, CD001, CDW02, NSR02, NSR03, TEA01, that's all I think) and the
> needed changelog in a few days. Do you think that a hard upper limit
> on the sector offset is desirable? The ISO9660 driver looks for the
> first 100 sectors, but I didn't find anything in the specs suggesting
> a max length for the udf volume recognition area.
  Certainly a bound like 100 sectors would likely be OK as well. But as you
already said, there isn't any such a limit in the spec so we can only guess
which limit to pick... If using fixed strings won't work out, using a limit
like 100 sectors would probably be the next best solution for me.

								Honza

> On 11 October 2013 17:18, Jan Kara <jack@suse.cz> wrote:
> >   Hello,
> >
> > On Thu 10-10-13 23:23:11, Péter András Felvégi wrote:
> >> recently I made the mistake trying to mount an unformatted ssd
> >> partition. The mount command 'hang', was unable to kill it. Top showed
> >> the process is in the uninterruptible D state. However, iotop showed
> >> slight activity, about 4M/s read from the disk that noone else used.
> >> This was 100% reproducible. sync froze, too, if was given out after
> >> the mount cmd. When trying to shut down the machine, it didn't stop,
> >> just waited for something to happen.
> >>
> >> I narrowed down the problem to the UDF filesystem driver. In
> >> fs/udf/super.c, udf_check_vsd() reads the sectors in a for loop, with
> >> the following exit conditions:
> >> - NSR02 or NSR03 descriptor is found
> >> - the read fails
> >> - vsd->stdIdent[0] == 0
> >>
> >> Browsed through the UDF 2.6 spec, ECMA 167 and 119. As I understand,
> >> the descriptors should start at offset 32768, forming a contiguous
> >> sequence. In ECMA 167 it is stated that the sequence is terminated by
> >> an invalid descriptor: unrecorded, or blank (all zeros). However, this
> >> presupposes that the filesystem is UDF.
> >>
> >> Since the ssd partition was not formatted, it contained only 0xff
> >> bytes, thus none of the exit conditions were met, and the function
> >> read through the whole, in two passes. The runtime was pathetic, it
> >> took the mount 350 minutes to fail. I have no clue why this was so
> >> slow, reading through the partition with dd gives 482 secs for the
> >> 220G, ~450M/s. Setting the blocksize to 512 or 2048 didn't make much
> >> of a difference.
> >>
> >> I peppered the code with some messages to see what happens:
> >> # time mount -t udf /dev/sdb3 /media/floppy
> >> UDF-fs: check_vsd: sectorsize=2048
> >> UDF-fs: check_vsd: sector offs=32768, s_blocksize=512, s_blocksize_bits=9
> >> UDF-fs: read 107989660 sectors of total size 55290705920 bytes
> >> UDF-fs: warning (device sdb3): udf_load_vrs: No VRS found
> >> UDF-fs: Rescanning with blocksize 2048
> >> UDF-fs: check_vsd: sectorsize=2048
> >> UDF-fs: check_vsd: sector offs=32768, s_blocksize=2048, s_blocksize_bits=11
> >> UDF-fs: read 107989660 sectors of total size 221162823680 bytes
> >> UDF-fs: warning (device sdb3): udf_load_vrs: No VRS found
> >> UDF-fs: warning (device sdb3): udf_fill_super: No partition found (1)
> >> mount: wrong fs type, bad option, bad superblock on /dev/sdb3,
> >>        missing codepage or helper program, or other error
> >>        In some cases useful info is found in syslog - try
> >>        dmesg | tail  or so
> >> real    352m4.740s
> >> user    0m0.000s
> >> sys     27m23.560s
> >>
> >> Tried to mount other partitions, too, formatted to ext3, ext4, btrfs
> >> and ntfs. The mount failed with those sooner, accidentally just
> >> because there were some blocks near to the beginning with a zero byte
> >> just at the right place.
> >>
> >> Then I prepared an 'all 0xff' 4G image, and burnt it to a DVD. The
> >> mount failed, but took only 25 minutes. 'Only', compared to the case
> >> with the ssd. This truely doesn't reflect the throughput of the
> >> devices, hopefully someone with more experience will have a clue.
> >   Thanks for the report and detailed analysis. Frankly, instead of your
> > function checking the identifier, I'd rather follow the standard in detail
> > and add handling (meaning ignore) of the remaining specified descriptors
> > (CDW02, BOOT2) and bail out if anything else is found. If someone complains
> > because some broken medium stops mounting, we can try something more
> > elaborate but for now I'd go with the simple solution.
> >
> > Also please read Documentation/SubmittingPatches - your patch was missing a
> > changelog entry (you can basically take your somewhat shortened email for
> > that) and a Signed-off-by line. Thanks!
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
