Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3BGPsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:48:07 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56542 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3BGPsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:48:05 -0500
Message-ID: <5113CCAF.8030600@suse.cz>
Date: Thu, 07 Feb 2013 16:47:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 12/23] tty: Kick waiters _after_ the ldisc is locked
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-13-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-13-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:

The question is obvious: why?

The waiters usually don't care about ldisc.

> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ldisc.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index c903778..8a86a72 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -604,6 +604,12 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
>  
>  	clear_bit(TTY_LDISC, &tty->flags);
>  
> +	/* Wakeup waiters so they can discover the tty is hupping, abort
> +	 * their i/o loops, and release their ldisc references
> +	 */
> +	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
> +	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> +
>  	if (tty->ldisc) {	/* Not yet closed */
>  		tty_unlock(tty);
>  
> @@ -875,12 +881,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
>  		tty_ldisc_deref(ld);
>  	}
>  	/*
> -	 * FIXME: Once we trust the LDISC code better we can wait here for
> -	 * ldisc completion and fix the driver call race
> -	 */
> -	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
> -	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
> -	/*
>  	 * Shutdown the current line discipline, and reset it to
>  	 * N_TTY if need be.
>  	 *
> 


-- 
js
suse labs
