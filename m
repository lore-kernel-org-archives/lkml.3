Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaE3GRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:17:12 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:36994
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754812AbaE3GRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:17:08 -0400
Date: Fri, 30 May 2014 12:53:46 +0800
From: Huang Shijie <b32955@freescale.com>
To: Dirk Behme <dirk.behme@gmail.com>
CC: <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: imx: disable the receiver ready interrupt
 for imx_stop_rx
Message-ID: <20140530045344.GA13338@shlinux1.ap.freescale.net>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
 <1400819575-20435-2-git-send-email-b32955@freescale.com>
 <53881C99.1090207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53881C99.1090207@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(77982001)(99396002)(54356999)(47776003)(80022001)(46102001)(33656002)(92566001)(77096999)(81542001)(76482001)(76176999)(50986999)(4396001)(6806004)(31966008)(81342001)(83506001)(92726001)(79102001)(85852003)(74502001)(97756001)(20776003)(97736001)(44976005)(74662001)(23726002)(46406003)(102836001)(19580395003)(84676001)(68736004)(83322001)(83072002)(19580405001)(64706001)(87936001)(26826002)(50466002)(104016001)(21056001)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB360;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02272225C5
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 07:52:25AM +0200, Dirk Behme wrote:
> On 23.05.2014 06:32, Huang Shijie wrote:
> >This patch disables the receiver ready interrupt for imx_stop_rx.
> >It reduces the interrupt numbers when the uart is going to close
> >or suspend.
> >
> >Signed-off-by: Huang Shijie <b32955@freescale.com>
> >---
> >  drivers/tty/serial/imx.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> >index ed6cdf7..6026101 100644
> >--- a/drivers/tty/serial/imx.c
> >+++ b/drivers/tty/serial/imx.c
> >@@ -440,6 +440,10 @@ static void imx_stop_rx(struct uart_port *port)
> >
> >  	temp = readl(sport->port.membase + UCR2);
> >  	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
> >+
> >+	/* disable the `Receiver Ready Interrrupt` */
> >+	temp = readl(sport->port.membase + UCR1);
> >+	writel(temp & ~UCR1_RRDYEN, sport->port.membase + UCR1);
> 
> Will this change cause a loss or a processing delay of RX characters
> pending in the RX FIFO ?
> 
> It is not clear whether disabling the receiver will clear the RX
> FIFO. My guess is that the contents of the RX FIFO will remain
> intact when the receiver is disabled. The RX interrupt has an
> opportunity to mop up these pending characters in the RX FIFO but
> disabling the RX interrupt has potential to leave those characters
> in the RX FIFO. Does it matter ?
When the @stop_rx() is called, the system(or the application) is closing
or suspending, and it has decided to abandon the RX data. 

So i think it do not matter the RX FIFO has some left data.
We will reset the RX FIFO when the UART port is re-started again.

thanks
Huang Shijie
