Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaFMUSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:18:42 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:43671 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaFMUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:18:40 -0400
Date: Fri, 13 Jun 2014 23:18:31 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Peter Hurley <peter@hurleysoftware.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Re: Linux 3.15: serial console regression
Message-ID: <20140613201831.GA2360@drone.musicnaut.iki.fi>
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
> On 06/09/2014 04:59 PM, Aaro Koskinen wrote:> Hi,
> > While testing the final 3.15, I noticed the serial console (sunsab)
> > does not work anymore on Sun Ultra.
> > 
> > It will tx fine the console output during the boot. But then I try
> > to type something e.g. at the login: prompt, it behaves oddly:
> > it re-transmits some old output, and then stalls for a few secs, usually
> > for each character. Typed characters are however received correctly.
> > But the console is impossible to use...
> > 
> > I bisected this to:
> > 
> > 717f3bbab3c7628736ef738fdbf3d9a28578c26c is the first bad commit
> > commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
> > Author: Seth Bollinger <sethb@digi.com>
> > Date:   Tue Mar 25 12:55:37 2014 -0500
> > 
> >      serial_core: Fix conditional start_tx on ring buffer not empty
> 
> [Let's try that again. This time without the mess]
> 
> Thanks for the report Aaro.
> 
> Looks like Seth's fix exposes some broken assumptions in the Sun
> serial drivers.

The same problem is present also on PowerPC G5 Xserve (pmac_zilog driver),
and the below type of fix works there too.

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
