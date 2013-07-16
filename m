Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab3GPTDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:03:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327Ab3GPTDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:03:42 -0400
Date: Tue, 16 Jul 2013 20:03:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
Message-ID: <20130716190340.GO4165@ZenIV.linux.org.uk>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at>
 <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
 <20130716174708.GN4165@ZenIV.linux.org.uk>
 <CALkWK0mY8OgqUiOAmyLzZpaS1U7Vw_xPSHytqggikGWBoghd_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0mY8OgqUiOAmyLzZpaS1U7Vw_xPSHytqggikGWBoghd_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:42:55PM +0530, Ramkumar Ramachandra wrote:
> Leave aside the fact that I could not find the uml-utils upstream [1],
> and didn't have a /uml/port-helper to connect the xterms for a second;
> I didn't even understand what was supposed to happen.  Why do we spawn
> xterms, and attach to the host's /dev/tty*?  So far, I just used
> /dev/console inside my existing tmux session in urxvt, and it seems to
> work fine.

There are several things that can be attached to them.  Again, see the
HOWTO for details.  FWIW, I prefer to have console in whatever I'm
launching the whole thing in (usually - ssh session to the box I'm
using to run all kinds of testing stuff on) with tty[1-6] attached to
pts and accessed via screen /dev/pts/<n> on the same box (again, from ssh
sessions, obviously).

> > One
> > practical issue is the lack of VT102 emulation;
> 
> This detail is not at all clear from the Documentation.  I spent a lot
> of time trying to figure out why systemd wasn't able to getty on
> /dev/tty1.

No fscking idea - sysvinit has no problem with launching getty instances
(on explicit lines in inittab, that is), so it's not a problem on getty
side of things.  And as much as I dislike systemd, I think it's not to blame
in this case.  It looks like it *does* lauch getty just fine, but your host
is misconfigured in a way that makes attempts to open the corresponding device
nodes fail.  With the messages you've quoted.  The same HOWTO has
     2.3 Compiling and installing uml_utilities
right after
     2.1 Compiling the kernel
     2.2 Compiling and installing kernel modules
so it's not as if the needed setup had not been mentioned.

FWIW, it would be a good idea to package the damn thing for Fedora -
Debian has
$ apt-cache search 'User-Mode Linux'
rootstrap - A tool for building complete Linux filesystem images
uml-utilities - User-mode Linux (utility programs)
user-mode-linux-doc - User-mode Linux (Documentation)
user-mode-linux - User-mode Linux (kernel)
$

> > TERM=linux when logged
> > in on those is not right - you want either TERM=xterm (for xterms) or
> > TERM=screen (when accessing pts-associated ones with screen /dev/pts/n),
> > etc.  In any case, it's a dumb serial line as far as the guest kernel
> > is concerned - all terminal emulation is going to happen elsewhere (xterms
> > running on host and interpreting escape sequences from guest userland,
> > etc.)
> 
> Hm, what does $TERM have to do with all this?

Huh?  That's what tells all curses-based stuff which escape sequences to
emit.  And that's the *only* thing in which "it's not a VT" matters at
all.  Again, your description of symptoms doesn't look like "systemd gets
confused by tty1 not being a VT and fails to launch getty"; it appears to
be "systemd does see tty1 and does launch getty, albeit with slightly wrong
terminal type argument.  Which doesn't matter, since getty fails to open the
device nodes due to missing utilities on host".  Install said utilities
or switch to explicit con=... in command line and getty will launch just
fine.  That's where TERM= settings come into play - some curses-based stuff
will assume it has all linux VT escape sequences to play with and the
thing you are using to access it might not be happy.  Other than that
(and this is the thing you pass to getty as terminal type - the last
argument for agetty(8)), everything seems to boil down to lack of uml utils
on host...
