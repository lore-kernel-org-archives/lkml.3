Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3COJY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:24:59 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46348 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3COJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:24:55 -0400
Date: Fri, 15 Mar 2013 10:24:01 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] TTY: fix DTR being raised on hang up
Message-ID: <20130315092401.GB28843@localhost>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
 <1362668153-10972-4-git-send-email-jhovold@gmail.com>
 <1363203823.25976.102.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363203823.25976.102.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 03:43:43PM -0400, Peter Hurley wrote:
> On Thu, 2013-03-07 at 15:55 +0100, Johan Hovold wrote:
> > Make sure to check ASYNC_INITIALISED before raising DTR when waking up
> > from blocked open in tty_port_block_til_ready.
> > 
> > Currently DTR could get raised at hang up as a blocked process would
> > raise DTR unconditionally before checking for hang up and returning.
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  drivers/tty/tty_port.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> > index 3de5918..52f1066 100644
> > --- a/drivers/tty/tty_port.c
> > +++ b/drivers/tty/tty_port.c
> > @@ -355,7 +355,7 @@ int tty_port_block_til_ready(struct tty_port *port,
> >  
> >  	while (1) {
> >  		/* Indicate we are open */
> > -		if (tty->termios.c_cflag & CBAUD)
> > +		if (C_BAUD(tty) && test_bit(ASYNCB_INITIALIZED, &port->flags))
> >  			tty_port_raise_dtr_rts(port);
> >  
> >  		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
> 
> This is ok, but there are 6 other *_block_til_ready() functions:

Yes, but that's not really a comment on this patch, is it?

The purpose of this series is to fix the tty-port implementation, and
I've only touched individual drivers when I had to in order not to break
anything due to changed assumptions.

There's a ton of buggy and odd behaviour to be found once you start
turning the stones. Drivers like the ones below really ought to be
using tty ports and it's helpers.

Thanks,
Johan

> This one doesn't use DTR/RTS so can be ignored:
> ./drivers/staging/sb105x/sb_pci_mp.c:static int mp_block_til_ready(struct file *filp, struct sb_uart_state *state)
> 
> This one is so scary you should probably leave it alone:
> ./drivers/tty/serial/crisv10.c:block_til_ready(struct tty_struct *tty, struct file * filp,
> 
> These will need the same change (although be careful: some use
> ASYNC_INITIALIZED rather than ASYNCB_INITIALIZED).
> ./drivers/tty/synclinkmp.c:static int block_til_ready(struct tty_struct *tty, struct file *filp,
> ./drivers/tty/synclink_gt.c:static int block_til_ready(struct tty_struct *tty, struct file *filp,
> ./drivers/tty/synclink.c:static int block_til_ready(struct tty_struct *tty, struct file * filp,
> ./net/irda/ircomm/ircomm_tty.c:static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,

