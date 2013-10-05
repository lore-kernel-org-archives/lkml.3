Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3JESxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:53:54 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49174 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3JESxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <20131005173403.GA4811@kroah.com>
References: <20131005173403.GA4811@kroah.com>
Date: Sat, 5 Oct 2013 11:53:52 -0700
X-Google-Sender-Auth: abDJQIDLL2LR0SF1ZT6EXfbr_hY
Message-ID: <CA+55aFzEtnOOB4yPbWg4tmvWTPjQL1_YsZks6wgpGimaQdOEtA@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/Serial fixes for 3.12-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 10:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> One fixes the reported regression in the n_tty code that a number of
> people found recently

That one looks broken.

Well, it looks like it might "work", but do so by hiding the issue for
one case, while leaving it in the more general case.

Why does it do that

    up_read(&tty->termios_rwsem);
    tty_flush_to_ldisc(tty);
    down_read(&tty->termios_rwsem);

only if TTY_OTHER_CLOSED is set? If flushing the ldisc can generate
more data, then we should do it *unconditionally* when we see that we
currently have no data to read.

As it is, it looks like the patch fixes the TTY_OTHER_CLOSED case
("read all pending data before returning -EIO"), but it leaves the
same broken case for the O_NONBLOCK case and for a hung up tty.

The O_NONBLOCK case is presumably just a performance problem (the data
will come at _some_ point later), but it just looks bad in general.
And the tty_hung_up_p() looks actiely buggy, with the same bug as the
TTY_OTHER_CLOSED case that the patch tried to fix.

Hmm? Am I missing something?

The code is a bit confusing in *other* ways too: if you look later, it
does this:

    n_tty_set_room(tty);

which is documented to have to happen inside the termios_rwsem.
HOWEVER, what does that do? It actually does an _asynchronous_
queue_work() of &tty->port->buf.work, in case there is now more room,
and the previous one was blocked. And guess what that workqueue is all
about? Right: it's flush_to_ldisc() - which is the work that
tty_flush_to_ldisc() is trying to flush. So we're actually basically
making sure we've flush the previous pending work.

So even the tty_flush_to_ldisc(tty) that gets done in that patch is
not necessarily sufficient, because the work might not have been
scheduled because the flip buffer used to be full. Then flushing the
work won't do anything, even though there is actually more data. Now,
that is a very unlikely situation (I think it requires two concurrent
readers), but it looks like it might be real.

So I suspect we should *unconditionally* do

     n_tty_set_room(tty);
     up_read(&tty->termios_rwsem);
     tty_flush_to_ldisc(tty);
     down_read(&tty->termios_rwsem);

if we don't have any pending input. And then test input_available_p()
again. And only if we don't have any input after that flushing do we
start doing the whole TTY_OTHER_CLOSED and tty_hung_up_p() tests.

Hmm?

            Linus
