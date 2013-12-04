Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3LDRmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:42:42 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44758 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932167Ab3LDRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:42:40 -0500
Message-ID: <529F698C.6040603@hurleysoftware.com>
Date: Wed, 04 Dec 2013 12:42:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>	<20131203000116.0d512b59@alan.etchedpixels.co.uk>	<529D4E58.9020101@hurleysoftware.com> <20131203142011.371067ea@alan.etchedpixels.co.uk>
In-Reply-To: <20131203142011.371067ea@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 09:20 AM, One Thousand Gnomes wrote:
>> These types of nested lock problems are common when different layers use
>> the same interface (the fb subsystem's use of the vt driver is another
>> example).
>
> They are, and they end up nasty and eventually become impossible to fix.
> Better to fix the underlying fundamental error as and when we can. The
> current state of vt and fb and drm and handling accelerated scrolling of
> a quota warning on drm on fb on vt is a testimony to what happens if you
> don't go back and fix it properly now and then.
>
> In this case I would argue there is a fundamental error. That is trying to
> combine locking of the structures for buffers and locking the receive
> path. It's a mistake and I don't see how you can properly clean up the
> tty layer with that mix of high and low level lock in one. It's already
> turned into a hackfest with buf->priority.
>
> The old code wasn't the right answer either but did isolate the locks
> better.
>
>
> We've got three confused locks IMHO all stuck in as one
>
> - integrity of the buffer queue
> - lifetime of a buffer (don't free a buffer as someone else is
>    processing it)
> - serialization of flush_to_ldisc

Not so much confused as simply merged. Input processing is inherently
single-threaded; it makes sense to rely on that at the highest level
possible.

On smp, locked instructions and cache-line contention on the tty_buffer
list ptrs and read_buf indices account for more than 90% of the time cost
in the read path for real hardware (and over 95% for ptys).

Firewire, which is capable of sustained throughput in excess of 40MB/sec,
struggles to get over 5MB/sec through the tty layer. [And drm output
is orders-of-magnitude slower than that, which is just sad...]

buf->priority isn't a hackfest; it's a zero-cost-in-read-path mechanism
for interrupting input processing, similar to the clock (or generation)
approach.

Although using locks is satisfyingly symmetrical, input processing vs.
buffer flush is an asymmetric problem.

> (as an aside it was historically always required that a low_latency
> caller correctly implemented its own serialization because you can't
> really get that locking totally clean except in the driver either)
>
>
> It's a bit of a drastic rethink of the idiom but the networking layer
> basically does this, and has to solve exactly the same problem space
>
>
> 	while((buf = tty_buffer_dequeue(port)) != NULL) {
> 		if (receive_buf(tty, buf) < 0) {
> 			tty_buffer_requeue_head(port, buf);
> 			break;
> 		}
> 	}
>
> tty_buffer_dequeue is trivial enough, tty_buffer_requeue_head is also
> trivial because we are single threading flush_to_ldisc. Flushing just
> requires ensuring we don't requeue the buffer so we have
>
> 	tty_buffer_requeue_head(port, buf)
> 	{
> 		lock(&port->buf.lock);
> 		if (port->buf.clock == buf->clock)
> 			requeue;
> 		else
> 			kfree
> 	}
>
> 	tty_buffer_flush(port)
> 	{
> 		port->buf.clock++;
> 		free buffers in queue
> 	}
>
> Flush is trivial - increment clock, empty queue. The lifetime handling
> will ensure the current buffer is either processed or returned but not
> requeued.
>
> Queuing data is also trivial - we just add to the buffer that is at the
> end of the queue, or start a new buffer if empty. The requeue_head will
> deal with the rest of it automagically
>
> Downsides - slightly more locking, probably several things I've missed.
>
> Upsides - tty buffer locking is clear and self contained, we invoke
> flush_to_ldisc without holding what are really low level locks, queue
> manipulation in flush_to_ldisc works just like anywhere else. The buffer
> is owned by the tty which means the tty must free it, which means the tty
> can 'borrow' a buffer for ldisc internal queueing without having to copy
> all the bytes and we get the backpressure on the queue for free as the
> network layer does.
>
> It does mean touching every ldisc but as far as I can see with the
> exception of n_tty the change in each case is (as usual) trivial.

While that would work, it's expensive extra locking in a path that 99.999%
of the time doesn't need it. I'd rather explore other solutions.

The clock/generation method seems like it might yield a lockless solution
for this problem, but maybe creates another one because the driver-side
would need to stamp the buffer (in essence, a flush could affect data
that has not yet been copied from the driver).

Still, it might be worth seeing if a solution lies in scheduling only
one flush_to_ldisc() per tty_buffer (per port) and letting it sleep
if receive_buf() can't accept more data [N_TTY would awaken the worker
instead of queueing it].

Regards,
Peter Hurley
