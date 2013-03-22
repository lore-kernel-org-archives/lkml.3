Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3CVDA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:00:59 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59144 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3CVDAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:00:51 -0400
Date: Thu, 21 Mar 2013 22:00:46 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
To: William Hubbs <williamh@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org, ryao@gentoo.org, gregkh@gentoo.org,
        torvalds@linux-foundation.org, w.d.hubbs@gmail.com
In-Reply-To: <20130320211125.GA26595@linux1> (from williamh@gentoo.org on
	Wed Mar 20 16:11:25 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363921246.15703.54@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 04:11:25 PM, William Hubbs wrote:
> On Wed, Mar 20, 2013 at 02:03:20AM -0500, Rob Landley wrote:
> > On 03/19/2013 07:20:17 PM, William Hubbs wrote:
> > > On Tue, Mar 19, 2013 at 04:17:11PM -0700, H. Peter Anvin wrote:
> > > > On 03/19/2013 03:28 PM, William Hubbs wrote:
> > > > > The issue is that /dev/root appears in /proc/mounts if you do  
> not
> > > > > boot with an initramfs, but /dev/root is not a device node.  
> In the
> > > > > past, udev created a symbolic link from /dev/root to the
> > > > > appropriate block device, but it does not do this any longer.
> > > Also,
> > > > > devtmpfs does not create this symbolic link.
> > > > >
> > > > > This is causing bugs with software that depends on the  
> existence
> > > > > of /dev/root [2] for example.
> > > >
> > > > Seems okay to me, although even better would be to use the udev  
> name
> > > > of the device in question.
> > >
> > > I'm not following what you mean.
> > >
> > > The problem is that "/dev/root" should not be in /proc/mounts,
> > > since there is always another entry that points to the root
> > > file system.
> >
> > What gave you that idea?
> >
> > wget http://landley.net/aboriginal/bin/system-image-i686.tar.bz2
> > extract it and ./run-emulator.sh and in there:
> >
> > (i686:1) /home # cat /proc/mounts
> > rootfs / rootfs rw 0 0
> > /dev/root / squashfs ro,relatime 0 0
> > proc /proc proc rw,relatime 0 0
> > sys /sys sysfs rw,relatime 0 0
> > dev /dev devtmpfs rw,relatime,size=63072k,nr_inodes=15768,mode=755  
> 0 0
> > dev/pts /dev/pts devpts rw,relatime,mode=600 0 0
> > /tmp /tmp tmpfs rw,relatime 0 0
> > /home /home tmpfs rw,relatime 0 0
> >
> > Userspace can totally determine what /dev/root points to, I made  
> mdev
> > do it in 2006 (udev started doing so shortly thereafter). Busybox  
> git
> > commit a7e3d052.:4
> 
> There are situations where it doesn't work though -- suppose that root
> is btrfs for example.

So you're saying there's a bug in btrfs?

> Also, the other message that answered you is correct, the udev
> maintainers say we should not be relying on /dev/root at all so to  
> make
> it work distro packagers have to add a rule themselves.

These udev maintainers?

   http://lkml.indiana.edu/hypermail/linux/kernel/1210.0/01889.html

This is the udev that got Katamari'd into systemd, not one of the forks  
that ran screaming trying not to get sucked into the latest escapade of  
King of All Cosmos?

Look, if you want to add /dev/root to devtmpfs, that makes a certain  
amount of sense. But your patch seems to have missed do_mounts.c doing:

   if (strncmp(root_device_name, "/dev/", 5) == 0)
     root_device_name += 5;

Which means that if the user does "root=sda1" on the kernel command  
line you're not passing an absolute path to create_dev():

-	create_dev("/dev/root", ROOT_DEV);
-	mount_block_root("/dev/root", root_mountflags);
+	if (saved_root_name[0]) {
+		create_dev(saved_root_name, ROOT_DEV);

And last I checked that means /proc/mounts will have a relative path in  
it...

I.E. you're modifying kernel code you're not familiar with to fix a  
non-problem caused by your unfamiliarity with the corresponding  
userspace code. I'm really not seeing the upside here.

Rob