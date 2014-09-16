Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaIPR0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:26:36 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34269 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIPR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:26:35 -0400
Date: Tue, 16 Sep 2014 12:26:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
Message-ID: <20140916172627.GA50006@ubuntu-hedt>
Mail-Followup-To: Shea Levy <shea@shealevy.com>,
	linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <20140915203844.GA14761@nixos.hsd1.nh.comcast.net>
 <20140915205532.GA16651@ubuntu-hedt>
 <20140915232052.GA2235@nixos.hsd1.nh.comcast.net>
 <20140916161247.GA5026@nixos.hsd1.nh.comcast.net>
 <20140916163957.GB30588@ubuntu-hedt>
 <20140916170548.GB5026@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916170548.GB5026@nixos.hsd1.nh.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:05:48PM -0400, Shea Levy wrote:
> On Tue, Sep 16, 2014 at 11:39:57AM -0500, Seth Forshee wrote:
> > On Tue, Sep 16, 2014 at 12:12:47PM -0400, Shea Levy wrote:
> > > OK, compiling with BLK_DEV_LOOP=y (on top of 3.16.2), I was able to
> > > mount loopfs, request a loop device from loop-control, and associate it
> > > with an image with an ext4 partition with losetup, but mount still gives
> > > EPERM (all as root in a userns started from an unprivileged account). Is
> > > this expected? I do have read and write permissions to the resultant
> > > loop device. If this is expected, what would be needed to be able to
> > > mount the device?
> > 
> > Yes. Very few filesystems allow mounting from a userns right now, and
> > probably no "regular" filesystems do, only special filesystems like
> > sysfs. At minimum you'll need to add the FS_USERNS_MOUNT flag to any
> > filesystems you want to use, but even then the user/group ids probably
> > won't be translated into the userns.
> > 
> 
> Hm, I see. Yeah, none of the 'regular' filesystems have that set. Why is
> that, if it's easy to explain? From a naive perspective it seems like if
> you have the permissions to the device then the uid/gid mapping should
> be generic (the on-disk id is the id *inside* the namespace, the kernel
> maps that based on the id_map file to processes outside the namespace),
> but I'm sure that's insecure in a way I'm not seeing.

Security. There are likely some bugs in how filesystem data is
processed, and if an arbitrary user can hand the kernel specially
crafted filesystem images these bugs could become exploits. I suspect
that some filesystems will be mountable from user namespaces eventually,
I just don't think anyone has done the work to alleviate the security
concerns yet.

> > > Also, this isn't an issue exactly, but the free devices started at 8
> > > (presumably because I have /dev/loop[0-7]) and appear in /dev in the
> > > root ns (presumably via udev) until I unmounted.
> > 
> > Right. 0-7 get created at module init time and end up allocated to the
> > init_user_ns superblock, so the first "free" id for your ns is 8.
> > 
> > I've brought up the problem of the devices for the userns also showing
> > up in devtmpfs. It was dismissed as not really being an issue, though I
> > still don't agree with that viewpoint. My proposed solution of assigning
> > devices to namespaces and then creating a namespaced devtmpfs was
> > rejected as well.
> > 
> > Just so you know, I'm not doing any further development of these patches
> > right now. I've shifted my efforts to getting fuse mountable from user
> > namespaces (https://lkml.org/lkml/2014/9/12/367).
> > 
> 
> Aside from the patch to build as a module, is there anything further to
> be done on the loopfs side of things? If not I may try to get this
> merged myself if you don't mind.

No, I don't mind.

There's probably some cleanup to do. I don't recall if I had resolved
all the issues with getting the loop devices "freed" when a superblock
was killed, which was kind of tricky to get right. Obviously I never
tested unloading the module either ;-)

Also go back through the thread and read the feedback the patches got.
There was a suggestion to leave loop alone and create something new for
this purpose as well.

There may be more, but that's what comes to mind. I also wanted to
somehow make the devices which are in a non-root loopfs mount not show
up in devtmpfs, but I still needed to come up with a way to do that
which Greg would be happy with.

Seth

