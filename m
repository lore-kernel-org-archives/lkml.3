Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaIOUzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:55:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39922 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaIOUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:55:35 -0400
Date: Mon, 15 Sep 2014 15:55:32 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
Message-ID: <20140915205532.GA16651@ubuntu-hedt>
Mail-Followup-To: Shea Levy <shea@shealevy.com>,
	linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <20140915203844.GA14761@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915203844.GA14761@nixos.hsd1.nh.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:38:44PM -0400, Shea Levy wrote:
> Hi,
> 
> I wanted to test these patches (to support creating and filling a disk
> image containing a btrfs filesystem and several subvolumes as an
> unprivileged user), but the build fails due to what looks like a missing
> loopfs.c in fs/loopfs (or alternatively an erroneous line in
> fs/loopfs/Makefile). I built based off of 3.17-rc5.

There's no loopfs.c, loopfs.o gets built from inode.o which is in turn
built from inode.c. I'm pretty sure the patches built when I posted
them, which seems to be 3.15-rc7 based on the branch I've got here.

Seth

> 
> ~Shea
> 
> 
> On Tue, May 27, 2014 at 11:58:54PM +0200, Seth Forshee wrote:
> > I'm posting these patches in response to the ongoing discussion of loop
> > devices in containers at [1].
> > 
> > The patches implement a psuedo filesystem for loop devices, which will
> > allow use of loop devices in containters using standard utilities. Under
> > normal use a loopfs mount will initially contain a single device node
> > for loop-control which can be used to request and release loop devices.
> > Any devices allocated via this node will automatically appear in that
> > loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
> > CAP_SYS_ADMIN in the userns of the process which performed the mount is
> > allowed to perform privileged loop ioctls on these devices.
> > 
> > Alternately loopfs can be mounted with the hostmount option, intended
> > for mounting /dev/loop in the host. This is the default mount for any
> > devices not created via loop-control in a loopfs mount (e.g. devices
> > created during driver init, devices created via /dev/loop-control, etc).
> > This is only available to system-wide CAP_SYS_ADMIN.
> > 
> > I still have some testing to do on these patches, but they work at
> > minimum for simple use cases. It's possible to use an unmodified losetup
> > if it's new enough to know about loop-control, with a couple of caveats:
> > 
> >  * /dev/loop-control must be symlinked to /dev/loop/loop-control
> >  * In some cases losetup attempts to use /dev/loopN when the device node
> >    is at /dev/loop/N. For example, 'losetup -f disk.img' fails.
> > 
> > Device nodes for loop partitions are not created in loopfs. These
> > devices are created by the generic block layer, and the loop driver has
> > no way of knowing when they are created, so some kind of hook into the
> > driver will be needed to support this.
> > 
> > Thanks,
> > Seth
> > 
> > [1] http://article.gmane.org/gmane.linux.kernel/1703988
> > 
> > Seth Forshee (2):
> >   loop: Add loop filesystem
> >   loop: Permit priveleged operations within user namespaces
> > 
> >  drivers/block/loop.c       | 137 +++++++++++++----
> >  drivers/block/loop.h       |   2 +
> >  fs/Makefile                |   1 +
> >  fs/loopfs/Makefile         |   6 +
> >  fs/loopfs/inode.c          | 360 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/loopfs.h     |  53 +++++++
> >  include/uapi/linux/magic.h |   1 +
> >  7 files changed, 535 insertions(+), 25 deletions(-)
> >  create mode 100644 fs/loopfs/Makefile
> >  create mode 100644 fs/loopfs/inode.c
> >  create mode 100644 include/linux/loopfs.h
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
