Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3CTVrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:47:16 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49076 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3CTVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130320211125.GA26595@linux1>
References: <20130320002017.GA2810@linux1> <1363763000.15703.47@driftwood> <20130320211125.GA26595@linux1>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 20 Mar 2013 22:46:53 +0100
Message-ID: <CAPXgP11A1awkrkdDyNUgw7oHtNax144KpyrHQ1iUzC2__ScP_A@mail.gmail.com>
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
To: William Hubbs <williamh@gentoo.org>
Cc: Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, mpagano@gentoo.org, ryao@gentoo.org,
        gregkh@gentoo.org, torvalds@linux-foundation.org, w.d.hubbs@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 10:11 PM, William Hubbs <williamh@gentoo.org> wrote:
> On Wed, Mar 20, 2013 at 02:03:20AM -0500, Rob Landley wrote:
>> On 03/19/2013 07:20:17 PM, William Hubbs wrote:
>> > On Tue, Mar 19, 2013 at 04:17:11PM -0700, H. Peter Anvin wrote:
>> > > On 03/19/2013 03:28 PM, William Hubbs wrote:
>> > > > The issue is that /dev/root appears in /proc/mounts if you do not
>> > > > boot with an initramfs, but /dev/root is not a device node. In the
>> > > > past, udev created a symbolic link from /dev/root to the
>> > > > appropriate block device, but it does not do this any longer.
>> > Also,
>> > > > devtmpfs does not create this symbolic link.
>> > > >
>> > > > This is causing bugs with software that depends on the existence
>> > > > of /dev/root [2] for example.
>> > >
>> > > Seems okay to me, although even better would be to use the udev name
>> > > of the device in question.
>> >
>> > I'm not following what you mean.
>> >
>> > The problem is that "/dev/root" should not be in /proc/mounts,
>> > since there is always another entry that points to the root
>> > file system.
>>
>> What gave you that idea?
>>
>> wget http://landley.net/aboriginal/bin/system-image-i686.tar.bz2
>> extract it and ./run-emulator.sh and in there:
>>
>> (i686:1) /home # cat /proc/mounts
>> rootfs / rootfs rw 0 0
>> /dev/root / squashfs ro,relatime 0 0
>> proc /proc proc rw,relatime 0 0
>> sys /sys sysfs rw,relatime 0 0
>> dev /dev devtmpfs rw,relatime,size=63072k,nr_inodes=15768,mode=755 0 0
>> dev/pts /dev/pts devpts rw,relatime,mode=600 0 0
>> /tmp /tmp tmpfs rw,relatime 0 0
>> /home /home tmpfs rw,relatime 0 0
>>
>> Userspace can totally determine what /dev/root points to, I made mdev
>> do it in 2006 (udev started doing so shortly thereafter). Busybox git
>> commit a7e3d052.:4
>
> There are situations where it doesn't work though -- suppose that root
> is btrfs for example.
>
> Also, the other message that answered you is correct, the udev
> maintainers say we should not be relying on /dev/root at all so to make
> it work distro packagers have to add a rule themselves.
>
> Kay,
>
> if you are reading, can you jump in and explain why /dev/root is a bad
> idea?

stat("/") is just the better approach for tools to find out what
"root" is, there is not much point in doing symlinks here just because
the kernel uses that name to mount internally.

/dev/root was never part of the default udev setup, it happened in the
distros init scripts, and only some distributions added that.

Newer filesystems like btrfs do not have an 1:1 fs:device relation
anyway, there cannot be a /dev/root symlink anymore, so tools need to
catch up here anyway, and the sooner the better. /dev/root is a
concept that will probably no longer exist in the future, because
filesystems will work differently than they used to.

As Peter said, the kernel should internally just use the name of the
kernel block device instead of inventing and exporting the name of an
artificial /dev/root node, which does not exist later in the real
system.

Kay
