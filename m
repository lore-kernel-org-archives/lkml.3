Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3BHDRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:17:13 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55074 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759602Ab3BHDRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:17:11 -0500
Message-ID: <1360293418.3544.83.camel@thor.lan>
Subject: Re: [PATCH v3 12/23] tty: Kick waiters _after_ the ldisc is locked
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Thu, 07 Feb 2013 22:16:58 -0500
In-Reply-To: <5113CCAF.8030600@suse.cz>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-13-git-send-email-peter@hurleysoftware.com>
	 <5113CCAF.8030600@suse.cz>
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

On Thu, 2013-02-07 at 16:47 +0100, Jiri Slaby wrote:
> On 02/05/2013 09:20 PM, Peter Hurley wrote:
> 
> The question is obvious: why?
> 
> The waiters usually don't care about ldisc.

This patch really needed a decent commit message, but this isn't a fix,
per se.

While I was auditing the ldisc hangup, I realized that when a reader is
woken from sleeping in n_tty_read() and loops back around because there
is more room in the reader's buffer (nr > 0), input_available_p() will
schedule buffer work and wait for it to complete before testing if the
tty is hung up.

This change ensures that flush_to_ldisc() sees a halted ldisc and
promptly returns.  A blocking reader whose read_buf is empty is the most
likely state when a hangup occurs.

I didn't include it tty_ldisc_halt(), because tty_set_ldisc() can't kick
readers out of their i/o loops and tty_ldisc_release() has no waiters.

Even if the change is nixed, the comments should be changed; the FIXME
is from before waiting for readers to exit their i/o loops.

---- separate but related discussion ----

Another thing to note is this really does nothing to address the problem
of a slave pty being unable to read all the data written by the master,
if the master is closed with a lot of data in the tty buffer. In this
case, when the slave is hungup as a result of the master closing, it's
ldisc will be halted, preventing the tty_buffer from pushing more data. 

In my opinion, this is an important fixme.  Almost as important as
replacing the TTY_LDISC flag + reference count with a rwsem to get
lockdep support...


> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > ---
> >  drivers/tty/tty_ldisc.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> > index c903778..8a86a72 100644
> > --- a/drivers/tty/tty_ldisc.c
> > +++ b/drivers/tty/tty_ldisc.c
> > @@ -604,6 +604,12 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
> >  
> >  	clear_bit(TTY_LDISC, &tty->flags);
> >  
> > +	/* Wakeup waiters so they can discover the tty is hupping, abort
> > +	 * their i/o loops, and release their ldisc references
> > +	 */
> > +	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
> > +	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> > +
> >  	if (tty->ldisc) {	/* Not yet closed */
> >  		tty_unlock(tty);
> >  
> > @@ -875,12 +881,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
> >  		tty_ldisc_deref(ld);
> >  	}
> >  	/*
> > -	 * FIXME: Once we trust the LDISC code better we can wait here for
> > -	 * ldisc completion and fix the driver call race
> > -	 */
> > -	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
> > -	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> > -	/*
> >  	 * Shutdown the current line discipline, and reset it to
> >  	 * N_TTY if need be.
> >  	 *
> > 
> 
> 


