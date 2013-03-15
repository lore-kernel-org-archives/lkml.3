Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3COUvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:51:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47852 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab3COUur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:50:47 -0400
Date: Fri, 15 Mar 2013 13:50:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jamie Iles <jamie@jamieiles.com>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: Serial port initialization broken on Armada 370/XP due to
 "serial: 8250_dw: Don't use UPF_FIXED_TYPE"
Message-ID: <20130315205044.GA20514@kroah.com>
References: <512E1AD9.4090403@free-electrons.com>
 <512E2F64.2010706@free-electrons.com>
 <20130228092602.GA5688@xps8300>
 <512F428E.3080400@free-electrons.com>
 <20130228123421.GC5688@xps8300>
 <20130315202452.GA15617@kroah.com>
 <20130315203251.GY12700@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315203251.GY12700@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 04:32:51PM -0400, Jason Cooper wrote:
> On Fri, Mar 15, 2013 at 01:24:52PM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Feb 28, 2013 at 02:34:21PM +0200, Heikki Krogerus wrote:
> > > Hi,
> > > 
> > > On Thu, Feb 28, 2013 at 12:42:06PM +0100, Gregory CLEMENT wrote:
> > > > >> Would you agree with this kind of patch to fix the issue?
> > > > >>
> > > > >> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> > > > >> index e2ac25a..0b284c6 100644
> > > > >> --- a/drivers/tty/serial/8250/8250.c
> > > > >> +++ b/drivers/tty/serial/8250/8250.c
> > > > >> @@ -1119,7 +1119,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
> > > > >>         serial_out(up, UART_LCR, 0);
> > > > >>
> > > > >>         serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
> > > > >> -       scratch = serial_in(up, UART_IIR) >> 6;
> > > > >> +       scratch = (serial_in(up, UART_IIR) & 0xFF) >> 6;
> > > > >>
> > > > >>         switch (scratch) {
> > > > >>         case 0:
> > > > > 
> > > > > Instead, can you test if it's enough for you to set the reg-io-width
> > > > > to 1 instead of 4:
> > > > 
> > > > Yes indeed it worked and it seems to be the correct description of my
> > > > hardware. So I will fix the dtsi file.
> > > > 
> > > > However isn't buggy to use a function as it returned a char whereas
> > > > it returns an int?
> > > 
> > > Yes, the driver should probable be cleaned.
> > > 
> > > It seems to be happening in quite a few places in 8250.c.
> > > autoconfig_16550a() has pretty much identical code in it, where
> > > UART_IIR is read to unsigned char and shifted without a mask.
> > 
> > Can someone send me the correct fix here, if they want it included in
> > 3.9-final?
> 
> The fix is in arm-soc/fixes slated for merging into 3.9:

Nice, I like it when I don't have to do anything....

greg k-h
