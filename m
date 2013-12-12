Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3LLD7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 22:59:35 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44886 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339Ab3LLD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 22:59:31 -0500
Message-ID: <52A93498.4030803@hurleysoftware.com>
Date: Wed, 11 Dec 2013 22:59:20 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>	<20131203000116.0d512b59@alan.etchedpixels.co.uk>	<529D4E58.9020101@hurleysoftware.com>	<20131203142011.371067ea@alan.etchedpixels.co.uk>	<529F698C.6040603@hurleysoftware.com> <20131205001315.3ac390d6@alan.etchedpixels.co.uk>
In-Reply-To: <20131205001315.3ac390d6@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 07:13 PM, One Thousand Gnomes wrote:
>> Not so much confused as simply merged. Input processing is inherently
>> single-threaded; it makes sense to rely on that at the highest level
>> possible.
>
> I would disagree entirely. You want to minimise the areas affected by a
> given lock. You also want to lock data not code. Correctness comes before
> speed. You optimise it when its right, otherwise you end up in a nasty
> mess when you discover you've optimised to assumptions that are flawed.

Sorry for the delayed reply, Alan; what little free time I had was spent
snuffing out regressions :/

Sure, I understand that ideally locks protect data, not operations.
But I think maybe you're missing my point. Almost every lock, even at
inception, is somewhat optimized; otherwise, every datum would have its
own lock. Eliminating overlapping locks is a common optimization in stable
code.

In this case, an already broken bit of code is just only still broken.
buf->lock is also fairly simple to break apart (although I don't want to
because of the performance hit) which is not characteristic of locks
which protect operations.


>> Firewire, which is capable of sustained throughput in excess of 40MB/sec,
>> struggles to get over 5MB/sec through the tty layer. [And drm output
>> is orders-of-magnitude slower than that, which is just sad...]
>
> And what protocols do you care about 5MB/second - n_tty - no ? For the
> high speed protocols you are trying to fix a lost cause. By the time
> we've gone piddling around with tty buffers and serialized tty queues
> firing bytes through tasks and the like you already lost.
>
> For drm I assume you mean the framebuffer console logic ? Last time I
> benched that except for the Poulsbo it was bottlenecked on the GPU - not
> that I can type at 5MB/second anyway. Not that fixing the performance of
> the various bits wouldn't be a good thing too especially on the output
> end.

For drm, I actually mean GEM object deletion, which is typically fenced
and thus appears to be GPU-bound. What's really needed there is deferred
deletion, like kfree_rcu(), with partial synchronization on allocation
failures only.

I mostly care about output speed; unfortunately, that's the input side
at the other end :)

>> While that would work, it's expensive extra locking in a path that 99.999%
>> of the time doesn't need it. I'd rather explore other solutions.
>
> How about getting the high speed paths out of the whole tty buffer
> layer ? Almost every line discipline can be a fastpath directly to the
> network layer. If optimisation is the new obsession then we can cut the
> crap entirely by optimising for networking not making it a slave of n_tty.
>
> Starting at the beginning
>
> we have locks on rx because
> - we want serialized rx
> - we have buffer lifetimes
> - we have buffer queues
> - we have loads of flow control parameters
>
> Only n_tty needs the buffers (maybe some of irda but irda hasn't worked
> for years afaik). IRQ receive paths are serialized (and as a bonus can be
> pinned to a CPU). Flow control is n_tty stuff, everyone else simply fires
> it at their network layer as fast as possible and net already does the
> work.
>
> Keep a single tty_buf in the tty for batching at any given time, and
> private so no locks at all
>
> Have a wrapper via
> ld->receive(tty, buf)
>
> which fires the tty_buf at the ldisc and allocates a new empty one
>
> tty_queue_bytes(tty, buf, flags, len)
>
> which adds to the buffer, and if full calls ld->queue and then carries on
> the copying cycle
>
> and
>
> ld->receive_direct(tty, buf, flags, len)
>
> which allows block mode devices to blast bytes directly at the queue (ie
> all the USB 3G stuff, firewire, etc) without going via any additional
> copies.
>
> For almost all ldiscs
>
> ld->receive would be
>
> ld->receive_direct(tty, buf->buf, buf->flags, buf->len);
> free buffer
>
> For n_tty type stuff
>
> ld->receive is basically much of tty_flip_buffer_push
>
> ld->receive_direct allocates tty_buffers and copies into it
>
> We may even be able to optimise some of the n_tty cases into the
> fastpath afterwards (notably raw, no echo)
>
> For anything receiving in blocks that puts us close to (but not quite at)
> ethernet kinds of cleanness for network buffer delivery.
>
> Worth me looking into ?

I have to give this a lot more thought.

The universality of n_tty is important, and costs real cycles on servers and
such. It's not just about typing speed.

>> The clock/generation method seems like it might yield a lockless solution
>> for this problem, but maybe creates another one because the driver-side
>> would need to stamp the buffer (in essence, a flush could affect data
>> that has not yet been copied from the driver).
>
> But it has arrived in the driver so might not matter. That requires a
> little thought!

This is my next experiment.

Regards,
Peter Hurley
