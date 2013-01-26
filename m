Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3AZNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:22:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33106 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3AZNWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:22:34 -0500
Date: Sat, 26 Jan 2013 14:22:32 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, help-grub@gnu.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: usb storage: FATAL DATA CORRUPTION due to innocuous reboot!?
Message-ID: <20130126132232.GA18715@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after my recent tirade of very poor device support of Aspire One,
I now experienced something a lot worse (bad karma? ;-P):
basically my entire ext4 root partition got blewn into shreds
(corruption is so pervasive that I'm afraid recovery will fail).

I am (was) running 3.7.0, and decided to upgrade to current (-rc4+).
Thus I did grub-mkconfig and more or less immediately rebooted.
Realized that I had failed to copy vmlinuz to /boot's bzImage
(i.e. new boot entry was missing), rebooted and redid that,
re-ran grub-mkconfig and rebooted more or less immediately.

After the first grub-mkconfig GRUB2 was still fine,
being able to boot the existing kernel.
Exactly directly after the second reboot (post-grub-mkconfig)
all hell broke lose, with GRUB2 complaining about "invalid extent"
and a subsequent fsck.ext4 spewing tons of pages of errors.

I'm using the infamous JMF601 SSD controller, USB-connected
(root device).
Cannot provide details of grub package version since root partition is toast.

Note that the first inode that fsck complained about was 262144, i.e.
0x40000 i.e. 256kB i.e. most certainly directly at a boundary of
erase block size. IOW, the corruption is very likely to have been
produced by coarse erase block related activity and *not* by any interim
merging of *partial* data updates.


While of course the corruption may have happened due to a questionable
device, I now have a hunch that this unspeakable mess has been caused by
the reboot happening too early (while the SSD was still writing data,
probably by having to actively and painfully erase formerly used blocks, too).
If the reboot happened too early, this would probably mean
that USB port power during reboot got lost too early,
thus the controller lost power during ongoing data updates.
If the controller's operation happens to be implemented
in a not fully atomic way (as is somewhat likely given JMF601's reputation),
then this means data corruption, plenty.

Thus I started to investigate about the kernel's device consistency guarantees
upon reboot.
Note that reboot(8) says:
"
       The -h flag puts all hard disks in standby mode  just  before
halt  or
       power-off.  Right  now  this is only implemented for IDE drives.
A side
       effect of putting the drive in stand-by mode is that the write
cache on
       the disk is flushed. This is important for IDE drives, since the
kernel
       doesn't flush the write cache itself before power-off.
"
Excuse me!?
Why wouldn't the kernel be responsible to take care to flush things
prior to power-off?

Also,
http://linux.die.net/man/8/sync
(a possibly old/irrelevant source) says:
"The reboot(8) and halt(8) commands take this into account by sleeping
for a few seconds after calling sync(2)"

Please forgive me for a second that I'm *very* puzzled why
it would be the reboot binary's job to do a delay to ensure
properly completed syncing/flushing of the storage devices.
After all it's quite arguably definitely the *kernel*'s job
to govern device-specific flush delay requirements (only the kernel
knows which particular device may have certain particularly special
manual delay requirements, and all that a userspace binary ought
to do is to issue a *client request* for a reboot).


Please note that the sync binary is only about syncing filesystem-related parts,
i.e. it does NOT seem to be responsible for the (much more important!!)
non-fs parts such as the things updated by GRUB (is this the hole that
I'm seeing here?).

So, to have a short list:
- I suspect improper sync/flush handling prior to reboot
  (which likely eventually leads to the obviously fatal USB port poweroff)
- it's possibly the case that sync handling is sufficient to handle FS parts
  but not the even more critical non-FS parts (bootloader)
- kernel might actually do a proper sync/flush of *all* device parts,
  but device may fail to obey it

If it in fact is a problem specific to this device,
then it might be conceivable to introduce a new USB storage quirk flag
for devices with broken flush which would add an arbitrary pre-reboot delay
of perhaps 10 seconds.
If the kernel has a last-write-at timestamp per block device
(which it arguably should maintain), then this could be used to
shorten the delay to the time remaining since last write
(which also would allow to prolong the total delay to 20 seconds).

Questions:
- should I file a kernel bug report about this issue?
- did anyone experience anything similar? (research didn't
manage to locate much so far)
- if my thoughts are correct (about storage quirk), how to implement it?
- any other hints/ideas?


I have to admit that all these way too many kernel "features"
are really adding up going on my nerves (Alan Cox, anyone?).
If this keeps going on, then I *will* be forced to bail out, hard.

Thanks,

Andreas Mohr
