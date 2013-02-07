Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3BGPyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:54:09 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:57827 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758656Ab3BGPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:54:07 -0500
Message-ID: <1360252434.4102.37.camel@thor.lan>
Subject: Re: [PATCH v3 01/23] tty: Add diagnostic for halted line discipline
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Thu, 07 Feb 2013 10:53:54 -0500
In-Reply-To: <5113BF3B.3060307@suse.cz>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-2-git-send-email-peter@hurleysoftware.com>
	 <5113BF3B.3060307@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 15:50 +0100, Jiri Slaby wrote:
> On 02/05/2013 09:20 PM, Peter Hurley wrote:
> > --- a/drivers/tty/tty_ldisc.c
> > +++ b/drivers/tty/tty_ldisc.c
> > @@ -375,6 +375,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
> >  
> >  void tty_ldisc_enable(struct tty_struct *tty)
> >  {
> > +	clear_bit(TTY_LDISC_HALTED, &tty->flags);
> >  	set_bit(TTY_LDISC, &tty->flags);
> >  	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
> >  	wake_up(&tty_ldisc_wait);
> > @@ -498,26 +499,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
> >  }
> >  
> >  /**
> > - *	tty_ldisc_halt		-	shut down the line discipline
> > - *	@tty: tty device
> > - *
> > - *	Shut down the line discipline and work queue for this tty device.
> > - *	The TTY_LDISC flag being cleared ensures no further references can
> > - *	be obtained while the delayed work queue halt ensures that no more
> > - *	data is fed to the ldisc.
> > - *
> > - *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
> > - *	in order to make sure any currently executing ldisc work is also
> > - *	flushed.
> > - */
> > -
> > -static int tty_ldisc_halt(struct tty_struct *tty)
> > -{
> > -	clear_bit(TTY_LDISC, &tty->flags);
> > -	return cancel_work_sync(&tty->port->buf.work);
> > -}
> > -
> > -/**
> >   *	tty_ldisc_flush_works	-	flush all works of a tty
> >   *	@tty: tty device to flush works for
> >   *
> > @@ -547,6 +528,29 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
> >  }
> >  
> >  /**
> > + *	tty_ldisc_halt		-	shut down the line discipline
> > + *	@tty: tty device
> > + *
> > + *	Shut down the line discipline and work queue for this tty device.
> > + *	The TTY_LDISC flag being cleared ensures no further references can
> > + *	be obtained while the delayed work queue halt ensures that no more
> > + *	data is fed to the ldisc.
> > + *
> > + *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
> > + *	in order to make sure any currently executing ldisc work is also
> > + *	flushed.
> > + */
> > +
> > +static int tty_ldisc_halt(struct tty_struct *tty)
> > +{
> > +	int scheduled;
> > +	clear_bit(TTY_LDISC, &tty->flags);
> > +	scheduled = cancel_work_sync(&tty->port->buf.work);
> > +	set_bit(TTY_LDISC_HALTED, &tty->flags);
> > +	return scheduled;
> > +}
> 
> Why did you move with that function? It makes the patch unnecessarily
> bigger (and harder for a review).

07/23 starts using tty_wait_for_idle() in tty_ldisc_halt().

Should I split this?



