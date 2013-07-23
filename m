Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3GWH6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:58:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3GWH6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:58:01 -0400
Date: Tue, 23 Jul 2013 08:57:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
Message-ID: <20130723075757.GM4165@ZenIV.linux.org.uk>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at>
 <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <51ED0BBF.7060502@nod.at>
 <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
 <20130722223238.GC13191@tango.0pointer.de>
 <51EE1765.2000402@nod.at>
 <CAFLxGvx0-TA7R5d6ienSiRm+rrGtCyf_LU5BNTAn1t7U9Ji8Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvx0-TA7R5d6ienSiRm+rrGtCyf_LU5BNTAn1t7U9Ji8Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 07:47:07AM +0200, richard -rw- weinberger wrote:
> Adding Al again, someone dropped him from the CC list...

FWIW, all this crap stems from the old decision to use major 4 for
uml consoles.  And it was a bad decision, no arguments here.
It's also a decision we are years too late to revert.

a) VT102, let alone the extensions to it, is simply wrong for uml;
if it's understood by anything, it's on the host userland side.
xterm(1) has a notion of two-dimensional array of characters on screen,
organized in logical lines, etc.  So does screen(1).  So does
drivers/tty/vt/* (i.e. the kernel side of virtual console).  uml
console does *not* have such a notion - it passes a linear stream
of octets, sight unseen, to whatever's on the other side of connection.
Doing an equivalent of drivers/tty/vt/* would mean maintaining such
a 2D array internally *AND* somehow passing updates to that beast
to whatever's on the other side.  That could be done (after all,
libcurses manages), but it won't be compatible with existing setups
and it should be a separate driver, anyway.  Granted, it would've
made a whole lot more sense in role of /dev/tty<n>, but it's too late
for that now.

b) changing the major of /dev/tty<n> on uml will break existing setups.
Ain't feasible.  We probably can get away with making that controlled
by kernel option, and it might make sense to try going that way, but
I'm not entirely convinced it's worth bothering.  Up to uml maintainer...
IMO if we go that way, we ought to pass the relevant part of config
(i.e. is it xterm or pts or plain opened file) in the event udev
gets, so that the userland would have at least a chance of dealing
with another real problem - selecting TERM value for getty.
