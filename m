Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaGJG2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:28:14 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33673 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGJG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:28:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19tf4YDWF+ehJ9fNIIk2c0m
Date: Wed, 9 Jul 2014 23:28:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, mika.westerberg@linux.intel.com
Subject: Re: [PATCH 3/6] tty: serial: 8250 core: add runtime pm
Message-ID: <20140710062812.GF28884@atomide.com>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
 <1404928177-26554-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404928177-26554-4-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140709 10:52]:
> While comparing the OMAP-serial and the 8250 part of this I noticed that
> the the latter does not use runtime-pm. Here are the pieces. It is
> basically a get before first register access and a last_busy + put after
> last access.
> If I understand this correct, it should do nothing as long as
> pm_runtime_use_autosuspend() + pm_runtime_enable() isn't invoked on the
> device.
...

> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -571,7 +573,17 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>  			serial_out(p, UART_EFR, 0);
>  			serial_out(p, UART_LCR, 0);
>  		}
> +
> +		if (!device_may_wakeup(p->port.dev)) {
> +			if (sleep)
> +				pm_runtime_forbid(p->port.dev);
> +			else
> +				pm_runtime_allow(p->port.dev);
> +		}
>  	}
> +out:
> +	pm_runtime_mark_last_busy(p->port.dev);
> +	pm_runtime_put_autosuspend(p->port.dev);
>  }

The device_may_wakeup logic here is wrong as I described in the
earlier thread. For runtime PM, the wake-up events should be
always enabled. So the device_may_wakeup checks should be only
done for suspend and resume.

Regards,

Tony
