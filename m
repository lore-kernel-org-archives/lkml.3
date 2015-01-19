Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbbASQhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:37:14 -0500
Received: from imap.thunk.org ([74.207.234.97]:49023 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbbASQhM (ORCPT <rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Mon, 19 Jan 2015 11:37:12 -0500
Date: Mon, 19 Jan 2015 11:37:03 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Howard Chu <hyc@symas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
Message-ID: <20150119163703.GA23605@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Hurley <peter@hurleysoftware.com>, Howard Chu <hyc@symas.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Jiri Slaby <jslaby@suse.cz>,
	Linux Kernel Mailing List <Linux-Kernel@Vger.Kernel.ORG>,
	linux-serial@vger.kernel.org
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com>
 <54BC3771.7030204@symas.com>
 <54BC5EC7.1090202@hurleysoftware.com>
 <54BCFC94.1040605@symas.com>
 <54BD1B53.9030901@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BD1B53.9030901@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 09:57:23AM -0500, Peter Hurley wrote:
> 
> This reader set EOL2 to DISABLED_CHAR earlier, and left EOL unchanged.
> I have seen userspace code that expects a line to be no longer than 4096 chars.

Userspace code that does this is going to be very fragile.  Input from
the tty really should be considered completely untrustworthy.  For
example, what if, while the tty is in canonical (ICANON) mode, an
attacker sets PARMRK and clears IGNPAR, IGNBRK, and BRKINT on the tty
and then proceeds to send a large number of breaks or parity errors
down the tty?  That will certainly cause a buffer overflow of said
userspace process.  So if there is *any* setuid program which isn't
defensively checking for buffer overruns it's kind of screwed anyway.

> >> 4. ioctl(TIOCSIG) can send _any_ signal to a different process without
> >>     permission checks. That's not good.
> > 
> > It can only send to the pty slave. Permissions were already checked when the pty master was opened.
> 
> Still not ok.

Interestingly, TIOCSIG is supported by FreeBSD *and* OpenBSD, and
without any kind of checks.  That being said, I can certainly think of
potential security threats that could happen if a malicious program
were to run a setuid program (say, /bin/passwd) under a pty, and then
proceeded to send it a one or more of non-trappable signals -- for
example, either SIGKILL or SIGSTOP -- to either widen the window for a
race condition, or to kill a setuid program at a particularly
inconvenient time.

It might be interesting to see if someone could figure out an attack
that utilized this ioctl, and then demonstrated it on OpenBSD.  :-)

> > What further checks do you think are needed? You think it should
> > be limited to tty-specific signals: INT, QUIT, CONT, TSTP, TTIN,
> > TTOU, WINCH?

Definitely, and we should do this sooner rather than later IMHO.
Preferably before someone figures out whether or not it's possible to
attack OpenBSD and FreeBSD using this ioctl, and requests a CVE.  :-)

	    	   	     	  	 	     - Ted
