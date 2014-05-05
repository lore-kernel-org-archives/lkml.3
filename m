Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbaEEPDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:03:20 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49091 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbaEEPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:03:17 -0400
From: Peter Korsgaard <peter@korsgaard.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: uartlite: Specify time for sending chars
References: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com>
Date: Mon, 05 May 2014 17:03:12 +0200
In-Reply-To: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com>
	(Michal Simek's message of "Mon, 5 May 2014 16:48:26 +0200")
Message-ID: <874n14i7yn.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <michal.simek@xilinx.com> writes:

 > Xilinx MDM (Microblaze Debug Module) also contains
 > uart interface via JTAG which is compatible with
 > uartlite driver. This interface is really slow
 > that's why timeout is setup to 1s.

 > Make this time delay not to be cpu speed dependent.

 > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
 > ---

 > RFC sent here:
 > https://lkml.org/lkml/2013/9/30/250
 > I finally got HW design which is just slow to be able
 > to test it.

 > ---
 >  drivers/tty/serial/uartlite.c | 10 ++++++++--
 >  1 file changed, 8 insertions(+), 2 deletions(-)

 > diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
 > index 5f90ef24d475..723a6b79cd14 100644
 > --- a/drivers/tty/serial/uartlite.c
 > +++ b/drivers/tty/serial/uartlite.c
 > @@ -418,14 +418,20 @@ static struct uart_ops ulite_ops = {
 >  #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
 >  static void ulite_console_wait_tx(struct uart_port *port)
 >  {
 > -	int i;
 >  	u8 val;
 > +	unsigned long timeout;

 >  	/* Spin waiting for TX fifo to have space available */
 > -	for (i = 0; i < 100000; i++) {

It would be good to add a note about the slow jtag variant here.

Otherwise:

Acked-by: Peter Korsgaard <peter@korsgaard.com>

 > +	timeout = jiffies + msecs_to_jiffies(1000);
 > +	while (1) {
 >  		val = uart_in32(ULITE_STATUS, port);
 >  		if ((val & ULITE_STATUS_TXFULL) == 0)
 >  			break;
 > +		if (time_after(jiffies, timeout)) {
 > +			dev_warn(port->dev,
 > +				 "timeout waiting for TX buffer empty\n");
 > +			break;
 > +		}
 >  		cpu_relax();
 >  	}
 >  }
 > --
 > 1.8.2.3


-- 
Bye, Peter Korsgaard
