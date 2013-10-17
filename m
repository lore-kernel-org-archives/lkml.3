Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3JQVMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:12:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3JQVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:12:37 -0400
Date: Thu, 17 Oct 2013 14:12:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/Serial fixes for 3.12-rc4
Message-ID: <20131017211236.GA6155@kroah.com>
References: <20131005173403.GA4811@kroah.com>
 <CA+55aFzEtnOOB4yPbWg4tmvWTPjQL1_YsZks6wgpGimaQdOEtA@mail.gmail.com>
 <5250A74E.4070805@hurleysoftware.com>
 <5250C6CD.1040803@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5250C6CD.1040803@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 10:11:25PM -0400, Peter Hurley wrote:
> On 10/05/2013 07:57 PM, Peter Hurley wrote:
> >On 10/05/2013 02:53 PM, Linus Torvalds wrote:
> >>On Sat, Oct 5, 2013 at 10:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>
> >>>One fixes the reported regression in the n_tty code that a number of
> >>>people found recently
> >>
> >>That one looks broken.
> >>
> >>Well, it looks like it might "work", but do so by hiding the issue for
> >>one case, while leaving it in the more general case.
> >>
> >>Why does it do that
> >>
> >>     up_read(&tty->termios_rwsem);
> >>     tty_flush_to_ldisc(tty);
> >>     down_read(&tty->termios_rwsem);
> >>
> >>only if TTY_OTHER_CLOSED is set? If flushing the ldisc can generate
> >>more data, then we should do it *unconditionally* when we see that we
> >>currently have no data to read.
> >>
> >>As it is, it looks like the patch fixes the TTY_OTHER_CLOSED case
> >>("read all pending data before returning -EIO"), but it leaves the
> >>same broken case for the O_NONBLOCK case and for a hung up tty.
> >>
> >>The O_NONBLOCK case is presumably just a performance problem (the data
> >>will come at _some_ point later), but it just looks bad in general.
> >>And the tty_hung_up_p() looks actiely buggy, with the same bug as the
> >>TTY_OTHER_CLOSED case that the patch tried to fix.
> >>
> >>Hmm? Am I missing something?
> 
> Apologies, I realized I didn't address the O_NONBLOCK case.
> 
> My reasoning for excluding O_NONBLOCK is that tty_flush_to_ldisc()
> _waits_ for flush_to_ldisc() to complete. In the worst (admittedly
> contrived) case, this could be unbounded running time: a sufficiently
> fast source could keep flush_to_ldisc() running forever by writing
> 4K chars and then 4k backspaces, ad infinitum.
> 
> 
> >When a slave pty is closed, it's not hung up specifically so the
> >master pty can be read.
> >
> >The same is not true for a regular tty; when a regular tty is hung up,
> >all the pending data is vaporized (ie., what the tty layer refers
> >to as 'flushed'). So checking for more data when tty_hung_up_p() is
> >true is pointless.
> >
> >The distinction is clearer when you consider that even after the slave
> >pty is closed, the master pty can still be read() even if it wasn't
> >waiting in n_tty_read() at the time; this is not true of a regular tty, which
> >cannot be read() after a hangup [tty_hung_up_p() tests if the
> >file_operations pointer is set to non-operational read/write/ioctl functions].
> >
> >The patch fixes a race condition which is peculiar to ptys only.
> >
> >>The code is a bit confusing in *other* ways too: if you look later, it
> >>does this:
> >>
> >>     n_tty_set_room(tty);
> >>
> >>which is documented to have to happen inside the termios_rwsem.
> >>HOWEVER, what does that do? It actually does an _asynchronous_
> >>queue_work() of &tty->port->buf.work, in case there is now more room,
> >>and the previous one was blocked. And guess what that workqueue is all
> >>about? Right: it's flush_to_ldisc() - which is the work that
> >>tty_flush_to_ldisc() is trying to flush. So we're actually basically
> >>making sure we've flush the previous pending work.
> >
> >The flush_to_ldisc() worker no longer re-schedules itself.
> >
> >The flush_to_ldisc() worker is scheduled when one of two events
> >happen; 1) the driver has just written received data to the tty
> >buffers, or 2) space has just become available in the N_TTY line
> >discipline's read buffer when it was previously full.
> >
> >The flush_to_ldisc() worker continues to run as long as space
> >is available in the line discipline's read buffer or until the
> >tty buffers are empty.
> >
> >Concurrently with the flush_to_ldisc() worker, a reader may have
> >an empty read buffer; the flush_to_ldisc() worker may or may not
> >generate more input to be read.
> >
> >Generally when a reader has an empty read buffer, it will sleep unless
> >one of the other conditions is met (TTY_OTHER_CLOSED, tty_hung_up_p,
> >non-blocking, etc).
> >
> >Before sleeping, the reader will (re-)schedule the flush_to_ldisc()
> >worker in case it read some input on the previous loop iteration
> >(thus creating space in the read buffer when there was none previously).
> >
> >(That doesn't preclude that flush_to_ldisc() may already be running
> >but isn't processing as fast as the reader is reading.)
> >
> >
> >>So even the tty_flush_to_ldisc(tty) that gets done in that patch is
> >>not necessarily sufficient, because the work might not have been
> >>scheduled because the flip buffer used to be full. Then flushing the
> >>work won't do anything, even though there is actually more data. Now,
> >>that is a very unlikely situation (I think it requires two concurrent
> >>readers), but it looks like it might be real.
> >
> >I don't think this condition is possible for a single reader (because
> >the read condition will be satisfied and the reader will return).
> >Multiple concurrent readers are excluded by the atomic_read_lock mutex
> >at the the top of n_tty_read().
> 
> However, the atomic_read_lock exclusion needs to cover the
> unconditional n_tty_set_room() when leaving n_tty_read() and
> it doesn't. Thus, the departing reader fails to ensure the subsequent
> reader has a running flush_to_ldisc() worker.
> 
> Patch forthcoming.

Did I miss this patch, or did it not come forth?

thanks,

greg k-h
