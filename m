Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaE0HQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:16:32 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62653 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaE0HQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:16:30 -0400
Date: Tue, 27 May 2014 09:16:26 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Marian Marinov <mm@1h.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lxc-devel] [RFC PATCH 11/11] loop: Allow priveleged operations
 for root in the namespace which owns a device
Message-ID: <20140527071626.GA3617@ubuntu-mba51>
Mail-Followup-To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	Marian Marinov <mm@1h.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
 <537EE129.1020603@1h.com>
 <20140526091614.GA13666@ubuntu-mba51>
 <1401118325.7572.82.camel@canyon.ip6.wittsend.com>
 <20140527013634.GA3524@mail.hallyn.com>
 <1401158362.7572.138.camel@canyon.ip6.wittsend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401158362.7572.138.camel@canyon.ip6.wittsend.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:39:22PM -0400, Michael H. Warfield wrote:
> On Tue, 2014-05-27 at 03:36 +0200, Serge E. Hallyn wrote:
> > Quoting Michael H. Warfield (mhw@WittsEnd.com):
> > > On Mon, 2014-05-26 at 11:16 +0200, Seth Forshee wrote:
> > > > On Fri, May 23, 2014 at 08:48:25AM +0300, Marian Marinov wrote:
> > > > > -----BEGIN PGP SIGNED MESSAGE-----
> > > > > Hash: SHA1
> > > > > 
> > > > > One question about this patch.
> > > > > 
> > > > > Why don't you use the devices cgroup check if the root user in that namespace is allowed to use this device?
> > > > > 
> > > > > This way you can be sure that the root in that namespace can not access devices to which the host system did not gave
> > > > > him access to.
> > > 
> > > > That might be possible, but I don't want to require something on the
> > > > host to whitelist the device for the container. Then loop would need to
> > > > automatically add the device to devices.allow, which doesn't seem
> > > > desirable to me. But I'm not entirely opposed to the idea if others
> > > > think this is a better way to go.
> > > 
> > > I don't see any safe way to avoid it.  The host has to be in control of
> > > what devices can and can not be accessed by the container.
> 
> > Disagree.  loop%d is meaningless until it is attached to a file.  So
> > whether a container can use loop2 vs loop9 is meaningless.  The point
> > of Seth's loopfs as I understood it is that the container simply gets a
> > unique (not visible to host or any other containers) set of loop devices
> > which it can attach to files which it owns.  So long as the host can't
> > see the container's loop devices (i.e. so it unwittently mounts it when
> > looking for a particular UUID for /var), it won't get fooled by them.
> 
> > So in this case *if* we can do it, a purely namespaced approach - meaning
> > that we restrict visibility of a particular loopdev to one container - is
> > perfect.  
> 
> And in that "*if" is a cloud that says "then a miracle occurs" and that
> miracle needs a lot more detail.  How that translates into what is and
> is not visible and what can be mimiced in a container becomes important
> (to say nothing of notifying its udev).  I think this loopfs thing is
> the answer for the loop device case, we just need to clear up those
> details and exorcise the devils we find in them.  The loop devices are
> unique while they strangely seem to work with minimal leakage already
> (all meta data at this time).
> 
> Seth remarked that, maybe, he's not paranoid enough.  You know that I'm
> a well trained professional paranoid and I accept if people think I'm
> overly paranoid (is that even possible?).  Even paranoids have enemies
> and just because you're paranoid it doesn't mean they're not out to get
> you.  While I admit that total isolation is virtually (excuse the pun)
> impossible that doesn't mean I don't strive to maximize the isolation
> and analyze the possibilities and consequences of compromise.
> 
> As I stated, "I don't see any way to avoid it".  I would love to be
> proven wrong.  It would permit my life to be so much more easy.  But how
> can we allow this without the host in control of it and directing things
> to the containers?  A container may request something and the host can
> grant it but the container should not be capable of demanding a device
> over and above the control of the host.  How do we define the rules that
> say what a container can do and what it cannot do without it involving
> knowledge in the host (whitelisting as Seth call's it) of what is and is
> not allowed in the container?

I need to post some code so we have something concrete to discuss, just
haven't gotten to it yet due to travel and meetings. I'll try to work
the code into something presentable and send it out later today.

But in loopfs the kernel would ultimately controls directing loop devs
to containers based on the mount. A container can request a free loop
device via loop-control, and one gets assigned to that mount. Userspace
can ask for a specific loop device number, but if that device is
associated with a different mount that will fail, so the container can't
gain access to another context's loop device. The container has access
to only its loop devices by virtue of not having device nodes for any
other devices.

> We already have the problem that the container devices.allow and
> devices.deny are major and minor based, which we know is fundamentally
> flawed in a udev environment.  We specify major:minor in the
> configuration files as if they are cast in cement (which they are in all
> common cases) but they are not in the general case.  Greg K-H hammers on
> this frequently.
> 
> The loop devices are unique and deserve a unique solution, I'll agree.
> But I'm also comfortable that the host should have rules and procedures
> to whitelist hard devices and loop devices and manage their transfer
> and/or sharing into the containers.

I'm aiming for being able to use the same tools to manage loop device in
a container as on the host. If the whole thing needs to be managed by a
process on the host then I suspect we need something more like
intercepting ioctls on loop-control within the container so the manager
can handle them.

