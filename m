Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3BEVEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:04:31 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54191 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755778Ab3BEVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:04:29 -0500
Message-ID: <1360098260.3298.27.camel@thor.lan>
Subject: Re: [PATCH v3 16/23] tty: Make core responsible for synchronizing
 its work
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Tue, 05 Feb 2013 16:04:20 -0500
In-Reply-To: <1360095638-6624-17-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-17-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 15:20 -0500, Peter Hurley wrote:
> The tty core relies on the ldisc layer for synchronizing destruction
> of the tty. Instead, the final tty release must wait for any pending tty
> work to complete prior to tty destruction.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_io.c    | 17 +++++++++++++++++
>  drivers/tty/tty_ldisc.c | 24 ++++--------------------
>  2 files changed, 21 insertions(+), 20 deletions(-)

...

> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index e0fdfec..c2837b2 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -499,18 +499,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
>  }
>  
>  /**
> - *	tty_ldisc_flush_works	-	flush all works of a tty
> - *	@tty: tty device to flush works for
> - *
> - *	Sync flush all works belonging to @tty.
> - */
> -static void tty_ldisc_flush_works(struct tty_struct *tty)
> -{
> -	flush_work(&tty->SAK_work);
> -	flush_work(&tty->hangup_work);
> -}
> -
> -/**
>   *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
>   *	@tty: tty to wait for
>   *	@timeout: for how long to wait at most
> @@ -726,13 +714,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  	retval = tty_ldisc_halt(tty, o_tty, &work, &o_work, 5 * HZ);
>  
>  	/*
> -	 * Wait for ->hangup_work to terminate.
> +	 * Wait for hangup to complete, if pending.
>  	 * We must drop the mutex here in case a hangup is also in process.
>  	 */
>  
>  	mutex_unlock(&tty->ldisc_mutex);
>  
> -	tty_ldisc_flush_works(tty);
> +	flush_work(&tty->hangup_work);

Careful review will note that I dropped waiting for SAK. That's because
it makes no sense to wait for SAK_work here -- ie., while setting a new
ldisc. The SAK work can just as easily run at the completion of
tty_set_ldisc() at tty_unlock().

I believe this is an artifact of the formerly shared code.

But maybe I should note that in the commit message?


