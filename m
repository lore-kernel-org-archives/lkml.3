Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaETOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:21:11 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45877 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaETOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:21:10 -0400
Date: Tue, 20 May 2014 09:21:03 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140520142103.GC137220@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
 <20140516185749.GA5131@kroah.com>
 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
 <20140516201841.GC23902@ubuntu-hedt>
 <87mwedfh7c.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwedfh7c.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:04:55PM -0700, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > What I set out for was feature parity between loop devices in a secure
> > container and loop devices on the host. Since some operations currently
> > check for system-wide CAP_SYS_ADMIN, the only way I see to accomplish
> > this is to push knowledge of the user namespace farther down into the
> > driver stack so the check can instead be for CAP_SYS_ADMIN in the user
> > namespace associated with the device.
> >
> > That said, I suspect our current use cases can get by without these
> > capabilities. Really though I suspect this is just deferring the
> > discussion rather than settling it, and what we'll end up with is little
> > more than a fancy way for userspace to ask the kernel to run mknod on
> > its behalf.
> 
> A fancy way to ask the kernel to run mknod on its behalf is what
> /dev/pts is.
> 
> When I suggested this I did not mean you should forgo making changes to
> allow partitions and the like.  What I itended is that you should find a
> way to make this safe for users who don't have root capabilities.

But Greg did say that "unprivileged" or "secure" containers (depending
on whose terminology you're using) should not be able to do partitioning
[1]. I don't really understand this stance though, as I don't see what
possible security problems arise from letting root in a user ns do
BLKRRPART on a block device that it's explicitly been granted privileged
use of.

Assuming we come to an agreement that root in a user ns can do BLKRRPART
on some devices, we've got two issues. First, the block layer enforces
this restriction so it has to be aware of what namespace has privileges
for the device, but Greg wants a solution localized to the loop driver.
Second, if we're using a loop psuedo fs then we'd logically want block
devices for the partitions in the loop fs, so we have to create some
mechanism for the loop driver to get notified about these devices being
created.

> Which possibly means that mount needs to learn how to keep a more
> privileged user from using your new loop devices.

The patches I posted have mechanisms to at least mitigate the problem.
First, anyone using loop-control to find a free loop device will never
get a device allocated to a different user ns (the loop psuedo fs code I
have also does this). Second, a given loop block device would only show
up in the devtmpfs of the namespace which owned that device. So a
sufficiently priveleged user isn't completely prevented from using the
devices, but since they would have to explicitly mknod the block device
node it should prevent accidental use by a more privileged user.

But I also brought this up previously, and Greg argued that it isn't a
real issue [1].

> To get to the point where this is really and truly usable I expect to be
> technically daunting.
> 
> Ultimately the technical challenge is how do we create a block device
> that is safe for a user who does not have any capabilities to use, and
> what can we do with that block device to make it useful.

Yes, and I'd like to get started solving those challenges. But I also
don't think we can address these two points (support partition blkdevs,
help prevent more priveleged users from using a namespace's loop
devices) sufficiently while having an implementation completely
contained within the loop driver as Greg is requesting.

Thanks,
Seth

> 
> Only when the question is can this kernel functionality which is
> otherwise safe confuse a preexisting setuid application do namespace
> or container bits significantly come into play.
> 
> Eric

[1] http://www.spinics.net/linux/lists/kernel/msg1744750.html
