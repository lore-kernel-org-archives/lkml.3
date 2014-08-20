Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaHTJX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:23:27 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:50611 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaHTJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:23:25 -0400
X-ASG-Debug-ID: 1408526602-0759e7416b4b140c0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Wed, 20 Aug 2014 11:23:21 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, <balbi@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 03/15] tty: serial: 8250_core: add run time pm
Message-ID: <20140820092319.GA20775@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 03/15] tty: serial: 8250_core: add run time pm
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1408124563-31541-4-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1408526603
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.8645
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 15, 2014 at 07:42:31PM +0200, Sebastian Andrzej Siewior wrote:
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -1899,12 +1984,22 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
>  
>  static int serial8250_get_poll_char(struct uart_port *port)
>  {
> -	unsigned char lsr = serial_port_in(port, UART_LSR);
> +	unsigned char lsr;
> +	int status;
> +
> +	serial8250_rpm_get(up);

or up won't be defined below. You probably need 
+	struct uart_8250_port *up = up_to_u8250p(port);
somewhere in there.

> -	if (!(lsr & UART_LSR_DR))
> -		return NO_POLL_CHAR;
> +	lsr = serial_port_in(port, UART_LSR);
>  
> -	return serial_port_in(port, UART_RX);
> +	if (!(lsr & UART_LSR_DR)) {
> +		status = NO_POLL_CHAR;
> +		goto out;
> +	}
> +
> +	status = serial_port_in(port, UART_RX);
> +out:
> +	serial8250_rpm_put(up);
> +	return status;
>  }

Cheers,
Frans
