Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3LFJRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:17:15 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:63543 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3LFJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:16:57 -0500
Message-ID: <1386321412.7152.25.camel@host5.omatika.ru>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
From: Sergei Ianovich <ynvich@gmail.com>
To: James Cameron <quozl@laptop.org>
Cc: linux-kernel@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Crispin <blogic@openwrt.org>, Jiri Slaby <jslaby@suse.cz>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Zhou Zhu <zzhu3@marvell.com>
Date: Fri, 06 Dec 2013 13:16:52 +0400
In-Reply-To: <20131206024211.GK16425@us.netrek.org>
References: <20131205043544.GA28580@kroah.com>
	 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
	 <20131206024211.GK16425@us.netrek.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 13:42 +1100, James Cameron wrote:
> On Fri, Dec 06, 2013 at 03:28:37AM +0400, Sergei Ianovich wrote:
> > +/* Uart divisor latch write */
> > +static void serial_pxa_dl_write(struct uart_8250_port *up, int value)
> > +{
> > +	serial_out(up, UART_DLL, value & 0xff);
> > +	serial_out(up, UART_DLM, value >> 8 & 0xff);
> > +}
> 
> This is a change.  drivers/tty/serial/pxa.c did read back UART_DLL as
> an errata work around:
> 
> > -	/*
> > -	 * work around Errata #75 according to Intel(R) PXA27x Processor Family
> > -	 * Specification Update (Nov 2005)
> > -	 */
> > -	dll = serial_in(up, UART_DLL);
> > -	WARN_ON(dll != (quot & 0xff));
> 
> If this is no longer needed, serial_pxa_dl_write can be removed
> because it is same as default_serial_dl_write.

Thanks for spotting this. I prepared infrastructure, but the tests never
failed so I never returned here. I've filed v2 with correct dl_write.

> I did not check the other errata work arounds.

I've intentionally dropped workaround for E20 from old pxa.c
receive_chars(). 8250_core reads FIFO immediately after it checks DR bit
in LSR, so that issue never happens. New version states this in commit
message.

