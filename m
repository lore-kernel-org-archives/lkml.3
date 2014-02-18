Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaBRSnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:43:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBRSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:43:05 -0500
Date: Tue, 18 Feb 2014 10:44:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: detect and ignore OSC codes.
Message-ID: <20140218184430.GA29209@kroah.com>
References: <1389766864-22673-1-git-send-email-kilobyte@angband.pl>
 <20140213183912.GA18522@kroah.com>
 <20140216023759.GB30022@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140216023759.GB30022@angband.pl>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 03:37:59AM +0100, Adam Borowski wrote:
> On Thu, Feb 13, 2014 at 10:39:12AM -0800, Greg Kroah-Hartman wrote:
> > On Wed, Jan 15, 2014 at 07:21:04AM +0100, Adam Borowski wrote:
> > > These can be used to send commands consisting of an arbitrary string to the
> > > terminal, most often used to set a terminal's window title or to redefine
> > > the colour palette.  Our console doesn't use OSC, unlike everything else,
> > > which can lead to junk being displayed if a process sends such a code
> > > unconditionally.
> > > 
> > > Not following Ecma-48, this commit recognizes 7-bit forms (ESC ] ... 0x07,
> > > ESC ] .. ESC \) but not 8-bit (0x9D ... 0x9C).
> > > 
> > > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> > 
> > Where is this documented?
> 
> It's a mix of Ecma-48 and undocumented practice.  Ecma-48 says:
> 
> # 8.3.89
> #   OSC - OPERATING SYSTEM COMMAND
> #   Notation: (C1)
> #   Representation: 0x9D or ESC 0x5D (])
> #
> #   OSC is used as the opening delimiter of a control string for operating
> #   system use.  The command string following may consist of a sequence of
> #   bit combinations in the range 0x08 to 0x0D and 0x20 to 0x7E.  The
> #   control string is closed by the terminating delimiter STRING TERMINATOR
> #   (ST).  The interpretation of the command string depends on the relevant
> #   operating system.
> 
> # 8.3.143
> #   ST - STRING TERMINATOR
> #   Notation: (C1)
> #   Representation: 0x9C or ESC 0x5C (\)
> #
> #   ST is used as the closing delimiter of a control string opened by
> #   APPLICATION PROGRAM COMMAND (APC), DEVICE CONTROL STRING (DCS),
> #   OPERATING SYSTEM COMMAND (OSC), PRIVACY MESSAGE (PM), or START OF STRING
> #   (SOS).
> 
> ... which doesn't define the behaviour for characters 0x00..0x07, 0x0E..0x1F
> or 0x7F..0xFF.  Somehow, using 0x07 for termination became a widespread
> idiom, used more often than proper ESC \.  For this reason, implementations
> I know all recognize 0x07 as a terminator.  The behaviour for other
> characters differs, ie, is truly undefined.
> 
> As, unlike what Ecma-48 says, using 8-bit characters in a window title is a
> reasonable thing to do, I'd allow 0x80..0xFF as non-terminators.  I have no
> idea what to do with remaining control characters: the current patch allows
> them to be interpreted, as it's usually the case for control characters
> inside terminal codes.  I did not research other implementation here.
> 
> I did not recognize 0x9C as ST for two reasons: 1. it'd break non-ASCII
> characters that happen to include this byte, and 2. Linux already fails to
> recognize 8-bit control codes (with one exception: 0x9B stands for ESC [).
> 
> 
> Should I put the above explanation somewhere?  As a comment?  In the commit
> message?  Or does it need to be elaborated even further?

In the commit message would be best.

> > > @@ -2023,6 +2029,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
> > >  		return;
> > >  	default:
> > >  		vc->vc_state = ESnormal;
> > > +	case ESosc:
> > > +		return;
> > 
> > Why below the default: case?
> 
> Just to shave a line and a return statement.  From your objection, I guess
> this goes against the coding standards, right?

Yes it does.
