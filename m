Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaI2Jq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:46:26 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:34231 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2JqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:46:24 -0400
X-ASG-Debug-ID: 1411983982-0759e74bdc530f60002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 29 Sep 2014 11:46:20 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <mika.westerberg@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/16] tty: serial: 8250_core: add run time pm
Message-ID: <20140929094620.GE13952@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 02/16] tty: serial: 8250_core: add run time pm
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1410377411-26656-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411983982
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10016
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:29:57PM +0200, Sebastian Andrzej Siewior wrote:
> +/*
> + * This two wrapper ensure, that enable_runtime_pm_tx() can be called more than

These two wrappers ensure that enable_runtime_pm_tx() ...

> + * once and disable_runtime_pm_tx() will still disable RPM because the fifo is
> + * empty and the HW can idle again.
> + */
> +static void serial8250_rpm_get_tx(struct uart_8250_port *p)
> +{
> +	unsigned char rpm_active;
> +
> +	if (!(p->capabilities & UART_CAP_RPM))
> +		return;
> +
> +	rpm_active = xchg(&p->rpm_tx_active, 1);
> +	if (rpm_active)
> +		return;
> +	pm_runtime_get_sync(p->port.dev);
> +}
> +
> +static void serial8250_rpm_put_tx(struct uart_8250_port *p)
> +{
> +	unsigned char rpm_active;
> +
> +	if (!(p->capabilities & UART_CAP_RPM))
> +		return;
> +
> +	rpm_active = xchg(&p->rpm_tx_active, 0);
> +	if (!rpm_active)
> +		return;
> +	pm_runtime_mark_last_busy(p->port.dev);
> +	pm_runtime_put_autosuspend(p->port.dev);
> +}
> +


> @@ -1469,7 +1531,12 @@ void serial8250_tx_chars(struct uart_8250_port *up)
>  
>  	DEBUG_INTR("THRE...");
>  
> -	if (uart_circ_empty(xmit))
> +	/*
> +	 * With RPM enabled, we have to wait once the FIFO is empty before the

s,once,until,? Or do I not understand the sentence correctly?

> +	 * HW can go idle. So we get here once again with empty FIFO and disable
> +	 * the interrupt and RPM in __stop_tx()
> +	 */
> +	if (uart_circ_empty(xmit) && !(up->capabilities & UART_CAP_RPM))
>  		__stop_tx(up);
>  }
>  EXPORT_SYMBOL_GPL(serial8250_tx_chars);
