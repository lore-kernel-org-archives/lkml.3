Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3GVWjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:39:44 -0400
Received: from tango.0pointer.de ([85.214.72.216]:38839 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3GVWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:39:43 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 18:39:42 EDT
Date: Tue, 23 Jul 2013 00:32:39 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
Message-ID: <20130722223238.GC13191@tango.0pointer.de>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at>
 <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <51ED0BBF.7060502@nod.at>
 <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22.07.13 16:13, Ramkumar Ramachandra (artagnon@gmail.com) wrote:

> 
> [Corrected Lennart's email ID]
> 
> Richard Weinberger wrote:
> > CC'ing Lennart.
> >
> > Am 22.07.2013 11:45, schrieb Ramkumar Ramachandra:
> >> Ramkumar Ramachandra wrote:
> >>> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
> >>
> >> ... and the patches were rejected.  Lennart says that UML providing
> >> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
> >> something).  Can we do something about the situation?  Can we remove
> >> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
> >>
> >> Thanks.
> >>
> >> Lennart Poettering wrote:
> >>> UML shouldn't be penalized for not implementing some terminal emulation,
> >>> but it should be penalized for doing so under the label of "VT support",
> >>> which it simply is not providing.
> >>>
> >>> They can call their ttys any way they want. If the call them
> >>> /dev/tty[1..64] however, then they need to implement the VC
> >>> interfaces. All of them.
> >
> > Lennart, can you please explain us why /dev/tty[1..64] is forced to
> > have virtual console support?

/dev/tty[1..64] is the userspace API to the kernel VT subsystem. If you
support it you need to match up all /dev/tty[1..64] with a
/dev/vcs[1..64] + /dev/vcsa[1..64]. You need to expose a tty that
understands TERM=linux and the ioctls listed on console_ioctl(4). You
need /dev/tty0 as something that behaves like a symlink to the fg
VT. You should also support files like /sys/class/tty/tty0/active with
its POLLHUP iface.

If you expose a very different terminal than a VT as /dev/tty[1..64]
this will confuse a lot of userspace, since userspace, be it
systemd/logind, gpm, X11, openvt, ... all expect that /dev/tty[1..64] is
the VT subsystem where all that functionality is available. And you just
broke the userspace API quite badly.

It's totally fine to register ttys with a different feature set under
some other name you like, but if you name it /dev/tty[1..64] then
userspace expects this to be the real deal.

The various hypervisors understood this and provide their ttys under the
name of /dev/hvc0 and suchlike. UML should probably do something
similar. If you pick a name of your own, you have complete freedom what
you actually implement...

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
