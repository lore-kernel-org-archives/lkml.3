Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3HLNUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:20:49 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37679 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3HLNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:20:45 -0400
Date: Mon, 12 Aug 2013 16:19:49 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH tty-next] n_tty: Fix termios_rwsem lockdep false positive
Message-ID: <20130812131949.GA2297@swordfish>
References: <20130731114726.GA11570@cpv436-motbuntu.spb.ea.mot-mobility.com>
 <1376222663-5666-1-git-send-email-peter@hurleysoftware.com>
 <20130812092810.GA26400@cpv436-motbuntu.spb.ea.mot-mobility.com>
 <20130812105041.GA2268@swordfish>
 <5208DB32.40304@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208DB32.40304@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/12/13 08:55), Peter Hurley wrote:
> >>> [..]
> >>>  drivers/tty/n_tty.c | 25 +++++++++++--------------
> >>>  1 file changed, 11 insertions(+), 14 deletions(-)
> >>>
> >
> >I hate to do this, but isn't it actually my patch posted here
> >https://lkml.org/lkml/2013/8/1/510
> >
> >which was tagged as `wrong'?
> 
> Sergey,
> 
> My apologies; I was mistaken regarding this problem being a lockdep
> regression (although it's still a false positive from lockdep). Once
> I had worked around some issues with the nouveau driver, I was able to
> reproduce the lockdep report on 3.10.
>
no problem.

> I included Artem's lockdep report in the changelog because I received
> that first, on 30 July.
>
> My patch below is not the same as your patch of 1 Aug. This patch
> preserves the protected access of termios.c_cc[VMIN] and termios.c_cc[VTIME]
> (via the MIN_CHAR() and TIME_CHAR() macros).

fair enough. v3 was protecting VMIN/VTIME (my bad, I noticed this a bit later),
but I didn't submit it since v2 did not get positive response.

> If you'd prefer, I could add to changelog:
> 
>    Patch based on original posted here https://lkml.org/lkml/2013/8/1/510
>    by Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

if you don't mind, that would be great.

thanks a lot,
	-ss

> Regards,
> Peter Hurley
> 
> 
> >>>diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> >>>index dd8ae0c..c9a9ddd 100644
> >>>--- a/drivers/tty/n_tty.c
> >>>+++ b/drivers/tty/n_tty.c
> >>>@@ -2122,6 +2122,17 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >>>  	if (c < 0)
> >>>  		return c;
> >>>
> >>>+	/*
> >>>+	 *	Internal serialization of reads.
> >>>+	 */
> >>>+	if (file->f_flags & O_NONBLOCK) {
> >>>+		if (!mutex_trylock(&ldata->atomic_read_lock))
> >>>+			return -EAGAIN;
> >>>+	} else {
> >>>+		if (mutex_lock_interruptible(&ldata->atomic_read_lock))
> >>>+			return -ERESTARTSYS;
> >>>+	}
> >>>+
> >>>  	down_read(&tty->termios_rwsem);
> >>>
> >>>  	minimum = time = 0;
> >>>@@ -2141,20 +2152,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >>>  		}
> >>>  	}
> >>>
> >>>-	/*
> >>>-	 *	Internal serialization of reads.
> >>>-	 */
> >>>-	if (file->f_flags & O_NONBLOCK) {
> >>>-		if (!mutex_trylock(&ldata->atomic_read_lock)) {
> >>>-			up_read(&tty->termios_rwsem);
> >>>-			return -EAGAIN;
> >>>-		}
> >>>-	} else {
> >>>-		if (mutex_lock_interruptible(&ldata->atomic_read_lock)) {
> >>>-			up_read(&tty->termios_rwsem);
> >>>-			return -ERESTARTSYS;
> >>>-		}
> >>>-	}
> >>>  	packet = tty->packet;
> >>>
> >>>  	add_wait_queue(&tty->read_wait, &wait);
> >>>--
> >>>1.8.1.2
> >>>
> >>
> >>--
> >>Regards,
> >>     Artem
> >>
> 
