Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3BGPMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:12:00 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37695 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3BGPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:11:56 -0500
Message-ID: <5113C438.1000709@suse.cz>
Date: Thu, 07 Feb 2013 16:11:52 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 04/23] tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-5-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-5-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:
> Refactor tty_ldisc_hangup() to extract standalone function,
> tty_ldisc_hangup_wait_idle(), to wait for ldisc references
> to be released.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ldisc.c | 54 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 904bf75..70d2b86 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -551,6 +551,41 @@ static int tty_ldisc_halt(struct tty_struct *tty)
>  }
>  
>  /**
> + *	tty_ldisc_hangup_wait_idle - wait for the ldisc to become idle
> + *	@tty: tty to wait for
> + *
> + *	Wait for the line discipline to become idle. The discipline must
> + *	have been halted for this to guarantee it remains idle.
> + *
> + *	Caller must hold legacy and ->ldisc_mutex.
> + */
> +static bool tty_ldisc_hangup_wait_idle(struct tty_struct *tty)
> +{
> +	while (tty->ldisc) {	/* Not yet closed */
> +		if (atomic_read(&tty->ldisc->users) != 1) {
> +			char cur_n[TASK_COMM_LEN], tty_n[64];
> +			long timeout = 3 * HZ;
> +			tty_unlock(tty);
> +
> +			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
> +				timeout = MAX_SCHEDULE_TIMEOUT;
> +				printk_ratelimited(KERN_WARNING
> +					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
> +					__func__, get_task_comm(cur_n, current),
> +					tty_name(tty, tty_n));
> +			}
> +			/* must reacquire both locks and preserve lock order */
> +			mutex_unlock(&tty->ldisc_mutex);
> +			tty_lock(tty);
> +			mutex_lock(&tty->ldisc_mutex);
> +			continue;
> +		}
> +		break;

That continue and break at the end of the loop look weird.

What about:
while (tty->ldisc) {
  if (atomic_read(&tty->ldisc->users) == 1)
     break;
  THE_REST_OF_THE_BODY_WITHOUT_CONTINUE
}

Or even:
while (tty->ldisc && atomic_read(&tty->ldisc->users) != 1) {
  THE_REST_OF_THE_BODY_WITHOUT_CONTINUE
}

For me, this does not look so hard to understand as it is w/ cont+brk now.

And now, when we have a separate function, the declarations would look
nicer to be at the beginning of the function.

> +	}
> +	return !!(tty->ldisc);

Just a nit, the parenthesis are not needed.

-- 
js
suse labs
