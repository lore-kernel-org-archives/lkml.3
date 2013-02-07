Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3BGOun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:50:43 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37741 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3BGOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:50:40 -0500
Message-ID: <5113BF3B.3060307@suse.cz>
Date: Thu, 07 Feb 2013 15:50:35 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 01/23] tty: Add diagnostic for halted line discipline
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-2-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-2-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -375,6 +375,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
>  
>  void tty_ldisc_enable(struct tty_struct *tty)
>  {
> +	clear_bit(TTY_LDISC_HALTED, &tty->flags);
>  	set_bit(TTY_LDISC, &tty->flags);
>  	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
>  	wake_up(&tty_ldisc_wait);
> @@ -498,26 +499,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
>  }
>  
>  /**
> - *	tty_ldisc_halt		-	shut down the line discipline
> - *	@tty: tty device
> - *
> - *	Shut down the line discipline and work queue for this tty device.
> - *	The TTY_LDISC flag being cleared ensures no further references can
> - *	be obtained while the delayed work queue halt ensures that no more
> - *	data is fed to the ldisc.
> - *
> - *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
> - *	in order to make sure any currently executing ldisc work is also
> - *	flushed.
> - */
> -
> -static int tty_ldisc_halt(struct tty_struct *tty)
> -{
> -	clear_bit(TTY_LDISC, &tty->flags);
> -	return cancel_work_sync(&tty->port->buf.work);
> -}
> -
> -/**
>   *	tty_ldisc_flush_works	-	flush all works of a tty
>   *	@tty: tty device to flush works for
>   *
> @@ -547,6 +528,29 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
>  }
>  
>  /**
> + *	tty_ldisc_halt		-	shut down the line discipline
> + *	@tty: tty device
> + *
> + *	Shut down the line discipline and work queue for this tty device.
> + *	The TTY_LDISC flag being cleared ensures no further references can
> + *	be obtained while the delayed work queue halt ensures that no more
> + *	data is fed to the ldisc.
> + *
> + *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
> + *	in order to make sure any currently executing ldisc work is also
> + *	flushed.
> + */
> +
> +static int tty_ldisc_halt(struct tty_struct *tty)
> +{
> +	int scheduled;
> +	clear_bit(TTY_LDISC, &tty->flags);
> +	scheduled = cancel_work_sync(&tty->port->buf.work);
> +	set_bit(TTY_LDISC_HALTED, &tty->flags);
> +	return scheduled;
> +}

Why did you move with that function? It makes the patch unnecessarily
bigger (and harder for a review).

-- 
js
suse labs
