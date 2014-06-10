Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaFJSxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:53:39 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:49174 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFJSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:53:20 -0400
Date: Tue, 10 Jun 2014 21:53:11 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Re: Linux 3.15: SPARC serial console regression
Message-ID: <20140610185310.GB913@drone.musicnaut.iki.fi>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
 <1402357697-20976-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402357697-20976-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 09, 2014 at 07:48:17PM -0400, Peter Hurley wrote:
> Looks like Seth's fix exposes some broken assumptions in the Sun
> serial drivers.

Thanks, that seems to fix the issue.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

> PS - Do you have a way to test also your setup using hardware flow
> control, ie. CRTSCTS?  I ask because I would expect that to be broken
> even before Seth's patch.

Sorry, I'm unable do that at the moment.

A.

> --- %< ---
> From: Peter Hurley <peter@hurleysoftware.com>
> Date: Mon, 9 Jun 2014 19:21:43 -0400
> Subject: [PATCH] serial: sunsab: Test for no tx data on tx restart
> 
> Commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
> 'serial_core: Fix conditional start_tx on ring buffer not empty'
> exposes an incorrect assumption in sunsab's start_tx method; the
> tx ring buffer can, in fact, be empty when restarting tx when
> performing flow control.
> 
> Test for empty tx ring buffer when in sunsab's start_tx method.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/sunsab.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
> index 5faa8e9..b99a4ea 100644
> --- a/drivers/tty/serial/sunsab.c
> +++ b/drivers/tty/serial/sunsab.c
> @@ -427,6 +427,9 @@ static void sunsab_start_tx(struct uart_port *port)
>  	struct circ_buf *xmit = &up->port.state->xmit;
>  	int i;
>  
> +	if (uart_circ_empty(xmit))
> +		return;
> +
>  	up->interrupt_mask1 &= ~(SAB82532_IMR1_ALLS|SAB82532_IMR1_XPR);
>  	writeb(up->interrupt_mask1, &up->regs->w.imr1);
>  	
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
