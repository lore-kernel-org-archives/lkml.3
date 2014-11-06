Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaKFXTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:19:12 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60329 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaKFXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:19:07 -0500
Date: Fri, 7 Nov 2014 00:11:46 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, cascardo@linux.vnet.ibm.com, markh@compro.net,
        devel@driverdev.osuosl.org, lidza.louina@gmail.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers: serial: jsm: Add the Classic board
 implementation
Message-ID: <20141106231146.GB29761@t400>
References: <20141103093800.GK6879@mwanda>
 <1415040760-12172-1-git-send-email-bergo.torino@gmail.com>
 <1415040760-12172-2-git-send-email-bergo.torino@gmail.com>
 <20141106191808.GA32427@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141106191808.GA32427@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Greg KH wrote:
> On Mon, Nov 03, 2014 at 07:52:38PM +0100, Konrad Zapalowicz wrote:
> > This commit adds the Digi Classic board implementation to the
> > staging/jsm driver.
> > 
> > The code here is taken from the staging/dgnc driver and modified to
> > match the serial/jsm state. This work is mostly based on the changes
> > that has been done to the code handling the Digi Neo cards with the
> > inspiration coming from the diff between staging/dgnc and serial/jsm
> > as well as the LKML history for the jsm_neo.c
> > 
> > The code compiles now and has no sparse and checkpatch errors or
> > warnings.
> 
> The compiler does give me one warning for this file:
> 
> > +/*
> > + * cls_param()
> > + * Send any/all changes to the line to the UART.
> > + */
> > +static void cls_param(struct jsm_channel *ch)
> > +{
> > +	u8 lcr = 0;
> > +	u8 uart_lcr = 0;
> > +	u8 ier = 0;
> > +	u32 baud = 9600;
> > +	int quot = 0;
> > +	struct jsm_board *bd;
> > +	int i;
> > +	unsigned int cflag;
> > +
> > +	bd = ch->ch_bd;
> > +	if (!bd)
> > +		return;
> > +
> > +	/*
> > +	 * If baud rate is zero, flush queues, and set mval to drop DTR.
> > +	 */
> > +	if ((ch->ch_c_cflag & (CBAUD)) == 0) {
> > +		ch->ch_r_head = 0;
> > +		ch->ch_r_tail = 0;
> > +		ch->ch_e_head = 0;
> > +		ch->ch_e_tail = 0;
> > +
> > +		cls_flush_uart_write(ch);
> > +		cls_flush_uart_read(ch);
> > +
> > +		/* The baudrate is B0 so all modem lines are to be dropped. */
> > +		ch->ch_flags |= (CH_BAUD0);
> > +		ch->ch_mostat &= ~(UART_MCR_RTS | UART_MCR_DTR);
> > +		cls_assert_modem_signals(ch);
> > +		return;
> > +	}
> > +
> > +	static struct {
> > +		unsigned int rate;
> > +		unsigned int cflag;
> > +	} baud_rates[] = {
> > +		{ 921600, B921600 },
> > +		{ 460800, B460800 },
> > +		{ 230400, B230400 },
> > +		{ 115200, B115200 },
> > +		{  57600, B57600  },
> > +		{  38400, B38400  },
> > +		{  19200, B19200  },
> > +		{   9600, B9600   },
> > +		{   4800, B4800   },
> > +		{   2400, B2400   },
> > +		{   1200, B1200   },
> > +		{    600, B600    },
> > +		{    300, B300    },
> > +		{    200, B200    },
> > +		{    150, B150    },
> > +		{    134, B134    },
> > +		{    110, B110    },
> > +		{     75, B75     },
> > +		{     50, B50     },
> > +	};
> 
> baud_rates needs to be up above the code, as gcc tells me:
> 
> drivers/tty/serial/jsm/jsm_cls.c: In function ‘cls_param’:
> drivers/tty/serial/jsm/jsm_cls.c:701:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
>   static struct {
>   ^
> 
> Can you fix that up and resend the series?  I've taken the first patch in this
> series, as that is an easy one to accept, so no need to resend that one.

Fixed and delivered. You may notice that the jsm_neo.c code is using
the same structure to store the baud rates. If feels natural to change
it there too however since the subject of this series is the support for
Classic boards I decided not to refactor this now. I'll do it properly later
plus I will fix some other things that I have spotted so far in this
code.

cheers,
konrad
 
> thanks,
> 
> greg k-h
