Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3IYLKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:10:20 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:57680 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYLKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:10:18 -0400
Date: Wed, 25 Sep 2013 13:10:10 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] avr32: balance cpu_idle_poll_ctrl calls
Message-ID: <20130925111010.GA17254@samfundet.no>
References: <1380101479-28358-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380101479-28358-1-git-send-email-juhosg@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 25 Sep 2013 11:31:19 +0200 or thereabout, Gabor Juhos wrote:
> Since commit 01426478df3a8791ff5c8b6b82d409e699cfaf38
> (avr32: Use generic idle loop) the kernel throws the
> following warning on avr32:
> 
>   WARNING: at 900322e4 [verbose debug info unavailable]
>   Modules linked in:
>   CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc2 #117
>   task: 901c3ecc ti: 901c0000 task.ti: 901c0000
>   PC is at cpu_idle_poll_ctrl+0x1c/0x38
>   LR is at comparator_mode+0x3e/0x40
>   pc : [<900322e4>]    lr : [<90014882>]    Not tainted
>   sp : 901c1f74  r12: 00000000  r11: 901c74a0
>   r10: 901d2510  r9 : 00000001  r8 : 901db4de
>   r7 : 901c74a0  r6 : 00000001  r5 : 00410020  r4 : 901db574
>   r3 : 00410024  r2 : 90206fe0  r1 : 00000000  r0 : 007f0000
>   Flags: qvnzc
>   Mode bits: hjmde....G
>   CPU Mode: Supervisor
>   Call trace:
>    [<90039ede>] clockevents_set_mode+0x16/0x2e
>    [<90039f00>] clockevents_shutdown+0xa/0x1e
>    [<9003a078>] clockevents_exchange_device+0x58/0x70
>    [<9003a78c>] tick_check_new_device+0x38/0x54
>    [<9003a1a2>] clockevents_register_device+0x32/0x90
>    [<900035c4>] time_init+0xa8/0x108
>    [<90000520>] start_kernel+0x128/0x23c
> 
> When the 'avr32_comparator' clockevent device is registered,
> the clockevent core sets the mode of that clockevent device
> to CLOCK_EVT_MODE_SHUTDOWN. Due to this, the 'comparator_mode'
> function calls the 'cpu_idle_poll_ctrl' to disables idle poll.
> This results in the aforementioned warning because the polling
> is not enabled yet.
> 
> Change the code to only disable idle poll if it is enabled by
> the same function to avoid the warning.

Thank you for fixing.

> Cc: stable@vger.kernel.org
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
> Note: the patch is against v3.12-rc2.
> ---

I'll add this to my for-linus branch, which I'll send a pull request for
soon.

>  arch/avr32/kernel/time.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
> index 869a1c6..12f828a 100644
> --- a/arch/avr32/kernel/time.c
> +++ b/arch/avr32/kernel/time.c
> @@ -98,7 +98,14 @@ static void comparator_mode(enum clock_event_mode mode,
>  	case CLOCK_EVT_MODE_SHUTDOWN:
>  		sysreg_write(COMPARE, 0);
>  		pr_debug("%s: stop\n", evdev->name);
> -		cpu_idle_poll_ctrl(false);
> +		if (evdev->mode == CLOCK_EVT_MODE_ONESHOT ||
> +		    evdev->mode == CLOCK_EVT_MODE_RESUME) {
> +			/*
> +			 * Only disable idle poll if we have forced that
> +			 * in a previous call.
> +			 */
> +			cpu_idle_poll_ctrl(false);
> +		}
>  		break;
>  	default:
>  		BUG();
-- 
mvh
Hans-Christian Egtvedt
