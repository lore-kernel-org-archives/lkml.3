Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaL2EZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 23:25:17 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38511 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbaL2EZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 23:25:13 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH 1/2] tty: serial: 8250_mtk: Add earlycon
From: Eddie Huang <eddie.huang@mediatek.com>
To: Rob Herring <robherring2@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, <yingjoe.chen@mediatek.com>,
        <yh.chen@mediatek.com>
In-Reply-To: <CAL_JsqKp+1ZWPK4rB4_vxrx-dtNCy7Hc3S67uQ9VHdAby8erjg@mail.gmail.com>
References: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com>
	 <1418891601-53769-2-git-send-email-eddie.huang@mediatek.com>
	 <CAL_JsqKp+1ZWPK4rB4_vxrx-dtNCy7Hc3S67uQ9VHdAby8erjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Dec 2014 12:24:56 +0800
Message-ID: <1419827096.6184.128.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Fri, 2014-12-26 at 15:24 -0600, Rob Herring wrote:
> On Thu, Dec 18, 2014 at 2:33 AM, Eddie Huang <eddie.huang@mediatek.com> wrote:
> > Mediatek UART has highspeed register, but 8250_early.c doesn't
> > support this, so add earlycon in 8250_mtk.c
> 
> I don't see any highspeed register setup here. More generically,
> aren't you just skipping any UART setup? That may be useful on other
> platforms with 8250s, too. With the kernel command line version, you
> could perhaps add a "noinit" flag. The DT case is harder, and I'm not
> sure how we should handle that. We could perhaps add a
> "stdout-path-initialized" flag to chosen.
> 

Yes, I skipped UART setup same as msm_serial.c and amba-pl011.c
(although they are standalone serial driver). Just like earlyprintk, I
think earlycon should reuse UART setting in loader. Since some other
platforms with 8250 already depend on this, it's ok to add flags to
distinguish whether 8250 earlycon driver should init hw or not. As you
said, add "noinit" flag is simple, but "stdout-path-initialized" need
more discussion. 

> >
> > Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> > ---
> >  drivers/tty/serial/8250/8250_mtk.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> > index de7aae5..65dd569 100644
> > --- a/drivers/tty/serial/8250/8250_mtk.c
> > +++ b/drivers/tty/serial/8250/8250_mtk.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/serial_8250.h>
> >  #include <linux/serial_reg.h>
> > +#include <linux/console.h>
> >
> >  #include "8250.h"
> >
> > @@ -289,6 +290,38 @@ static struct platform_driver mtk8250_platform_driver = {
> >  };
> >  module_platform_driver(mtk8250_platform_driver);
> >
> > +#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
> > +
> > +static void __init mtk8250_serial_putc(struct uart_port *port, int c)
> > +{
> > +       while ((readl(port->membase + (UART_LSR << 2)) & BOTH_EMPTY) !=
> > +               BOTH_EMPTY)
> > +               ;
> > +       writel(c, port->membase + (UART_TX << 2));
> > +}
> > +
> > +static void __init early_mtk8250_write(struct console *console,
> > +                                       const char *s, unsigned int count)
> 
> Is there a reason early_serial8250_write can't work for you other than
> it is currently static?
> 
> Rob
> 

The reason is only static. I want to keep 8250_early.c untouchable, all
modifications in 8250_mtk.c


