Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3LEANZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:13:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55504 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab3LEANX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:13:23 -0500
Date: Thu, 5 Dec 2013 00:13:15 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
Message-ID: <20131205001315.3ac390d6@alan.etchedpixels.co.uk>
In-Reply-To: <529F698C.6040603@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
	<20131203000116.0d512b59@alan.etchedpixels.co.uk>
	<529D4E58.9020101@hurleysoftware.com>
	<20131203142011.371067ea@alan.etchedpixels.co.uk>
	<529F698C.6040603@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not so much confused as simply merged. Input processing is inherently
> single-threaded; it makes sense to rely on that at the highest level
> possible.

I would disagree entirely. You want to minimise the areas affected by a
given lock. You also want to lock data not code. Correctness comes before
speed. You optimise it when its right, otherwise you end up in a nasty
mess when you discover you've optimised to assumptions that are flawed.

> On smp, locked instructions and cache-line contention on the tty_buffer
> list ptrs and read_buf indices account for more than 90% of the time cost
> in the read path for real hardware (and over 95% for ptys).

Yes I'm uncomfortably aware of that for modern SMP hardware, and also
that simply ripping out the buffering will screw the real low end people
(eg M68K and friends)

> Firewire, which is capable of sustained throughput in excess of 40MB/sec,
> struggles to get over 5MB/sec through the tty layer. [And drm output
> is orders-of-magnitude slower than that, which is just sad...]

And what protocols do you care about 5MB/second - n_tty - no ? For the
high speed protocols you are trying to fix a lost cause. By the time
we've gone piddling around with tty buffers and serialized tty queues
firing bytes through tasks and the like you already lost.

For drm I assume you mean the framebuffer console logic ? Last time I
benched that except for the Poulsbo it was bottlenecked on the GPU - not
that I can type at 5MB/second anyway. Not that fixing the performance of
the various bits wouldn't be a good thing too especially on the output
end.

> While that would work, it's expensive extra locking in a path that 99.999%
> of the time doesn't need it. I'd rather explore other solutions.

How about getting the high speed paths out of the whole tty buffer
layer ? Almost every line discipline can be a fastpath directly to the
network layer. If optimisation is the new obsession then we can cut the
crap entirely by optimising for networking not making it a slave of n_tty.

Starting at the beginning

we have locks on rx because
- we want serialized rx
- we have buffer lifetimes
- we have buffer queues
- we have loads of flow control parameters

Only n_tty needs the buffers (maybe some of irda but irda hasn't worked
for years afaik). IRQ receive paths are serialized (and as a bonus can be
pinned to a CPU). Flow control is n_tty stuff, everyone else simply fires
it at their network layer as fast as possible and net already does the
work.

Keep a single tty_buf in the tty for batching at any given time, and
private so no locks at all

Have a wrapper via
ld->receive(tty, buf)

which fires the tty_buf at the ldisc and allocates a new empty one

tty_queue_bytes(tty, buf, flags, len)

which adds to the buffer, and if full calls ld->queue and then carries on
the copying cycle

and

ld->receive_direct(tty, buf, flags, len)

which allows block mode devices to blast bytes directly at the queue (ie
all the USB 3G stuff, firewire, etc) without going via any additional
copies.

For almost all ldiscs

ld->receive would be

ld->receive_direct(tty, buf->buf, buf->flags, buf->len);
free buffer

For n_tty type stuff

ld->receive is basically much of tty_flip_buffer_push

ld->receive_direct allocates tty_buffers and copies into it

We may even be able to optimise some of the n_tty cases into the
fastpath afterwards (notably raw, no echo)

For anything receiving in blocks that puts us close to (but not quite at)
ethernet kinds of cleanness for network buffer delivery.

Worth me looking into ?

> The clock/generation method seems like it might yield a lockless solution
> for this problem, but maybe creates another one because the driver-side
> would need to stamp the buffer (in essence, a flush could affect data
> that has not yet been copied from the driver).

But it has arrived in the driver so might not matter. That requires a
little thought!

Alan
