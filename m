Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaEVKFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:05:45 -0400
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:60604 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbaEVKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <1400751910-5519-1-git-send-email-jjhiblot@traphandler.com>
References: <1400751910-5519-1-git-send-email-jjhiblot@traphandler.com>
Date: Thu, 22 May 2014 11:56:58 +0200
Message-ID: <CACh+v5Na+GpW_LPi4UTxbv4DhFRqm2+hT8JYkUPzBdTb=qYNfQ@mail.gmail.com>
Subject: Re: [PATCH] PREEMPT_RT: USB serial gadget: Fix locking issue
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "jon.povey" <jon.povey@racelogic.co.uk>,
        gregkh <gregkh@linuxfoundation.org>, balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 14550285972972132376
X-Ovh-Remote: 209.85.213.173 (mail-ig0-f173.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

damn ! I just realized I sent the broken patch. It won't compile.
The right version is comming soon.

2014-05-22 11:45 GMT+02:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> With CONFIG_PREEMPT_RT_FULL the tty_flip_buffer_push(..) actions are executed
> immeditely (same behaviour as if low_latency flag was set). We thus have to
> release port_lock before callng tty_flip_buffer_push().
>
> This issue resultst of commits:
> 44a0c019: USB: g_serial: don't set low_latency flag
> dc0cbd1b: serial: 8250: Call flush_to_ldisc when the irq is threaded
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/usb/gadget/u_serial.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index b369292..1c4f404 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -549,12 +549,25 @@ static void gs_rx_push(unsigned long _port)
>                 port->read_started--;
>         }
>
> -       /* Push from tty to ldisc; without low_latency set this is handled by
> -        * a workqueue, so we won't get callbacks and can hold port_lock
> -        */
> -       if (do_push)
> +       /* Push from tty to ldisc */
> +       if (do_push) {
> +#ifndef CONFIG_PREEMPT_RT_FULL
> +               /* without low_latency set this is handled by a workqueue, so
> +                * we won't get callbacks and can hold port_lock
> +               */
>                 tty_flip_buffer_push(&port->port);
> -
> +#else
> +               /* CONFIG_PREEMPT_RT_FULL makes this a synchronous action. and
> +                * it may trigger synchronous callbacks to this driver. We need
> +                * to release the lock.
> +               */
> +               spin_unlock_irq(&port->port_lock);
> +               tty_flip_buffer_push(&port->port);
> +               spin_lock_irq(&port->port_lock);
> +               /* tty may have been closed */
> +               tty = port->port_tty;
> +#endif
> +       }
>
>         /* We want our data queue to become empty ASAP, keeping data
>          * in the tty and ldisc (not here).  If we couldn't push any
> --
> 1.9.2
>
