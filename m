Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3LCOU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:20:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LCOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:20:22 -0500
Date: Tue, 3 Dec 2013 14:20:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
Message-ID: <20131203142011.371067ea@alan.etchedpixels.co.uk>
In-Reply-To: <529D4E58.9020101@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
	<20131203000116.0d512b59@alan.etchedpixels.co.uk>
	<529D4E58.9020101@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These types of nested lock problems are common when different layers use
> the same interface (the fb subsystem's use of the vt driver is another
> example).

They are, and they end up nasty and eventually become impossible to fix.
Better to fix the underlying fundamental error as and when we can. The
current state of vt and fb and drm and handling accelerated scrolling of
a quota warning on drm on fb on vt is a testimony to what happens if you
don't go back and fix it properly now and then.

In this case I would argue there is a fundamental error. That is trying to
combine locking of the structures for buffers and locking the receive
path. It's a mistake and I don't see how you can properly clean up the
tty layer with that mix of high and low level lock in one. It's already
turned into a hackfest with buf->priority.

The old code wasn't the right answer either but did isolate the locks
better.


We've got three confused locks IMHO all stuck in as one

- integrity of the buffer queue
- lifetime of a buffer (don't free a buffer as someone else is
  processing it)
- serialization of flush_to_ldisc

(as an aside it was historically always required that a low_latency
caller correctly implemented its own serialization because you can't
really get that locking totally clean except in the driver either)


It's a bit of a drastic rethink of the idiom but the networking layer
basically does this, and has to solve exactly the same problem space


	while((buf = tty_buffer_dequeue(port)) != NULL) {
		if (receive_buf(tty, buf) < 0) {
			tty_buffer_requeue_head(port, buf);
			break;
		}
	}

tty_buffer_dequeue is trivial enough, tty_buffer_requeue_head is also
trivial because we are single threading flush_to_ldisc. Flushing just
requires ensuring we don't requeue the buffer so we have

	tty_buffer_requeue_head(port, buf)
	{
		lock(&port->buf.lock);
		if (port->buf.clock == buf->clock)
			requeue;
		else
			kfree
	}

	tty_buffer_flush(port)
	{
		port->buf.clock++;
		free buffers in queue
	}

Flush is trivial - increment clock, empty queue. The lifetime handling
will ensure the current buffer is either processed or returned but not
requeued.

Queuing data is also trivial - we just add to the buffer that is at the
end of the queue, or start a new buffer if empty. The requeue_head will
deal with the rest of it automagically

Downsides - slightly more locking, probably several things I've missed.

Upsides - tty buffer locking is clear and self contained, we invoke
flush_to_ldisc without holding what are really low level locks, queue
manipulation in flush_to_ldisc works just like anywhere else. The buffer
is owned by the tty which means the tty must free it, which means the tty
can 'borrow' a buffer for ldisc internal queueing without having to copy
all the bytes and we get the backpressure on the queue for free as the
network layer does.

It does mean touching every ldisc but as far as I can see with the
exception of n_tty the change in each case is (as usual) trivial.

As a PS: I think the termios is probably an RCU problem. The semaphore
seemed to make sense when I did it, but in hindsight I think I made the
wrong call.

Alan
