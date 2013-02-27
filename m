Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3B0TwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:52:18 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:37243 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715Ab3B0TwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:52:16 -0500
Date: Wed, 27 Feb 2013 20:52:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Enhanced support for MPC8xx/8xxx watchdog
Message-ID: <20130227195214.GC7867@spo001.leaseweb.com>
References: <201302131519.r1DFJtGm032487@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302131519.r1DFJtGm032487@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christophe,

> This patch modifies the behaviour of the MPC8xx/8xxx watchdog. On the MPC8xx,
> at 133Mhz, the maximum timeout of the watchdog timer is 1s, which means it must
> be pinged twice a second. This is not in line with the Linux watchdog concept
> which is based on a default watchdog timeout around 60s.
> This patch introduces an intermediate layer between the CPU and the userspace.
> The kernel pings the watchdog at the required frequency at the condition that
> userspace tools refresh it regularly.
> The new parameter 'heartbeat' allows to set up the userspace timeout.
> The driver also implements the WDIOC_SETTIMEOUT ioctl.

No, no, no... we should standardise on naming. heartbeat should be the thing that
actually keeps the dog alive, whereas timeout is the userspace timeout that the user
can play with...

> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> diff -ur linux-3.7.7/drivers/watchdog/mpc8xxx_wdt.c linux/drivers/watchdog/mpc8xxx_wdt.c
> --- linux-3.7.7/drivers/watchdog/mpc8xxx_wdt.c	2013-02-11 18:05:09.000000000 +0100
> +++ linux/drivers/watchdog/mpc8xxx_wdt.c	2013-02-13 15:55:22.000000000 +0100
> @@ -52,10 +52,17 @@
>  static struct mpc8xxx_wdt __iomem *wd_base;
>  static int mpc8xxx_wdt_init_late(void);
>  
> +#define WD_TIMO 10			/* Default heartbeat = 10 seconds */
> +
> +static int heartbeat = WD_TIMO;
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat,
> +	"Watchdog SW heartbeat in seconds. (0 < heartbeat < 65536s, default="
> +				__MODULE_STRING(WD_TIMO) "s)");

and the userspace timeout should be an unsigned int to be honoust.

>  static u16 timeout = 0xffff;
>  module_param(timeout, ushort, 0);
>  MODULE_PARM_DESC(timeout,
> -	"Watchdog timeout in ticks. (0<timeout<65536, default=65535)");
> +	"Watchdog HW timeout in ticks. (0<timeout<65536, default=65535)");
>  
>  static bool reset = 1;
>  module_param(reset, bool, 0);
> @@ -74,8 +81,10 @@
>  static int prescale = 1;
>  static unsigned int timeout_sec;
>  
> +static int wdt_auto = 1;
>  static unsigned long wdt_is_open;
>  static DEFINE_SPINLOCK(wdt_spinlock);
> +static unsigned long wdt_last_ping;
>  
>  static void mpc8xxx_wdt_keepalive(void)
>  {
> @@ -91,9 +100,20 @@
>  
>  static void mpc8xxx_wdt_timer_ping(unsigned long arg)
>  {
> -	mpc8xxx_wdt_keepalive();
> -	/* We're pinging it twice faster than needed, just to be sure. */
> -	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
> +	if (wdt_auto)
> +		wdt_last_ping = jiffies;
> +
> +	if (jiffies - wdt_last_ping <= heartbeat * HZ) {
> +		mpc8xxx_wdt_keepalive();
> +		/* We're pinging it twice faster than needed, to be sure. */
> +		mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
> +	}
> +}
> +
> +static void mpc8xxx_wdt_sw_keepalive(void)
> +{
> +	wdt_last_ping = jiffies;
> +	mpc8xxx_wdt_timer_ping(0);
>  }
>  
>  static void mpc8xxx_wdt_pr_warn(const char *msg)
> @@ -106,7 +126,7 @@
>  				 size_t count, loff_t *ppos)
>  {
>  	if (count)
> -		mpc8xxx_wdt_keepalive();
> +		mpc8xxx_wdt_sw_keepalive();
>  	return count;
>  }
>  
> @@ -130,7 +150,7 @@
>  
>  	out_be32(&wd_base->swcrr, tmp);
>  
> -	del_timer_sync(&wdt_timer);
> +	wdt_auto = 0;
>  
>  	return nonseekable_open(inode, file);
>  }
> @@ -138,7 +158,8 @@
>  static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
>  {
>  	if (!nowayout)
> -		mpc8xxx_wdt_timer_ping(0);
> +		wdt_auto = 1;
> +
>  	else
>  		mpc8xxx_wdt_pr_warn("watchdog closed");
>  	clear_bit(0, &wdt_is_open);
> @@ -163,10 +184,12 @@
>  	case WDIOC_GETBOOTSTATUS:
>  		return put_user(0, p);
>  	case WDIOC_KEEPALIVE:
> -		mpc8xxx_wdt_keepalive();
> +		mpc8xxx_wdt_sw_keepalive();
>  		return 0;
>  	case WDIOC_GETTIMEOUT:
> -		return put_user(timeout_sec, p);
> +		return put_user(heartbeat, p);
> +	case WDIOC_SETTIMEOUT:
> +		return get_user(heartbeat, p);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -215,6 +238,8 @@
>  		ret = -ENOSYS;
>  		goto err_unmap;
>  	}
> +	if (enabled)
> +		timeout = in_be32(&wd_base->swcrr) >> 16;
>  
>  	/* Calculate the timeout in seconds */
>  	if (prescale)
> @@ -273,6 +298,7 @@
>  		.compatible = "fsl,mpc823-wdt",
>  		.data = &(struct mpc8xxx_wdt_type) {
>  			.prescaler = 0x800,
> +			.hw_enabled = true,
>  		},
>  	},
>  	{},

The rest of the code is OK and when above comments are corrected,
I will add the patch to improve the userspace experience.

Kind regards,
Wim.

