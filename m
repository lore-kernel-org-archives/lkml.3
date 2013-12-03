Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LCDWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:22:11 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40022 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739Ab3LCDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:22:08 -0500
Message-ID: <529D4E58.9020101@hurleysoftware.com>
Date: Mon, 02 Dec 2013 22:22:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com> <20131203000116.0d512b59@alan.etchedpixels.co.uk>
In-Reply-To: <20131203000116.0d512b59@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 07:01 PM, One Thousand Gnomes wrote:
>> I cc'd you because of your recent involvement in other
>> tty patches/bug fixes and because it's your FIXME comment.
>> Feel free to ignore and/or let me know you would prefer not to
>> be bothered.
>
> It does seem horribly convoluted and likely to dig bigger long term holes
> than the one its filling. The tty layer has suffered far too much from
> "dodging one bullet by being clever and then getting shot at twice more"

Alan,

Thanks for the feedback.

I think any solution will be seriously constrained by the larger design
choice; the simplicity and performance of direct writes into a shared
buffer has trade-offs.

I chose what I felt was the simplest route; the code itself is
straightforward. Maybe I could move the locking documentation into the
changelog instead?

Setting aside the parallel flush interface complications (which in some
form is necessary even with a shared lock), there are a limited number
of solutions to concurrent pty buffer flushes:
1. Leave it broken.
2. As submitted.
3. Drop the buf->lock before flushing. This was the other solution I
    seriously considered, because a parallel flush interface would not
    be necessary then.
    The problem with this solution is that input processing would need
    to be aborted and restarted in case the current buffer data had been
    flushed in parallel while the buf->lock was unowned; this requires
    bubbling up return values from n_tty_receive_break() and
    n_tty_receive_signal_char(), plus the actual processed char count
    would need to propagate as well.
4. Do the flush in flush_to_ldisc(). This is variation on 3, because
    current input processing would still need to abort. This solution
    suffers in that the echo may still be deferred, since at the time
    of processing the signal, the other pty write buffer may still be
    full.
5. Probably a few others I haven't thought of.

 > Bigger question (and one I'm not going to try and untangle at quarter to
 > midnight). Is there any reason that the buffer locking has to be per tty
 > not a shared lock in some cases.

I'm not sure what kind of impact a partial half-duplex pty design would
really have.

> My thinking is that we never sit hogging the buffer lock for long periods
> (even though someone has now made it a mutex which seems an odd
> performance choice)

Uncontended mutex lock performance is on-par with uncontended spinlock;
both use a single bus-locked r/m/w instruction.

The buffer lock is mostly uncontended because it only excludes the
consumer-side; ie., only excludes flush_to_ldisc() from tty_buffer_flush().
The driver-side doesn't use buf->lock for access.

The use of a mutex for buf->lock allows the n_tty_receive_buf() path to
claim a read lock on termios changes with a r/w semaphore, termios_rwsem.

> and it is the deepest lock in the subsystem we take
>
> So:
>
> if the tty_buffer contained a mutex and a pointer to that mutex then for
> the pty pairs you could set them to point to the same mutex but default
> to separate mutexes.
>
> At that point you swap all the locks on the mutex to simply lock through
> the pointer, you don't need the nested hack and there are no special case
> paths or uglies in the general code.

To claim the buf->lock in any form from within the receive_buf() path
will require some construct that informs the pty driver's flush_buffer()
method that the buf->lock has already been claimed; otherwise,
double-claim deadlock.

These types of nested lock problems are common when different layers use
the same interface (the fb subsystem's use of the vt driver is another
example).

> The only special is that pty init
> paths set the points to both point at the same mutex and no kittens die.

I like the ptr-to-a-shadow-lock idiom, thanks for sharing.

Regards,
Peter Hurley

