Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaGHVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:02:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaGHVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:02:19 -0400
Date: Tue, 8 Jul 2014 14:02:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH PING] VFS: mount must return EACCES, not EROFS
Message-Id: <20140708140218.ce415094dd073a3ddbd98eeb@linux-foundation.org>
In-Reply-To: <20140703162919.GA16315@frolo.macqel>
References: <20140619230924.GO4453@dastard>
	<1403253562-29248-1-git-send-email-phdm@macqel.be>
	<20140627082058.GA24986@frolo.macqel>
	<20140702124651.38b315a8adce63a37fccc60e@linux-foundation.org>
	<20140703162919.GA16315@frolo.macqel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 18:29:19 +0200 Philippe De Muyter <phdm@macqel.be> wrote:

> On Wed, Jul 02, 2014 at 12:46:51PM -0700, Andrew Morton wrote:
> > On Fri, 27 Jun 2014 10:20:58 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> > 
> > > Currently, the initial mount of the root file system by the linux
> > > kernel fails with a cryptic message instead of being retried with
> > > the MS_RDONLY flag set,  when the device is read-only and the
> > > combination of block driver and filesystem driver yields EROFS.
> > > 
> > > I do not know if POSIX mandates that mount(2) must fail with EACCES, nor
> > > if linux aims to strict compliance with POSIX on that point.  Consensus
> > > amongst the messages that I have read so far seems to show that linux
> > > kernel hackers feel that EROFS is a more appropriate error code than
> > > EACCES in that case.
> > 
> > Isn't the core problem that "the combination of block driver and
> > filesystem driver yields EROFS"?  That the fs should instead be
> > returning EACCESS in this case?
> 
> Does POSIX or Linux mandate that it should ?
> 
> > 
> > What fs and block driver are we talking about here, anyway?
> 
> The problem happened to me with a f2fs filesystem on a sd-card that was
> accidentally write-protected and that was put in a SD-card slot (mmc block
> driver).
> 
> I retested using mount(8) with a similar now intentionnaly write-protected
> sd card in a usb reader (usb_storage driver ?) with vfat, f2fs and ext4
> filesystems with the following results :
> 
>   mywdesk:~ # strace -e mount mount /dev/sdb1 /mnt
>   mount("/dev/sdb1", "/mnt", "vfat", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
>   mount: /dev/sdb1 is write-protected, mounting read-only
>   mount("/dev/sdb1", "/mnt", "vfat", MS_MGC_VAL|MS_RDONLY, NULL) = 0
>   +++ exited with 0 +++
>   mywdesk:~ # umount /mnt
>   mywdesk:~ # strace -e mount mount -t f2fs /dev/sdb2 /mnt
>   mount("/dev/sdb2", "/mnt", "f2fs", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
>   mount: /dev/sdb2 is write-protected, mounting read-only
>   mount("/dev/sdb2", "/mnt", "f2fs", MS_MGC_VAL|MS_RDONLY, NULL) = 0
>   +++ exited with 0 +++
>   mywdesk:~ # umount /mnt
>   mywdesk:~ # strace -e mount mount /dev/sdb3 /mnt
>   mount("/dev/sdb3", "/mnt", "ext4", MS_MGC_VAL, NULL) = -1 EROFS (Read-only file system)
>   mount: /dev/sdb3 is write-protected, mounting read-only
>   mount("/dev/sdb3", "/mnt", "ext4", MS_MGC_VAL|MS_RDONLY, NULL) = 0
>   +++ exited with 0 +++
>   mywdesk:~ #
> 
> All three file-systems (vfat, f2fs & ext4) yield EROFS.
> 
> I also quickly grepped for occurences of EROFS under fs/, and found no check
> to replace EROFS by EACCES,
> while the same grep under drivers/{block,cdrom,ide,md,memstick, mtd,
> s390/block,scsi,usb} gives plenty of "return -EROFS;"
> 
> So, if no filesystem driver replaces EROFS by EACCES and many block drivers
> return EROFS, it seems to me that many combinations will yield EROFS.

hm.  I'm thinking that in an ideal world, those block drivers will
return -EACCES rather than -EROFS.  You open() a read-only device for
rw, you get "permission denied".

Al, speak to us.
