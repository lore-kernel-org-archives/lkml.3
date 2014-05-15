Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaEORnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:43:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaEORnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:43:00 -0400
Date: Thu, 15 May 2014 17:42:54 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515174254.GM21073@ubuntumail>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515140856.GA17453@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kroah-Hartman (gregkh@linuxfoundation.org):
> On Thu, May 15, 2014 at 09:42:17AM -0400, Michael H. Warfield wrote:
> > On Wed, 2014-05-14 at 21:00 -0700, Greg Kroah-Hartman wrote:
> > > On Wed, May 14, 2014 at 10:15:27PM -0500, Seth Forshee wrote:
> > > > On Wed, May 14, 2014 at 10:17:31PM -0400, Michael H. Warfield wrote:
> > > > > > > Using devtmpfs is one possible
> > > > > > > solution, and it would have the added benefit of making container setup
> > > > > > > simpler. But simply letting containers mount devtmpfs isn't sufficient
> > > > > > > since the container may need to see a different, more limited set of
> > > > > > > devices, and because different environments making modifications to
> > > > > > > the filesystem could lead to conflicts.
> > > > > > > 
> > > > > > > This series solves these problems by assigning devices to user
> > > > > > > namespaces. Each device has an "owner" namespace which specifies which
> > > > > > > devtmpfs mount the device should appear in as well allowing priveleged
> > > > > > > operations on the device from that namespace. This defaults to
> > > > > > > init_user_ns. There's also an ns_global flag to indicate a device should
> > > > > > > appear in all devtmpfs mounts.
> > > > > 
> > > > > > I'd strongly argue that this isn't even a "problem" at all.  And, as I
> > > > > > said at the Plumbers conference last year, adding namespaces to devices
> > > > > > isn't going to happen, sorry.  Please don't continue down this path.
> > > > > 
> > > > > I was just mentioning that to Serge just a week or so ago reminding him
> > > > > of what you told all of us face to face back then.  We were having a
> > > > > discussion over loop devices into containers and this topic came up.
> > > > 
> > > > It was the loop device use case that got me started down this path in
> > > > the first place, so I don't personally have any interest in physical
> > > > devices right now (though I was sure others would).
> > 
> > > Why do you want to give access to a loop device to a container?
> > > Shouldn't you set up the loop devices before creating the container and
> > > then pass those mount points into the container?  I thought that was how
> > > things worked today, or am I missing something?
> > 
> > Ah, you keep feeding me easy ones.  I need raw access to loop devices
> > and loop-control because I'm using containers to build NST (Network
> > Security Toolkit) distribution iso images (one container is x86_64 while
> > the other is i686).  Each requires 2 loop devices.  You can't set up the
> > loop devices in advance since the containers will be creating the images
> > and building them.  NST tinkers with the base build engine
> > configuration, so I really DON'T want it running on a hard iron host. 
> > There may be other cases where I need other specialized containers for
> > building distros.  I'm also looking at custom builds of Kali (another
> > security distribution).
> 
> Then don't use a container to build such a thing, or fix the build
> scripts to not do that :)
> 
> That is not a "normal" use case for a container at all.  Containers are
> not for "everything", use a virtual machine for some tasks (like this
> one).

Hi Greg,

What exactly defines '"normal" use case for a container'?  Not too long
ago much of what we can now do with network namespaces was not a normal
container use case.  Neither "you can't do it now" nor "I don't use it
like that" should be grounds for a pre-emptive nack.  "It will horribly
break security assumptions" certainly would be.

That's not to say there might not be good reasons why this in particular
is not appropriate, but ISTM if things are going to be nacked without
consideration of the patchset itself, we ought to be having a ksummit
session to come to a consensus [ or receive a decree, presumably by you :)
but after we have a chance to make our case ] on what things are going to
be un/acceptable.

> > Serge mentioned something to me about a loopdevfs (?) thing that someone
> > else is working on.  That would seem to be a better solution in this
> > particular case but I don't know much about it or where it's at.
> 
> Ok, let's see those patches then.

I think Seth has a git tree ready, but not sure which branch he'd want
us to look at.

Splitting a namespaced devtmpfs from loopdevfs discussion might be
sensible.  However, in defense of a namespaced devtmpfs I'd say
that for userspace to, at every container startup, bind-mount in
devices from the global devtmpfs into a private tmpfs (for systemd's
sake it can't just be on the container rootfs), seems like something
worth avoiding.

-serge

PS - Apparently both parallels and Michael independently
project devices which are hot-plugged on the host into containers.
That also seems like something worth talking about (best practices,
shortcomings, use cases not met by it, any ways tha the kernel can
help out) at ksummit/linuxcon.
