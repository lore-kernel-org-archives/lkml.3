Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3GXQt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:49:57 -0400
Received: from tango.0pointer.de ([85.214.72.216]:50159 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3GXQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:49:55 -0400
Date: Wed, 24 Jul 2013 18:49:53 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
Message-ID: <20130724164953.GW835@tango.0pointer.de>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at>
 <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <51ED0BBF.7060502@nod.at>
 <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
 <20130722223238.GC13191@tango.0pointer.de>
 <51EE1765.2000402@nod.at>
 <CAFLxGvx0-TA7R5d6ienSiRm+rrGtCyf_LU5BNTAn1t7U9Ji8Jw@mail.gmail.com>
 <20130723075757.GM4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723075757.GM4165@ZenIV.linux.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23.07.13 08:57, Al Viro (viro@ZenIV.linux.org.uk) wrote:

> 
> On Tue, Jul 23, 2013 at 07:47:07AM +0200, richard -rw- weinberger wrote:
> > Adding Al again, someone dropped him from the CC list...
> 
> FWIW, all this crap stems from the old decision to use major 4 for
> uml consoles.  And it was a bad decision, no arguments here.
> It's also a decision we are years too late to revert.
> 
> a) VT102, let alone the extensions to it, is simply wrong for uml;
> if it's understood by anything, it's on the host userland side.
> xterm(1) has a notion of two-dimensional array of characters on screen,
> organized in logical lines, etc.  So does screen(1).  So does
> drivers/tty/vt/* (i.e. the kernel side of virtual console).  uml
> console does *not* have such a notion - it passes a linear stream
> of octets, sight unseen, to whatever's on the other side of connection.
> Doing an equivalent of drivers/tty/vt/* would mean maintaining such
> a 2D array internally *AND* somehow passing updates to that beast
> to whatever's on the other side.  That could be done (after all,
> libcurses manages), but it won't be compatible with existing setups
> and it should be a separate driver, anyway.  Granted, it would've
> made a whole lot more sense in role of /dev/tty<n>, but it's too late
> for that now.

The UML tty devices are in most regards pretty much like serial TTYs
where there's also no meta-information available which terminal
emulation is actually spoken on it, and that's covered pretty much OK
everyhwere...

> b) changing the major of /dev/tty<n> on uml will break existing setups.
> Ain't feasible.  We probably can get away with making that controlled
> by kernel option, and it might make sense to try going that way, but
> I'm not entirely convinced it's worth bothering.  Up to uml maintainer...
> IMO if we go that way, we ought to pass the relevant part of config
> (i.e. is it xterm or pts or plain opened file) in the event udev
> gets, so that the userland would have at least a chance of dealing
> with another real problem - selecting TERM value for getty.

Which major/minor you use is irrelevant to userspace. The userspace API
however assumes that /dev/tty[1..63] refers to the tty devices of the
virtual console. As long as you provide some other TTY under that name
then the virtual console TTYs you simply provide a broken API to
userspace, and hence programs break. systemd does, gpm does, X11 does,
and everything else that interfaces with the VC via VC APIs does too.

Just pick a different name for the TTYs that UML uses, just not
/dev/tty[1..63] and everything is fine. That's what the virtualization
folks did with their hypervisor consoles, and is what we required from
the container folks too.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
