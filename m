Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbaGCQ3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:29:32 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:52938 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbaGCQ33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:29:29 -0400
Date: Thu, 3 Jul 2014 18:29:19 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH PING] VFS: mount must return EACCES, not EROFS
Message-ID: <20140703162919.GA16315@frolo.macqel>
References: <20140619230924.GO4453@dastard> <1403253562-29248-1-git-send-email-phdm@macqel.be> <20140627082058.GA24986@frolo.macqel> <20140702124651.38b315a8adce63a37fccc60e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702124651.38b315a8adce63a37fccc60e@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:46:51PM -0700, Andrew Morton wrote:
> On Fri, 27 Jun 2014 10:20:58 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > Currently, the initial mount of the root file system by the linux
> > kernel fails with a cryptic message instead of being retried with
> > the MS_RDONLY flag set,  when the device is read-only and the
> > combination of block driver and filesystem driver yields EROFS.
> > 
> > I do not know if POSIX mandates that mount(2) must fail with EACCES, nor
> > if linux aims to strict compliance with POSIX on that point.  Consensus
> > amongst the messages that I have read so far seems to show that linux
> > kernel hackers feel that EROFS is a more appropriate error code than
> > EACCES in that case.
> 
> Isn't the core problem that "the combination of block driver and
> filesystem driver yields EROFS"?  That the fs should instead be
> returning EACCESS in this case?

Does POSIX or Linux mandate that it should ?

> 
> What fs and block driver are we talking about here, anyway?

The problem happened to me with a f2fs filesystem on a sd-card that was
accidentally write-protected and that was put in a SD-card slot (mmc block
driver).

I retested using mount(8) with a similar now intentionnaly write-protected
sd card in a usb reader (usb_storage driver ?) with vfat, f2fs and ext4
filesystems with the following results :

  mywdesk:~ # strace -e mount mount /dev/sdb1 /mnt
  mount("/dev/sdb1", "/mnt", "vfat", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
  mount: /dev/sdb1 is write-protected, mounting read-only
  mount("/dev/sdb1", "/mnt", "vfat", MS_MGC_VAL|MS_RDONLY, NULL) = 0
  +++ exited with 0 +++
  mywdesk:~ # umount /mnt
  mywdesk:~ # strace -e mount mount -t f2fs /dev/sdb2 /mnt
  mount("/dev/sdb2", "/mnt", "f2fs", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
  mount: /dev/sdb2 is write-protected, mounting read-only
  mount("/dev/sdb2", "/mnt", "f2fs", MS_MGC_VAL|MS_RDONLY, NULL) = 0
  +++ exited with 0 +++
  mywdesk:~ # umount /mnt
  mywdesk:~ # strace -e mount mount /dev/sdb3 /mnt
  mount("/dev/sdb3", "/mnt", "ext4", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
  mount: /dev/sdb3 is write-protected, mounting read-only
  mount("/dev/sdb3", "/mnt", "ext4", MS_MGC_VAL|MS_RDONLY, NULL) = 0
  +++ exited with 0 +++
  mywdesk:~ #

All three file-systems (vfat, f2fs & ext4) yield EROFS.

I also quickly grepped for occurences of EROFS under fs/, and found no check
to replace EROFS by EACCES,
while the same grep under drivers/{block,cdrom,ide,md,memstick, mtd,
s390/block,scsi,usb} gives plenty of "return -EROFS;"

So, if no filesystem driver replaces EROFS by EACCES and many block drivers
return EROFS, it seems to me that many combinations will yield EROFS.

> > 
> > So, do you choose for my first pragmatic and non-intrusive patch, that
> > lets mount_block_root() retry with MS_RDONLY if the file system
> > returns EROFS (https://lkml.org/lkml/2014/6/18/468) or for the second
> > one that forces all file-systems to return EACCES instead of EROFS.
> > (https://lkml.org/lkml/2014/6/20/98).
> 
> They both seem a little hacky to me.

Actually I prefer my first patch, which simply adapts the kernel to the current
situation, like mount(8) already does, instead of trying to impose an ABI
change.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
