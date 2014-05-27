Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaE0NRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:17:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaE0NRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:17:35 -0400
Date: Tue, 27 May 2014 13:16:57 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Michael H. Warfield" <mhw@WittsEnd.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Marian Marinov <mm@1h.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] [RFC PATCH 11/11] loop: Allow priveleged operations
 for root in the namespace which owns a device
Message-ID: <20140527131657.GK4232@ubuntumail>
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

Quoting Michael H. Warfield (mhw@WittsEnd.com):
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
> miracle needs a lot more detail.

Naturally.  Which is why as Seth says we'll need concrete code to discuss.
But the concept that a well implemented namespace which prevents addressing
a given resource in the first place would suffice is, I think, a well
accepted premise of security in linux.  And in this case it is more
appropriate than trying to finagle it into the devices cgroup.  Note that
Marian said "to check if root user in that namespace is allowed to use
this device."  This first off does not address the concern of root on the
host being tricked by the contents of loop0 which happens to be legitimately
used by container N.  In contrast, making it so that loop0 is only
addressable by container N, and not by the host, does.

Anyway I as reading the above as why don't we *base* the containerized loop
on devices cgroups.  I object to that.  Well, at least until we rule out
more elegant solutions.  Of course I don't object to defense in depth.

-serge
