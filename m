Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3HQP24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 11:28:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40724 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3HQP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 11:28:55 -0400
Date: Sat, 17 Aug 2013 17:28:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Maximiliano Curia <maxy@debian.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage
 from v2.6.31 onwards
Message-ID: <20130817152853.GA24838@amd.pavel.ucw.cz>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
 <51F1B015.50804@hurleysoftware.com>
 <20130730124117.41DC55E4006@freak.gnuservers.com.ar>
 <51F7E4ED.4050409@hurleysoftware.com>
 <20130808175839.GB21618@gnuservers.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808175839.GB21618@gnuservers.com.ar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > n_tty_set_room() in drivers/tty/n_tty.c (3.10 mainline)
> 
> > From n_tty_set_room():
> 
> > 	/*
> > 	 * If we are doing input canonicalization, and there are no
> > 	 * pending newlines, let characters through without limit, so
> > 	 * that erase characters will be handled.  Other excess
> > 	 * characters will be beeped.
> > 	 */
> > 	if (left <= 0)
> > 		left = ldata->icanon && !ldata->canon_data;
> > 	old_left = tty->receive_room;
> > 	tty->receive_room = left;
> 
> I took a long look at this code and thought about how it could be made to work
> for readline's case and also for the canonical readers.  I came up with this
> simple patch:
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 4bf0fc0..2ba7f4e 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
>          * characters will be beeped.
>          */
>         if (left <= 0)
> -               left = ldata->icanon && !ldata->canon_data;
> +               if (waitqueue_active(&tty->read_wait))
> +                       left = ldata->icanon && !ldata->canon_data;
>         old_left = tty->receive_room;
>         tty->receive_room = left;
> 
> This is of course just an idea, but I tested this and it worked correctly for
> the cases I was testing.
> 
> The effect of this patch is that when there is a canonical reader waiting for
> input, it maintains the previous behavior, but when there's no reader (like
> when readline is changing modes), it blocks and doesn't lose any characters.
> 
> Another approach would be to recalculate the size of canon_data when the mode
> is changed, but this would probably be much more invasive, and awfully less
> efficient since it would imply going through the buffer.
> 
> What do you think? Is the proposed solution, or something along those lines,
> acceptable?
> 
> If there are other cases that need to be taken into account and that I
> currently don't know about, please let me know.

Was this applied? You may want to cc rjw... it is a regression, it is
not pretty, and it is something I blieve I hit but thought it was some
kind of "X weirdness".

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
