Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbaGQPMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:12:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:36813 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaGQPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:12:05 -0400
Message-ID: <53C7E7BE.7030403@linutronix.de>
Date: Thu, 17 Jul 2014 17:11:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-6-git-send-email-bigeasy@linutronix.de> <20140717145430.GF10459@saruman.home>
In-Reply-To: <20140717145430.GF10459@saruman.home>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 04:54 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jul 16, 2014 at 04:45:03PM +0200, Sebastian Andrzej Siewior wrote:
>> +static int omap_8250_startup(struct uart_port *port)
>> +{
>> +	struct uart_8250_port *up =
>> +		container_of(port, struct uart_8250_port, port);
>> +	struct omap8250_priv *priv = port->private_data;
>> +
>> +	int ret;
>> +
>> +	if (priv->wakeirq) {
>> +		ret = request_irq(priv->wakeirq, omap_wake_irq,
>> +				port->irqflags, "wakeup irq", port);
>> +		if (ret)
>> +			return ret;
>> +		disable_irq(priv->wakeirq);
>> +	}
>> +
>> +	ret = serial8250_do_startup(port);
>> +	if (ret)
>> +		goto err;
>> +
>> +	pm_runtime_get_sync(port->dev);
> 
> should this pm_runtime_get_sync() be placed above
> serial8250_do_startup() call ?

I don't think it matters since serial8250_do_startup() has its own
pm_runtime_get_sync().

->startup(), ->shutdown() are called via omap callbacks so we could
spare in the 8250-core if we do it in the omap code before invoking the
function. The same goes for serial8250_set_termios() which is not used
by omap but has those runtime-pm stuff, too.
It would be wrong if someone would use the serial8250_do_startup()
without his own runtime-pm get but it is omap only which does this
things.
So it is not used by anyone else (right now) and if you want to keep it
to a minimum I could remove them from those places.

Sebastian
