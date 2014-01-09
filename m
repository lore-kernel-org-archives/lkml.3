Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaAIXIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:08:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39257 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAIXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:08:09 -0500
Date: Fri, 10 Jan 2014 00:08:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Wu <cooloney@gmail.com>
Cc: milo kim <milo.kim@ti.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
Subject: Re: Broken locking in leds-lp5523.c
Message-ID: <20140109230807.GA19974@amd.pavel.ucw.cz>
References: <20140107204233.GA22413@amd.pavel.ucw.cz>
 <CAK5ve-Ju70iOXQXG1B1wVpyDRKjAw_cvmBR5YDM=frppA3iu4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-Ju70iOXQXG1B1wVpyDRKjAw_cvmBR5YDM=frppA3iu4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > There's some locking weirdness, and few missing comments in lp5523
> > driver.
> >
> > Now, this is untested patch from my reverse-engineering. I hope I
> > understood things right...
> >
> > In particular, there's unbalanced unlock in
> > lp5523_update_program_memory, and lp5523_update_program_memory needs
> > to be protected by the lock.
> >
> > Comments? Does someone maintain this?
> 
> I think Milo Kim is maintaining this driver for the LP55xx chip
 > family.

Yes, he's on the Cc list. I was hoping he would comment.

> > -#define LP5523_PROGRAM_LENGTH          32
> > +#define LP5523_PROGRAM_LENGTH          32      /* bytes */
> > +/* Memory is used like this:
> > +   0x00 engine 1 program
> > +   0x10 engine 2 program
> > +   0x20 engine 3 program
> > +   0x30 engine 1 muxing info
> > +   0x40 engine 2 muxing info
> > +   0x50 engine 3 muxing info
> > +   ...and offsets are hard-coded all around :-( */

For example, I'd like to increase limit here -- 62 byte programs
should be feasible AFAICT.

> >  #define LP5523_MAX_LEDS                        9
> >
> >  /* Registers */
> > @@ -265,20 +273,25 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
> >         /* one pattern per engine setting LED MUX start and stop addresses */
> >         static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
> >                 { 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
> > +               /* 9c30 -- mux_map_start(0x30)
> > +                  9cb0 -- mux_ld_end(0x50)
> > +                  9d80 -- mux_sel???(0x00)
> > +                  d800 -- invalid?? */

And it would be good to get comment on what this does. I could not
disassemble/decipher it.

Regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
