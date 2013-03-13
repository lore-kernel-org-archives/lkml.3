Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3CMTn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:43:57 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39797 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3CMTny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:43:54 -0400
Message-ID: <1363203823.25976.102.camel@thor.lan>
Subject: Re: [PATCH v3 3/6] TTY: fix DTR being raised on hang up
From: Peter Hurley <peter@hurleysoftware.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 15:43:43 -0400
In-Reply-To: <1362668153-10972-4-git-send-email-jhovold@gmail.com>
References: <51361724.4050107@suse.cz>
	 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
	 <1362668153-10972-4-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 15:55 +0100, Johan Hovold wrote:
> Make sure to check ASYNC_INITIALISED before raising DTR when waking up
> from blocked open in tty_port_block_til_ready.
> 
> Currently DTR could get raised at hang up as a blocked process would
> raise DTR unconditionally before checking for hang up and returning.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/tty/tty_port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 3de5918..52f1066 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -355,7 +355,7 @@ int tty_port_block_til_ready(struct tty_port *port,
>  
>  	while (1) {
>  		/* Indicate we are open */
> -		if (tty->termios.c_cflag & CBAUD)
> +		if (C_BAUD(tty) && test_bit(ASYNCB_INITIALIZED, &port->flags))
>  			tty_port_raise_dtr_rts(port);
>  
>  		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);

This is ok, but there are 6 other *_block_til_ready() functions:

This one doesn't use DTR/RTS so can be ignored:
./drivers/staging/sb105x/sb_pci_mp.c:static int mp_block_til_ready(struct file *filp, struct sb_uart_state *state)

This one is so scary you should probably leave it alone:
./drivers/tty/serial/crisv10.c:block_til_ready(struct tty_struct *tty, struct file * filp,

These will need the same change (although be careful: some use
ASYNC_INITIALIZED rather than ASYNCB_INITIALIZED).
./drivers/tty/synclinkmp.c:static int block_til_ready(struct tty_struct *tty, struct file *filp,
./drivers/tty/synclink_gt.c:static int block_til_ready(struct tty_struct *tty, struct file *filp,
./drivers/tty/synclink.c:static int block_til_ready(struct tty_struct *tty, struct file * filp,
./net/irda/ircomm/ircomm_tty.c:static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,

Please be sure to Cc: David Miller <davem@davemloft.net> on changes to
net/irda.

Regards,
Peter Hurley

