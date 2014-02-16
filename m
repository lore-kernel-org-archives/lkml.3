Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaBPDBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 22:01:07 -0500
Received: from tartarus.angband.pl ([89.206.35.136]:59267 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaBPDBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 22:01:05 -0500
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 22:01:04 EST
Date: Sun, 16 Feb 2014 03:37:59 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: detect and ignore OSC codes.
Message-ID: <20140216023759.GB30022@angband.pl>
References: <1389766864-22673-1-git-send-email-kilobyte@angband.pl>
 <20140213183912.GA18522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213183912.GA18522@kroah.com>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:39:12AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 15, 2014 at 07:21:04AM +0100, Adam Borowski wrote:
> > These can be used to send commands consisting of an arbitrary string to the
> > terminal, most often used to set a terminal's window title or to redefine
> > the colour palette.  Our console doesn't use OSC, unlike everything else,
> > which can lead to junk being displayed if a process sends such a code
> > unconditionally.
> > 
> > Not following Ecma-48, this commit recognizes 7-bit forms (ESC ] ... 0x07,
> > ESC ] .. ESC \) but not 8-bit (0x9D ... 0x9C).
> > 
> > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> 
> Where is this documented?

It's a mix of Ecma-48 and undocumented practice.  Ecma-48 says:

# 8.3.89
#   OSC - OPERATING SYSTEM COMMAND
#   Notation: (C1)
#   Representation: 0x9D or ESC 0x5D (])
#
#   OSC is used as the opening delimiter of a control string for operating
#   system use.  The command string following may consist of a sequence of
#   bit combinations in the range 0x08 to 0x0D and 0x20 to 0x7E.  The
#   control string is closed by the terminating delimiter STRING TERMINATOR
#   (ST).  The interpretation of the command string depends on the relevant
#   operating system.

# 8.3.143
#   ST - STRING TERMINATOR
#   Notation: (C1)
#   Representation: 0x9C or ESC 0x5C (\)
#
#   ST is used as the closing delimiter of a control string opened by
#   APPLICATION PROGRAM COMMAND (APC), DEVICE CONTROL STRING (DCS),
#   OPERATING SYSTEM COMMAND (OSC), PRIVACY MESSAGE (PM), or START OF STRING
#   (SOS).

... which doesn't define the behaviour for characters 0x00..0x07, 0x0E..0x1F
or 0x7F..0xFF.  Somehow, using 0x07 for termination became a widespread
idiom, used more often than proper ESC \.  For this reason, implementations
I know all recognize 0x07 as a terminator.  The behaviour for other
characters differs, ie, is truly undefined.

As, unlike what Ecma-48 says, using 8-bit characters in a window title is a
reasonable thing to do, I'd allow 0x80..0xFF as non-terminators.  I have no
idea what to do with remaining control characters: the current patch allows
them to be interpreted, as it's usually the case for control characters
inside terminal codes.  I did not research other implementation here.

I did not recognize 0x9C as ST for two reasons: 1. it'd break non-ASCII
characters that happen to include this byte, and 2. Linux already fails to
recognize 8-bit control codes (with one exception: 0x9B stands for ESC [).


Should I put the above explanation somewhere?  As a comment?  In the commit
message?  Or does it need to be elaborated even further?

> > ---
> >  drivers/tty/vt/vt.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index 61b1137..0377c52 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -1590,7 +1590,7 @@ static void restore_cur(struct vc_data *vc)
> >  
> >  enum { ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
> >  	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
> > -	ESpalette };
> > +	ESpalette, ESosc };
> >  
> >  /* console_lock is held (except via vc_init()) */
> >  static void reset_terminal(struct vc_data *vc, int do_clear)
> > @@ -1650,11 +1650,15 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
> >  	 *  Control characters can be used in the _middle_
> >  	 *  of an escape sequence.
> >  	 */
> > +	if (vc->vc_state == ESosc && c>=8 && c<=13) /* ... except for OSC */
> > +		return;
> >  	switch (c) {
> >  	case 0:
> >  		return;
> >  	case 7:
> > -		if (vc->vc_bell_duration)
> > +		if (vc->vc_state == ESosc)
> > +			vc->vc_state = ESnormal;
> > +		else if (vc->vc_bell_duration)
> >  			kd_mksound(vc->vc_bell_pitch, vc->vc_bell_duration);
> >  		return;
> >  	case 8:
> > @@ -1765,7 +1769,9 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
> >  		} else if (c=='R') {   /* reset palette */
> >  			reset_palette(vc);
> >  			vc->vc_state = ESnormal;
> > -		} else
> > +		} else if (c>='0' && c<='9')
> > +			vc->vc_state = ESosc;
> > +		else
> >  			vc->vc_state = ESnormal;
> >  		return;
> >  	case ESpalette:
> > @@ -2023,6 +2029,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
> >  		return;
> >  	default:
> >  		vc->vc_state = ESnormal;
> > +	case ESosc:
> > +		return;
> 
> Why below the default: case?

Just to shave a line and a return statement.  From your objection, I guess
this goes against the coding standards, right?


Meow!
-- 
A tit a day keeps the vet away.
