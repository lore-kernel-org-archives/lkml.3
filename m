Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaHLN5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:57:40 -0400
Received: from sym2.noone.org ([178.63.92.236]:40863 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaHLN5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:57:38 -0400
Date: Tue, 12 Aug 2014 15:57:34 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Alan Cox <alan@linux.intel.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tty: serial: 8250: Add Mediatek UART driver
Message-ID: <20140812135734.GD512@distanz.ch>
References: <1407497524-26535-1-git-send-email-matthias.bgg@gmail.com>
 <1407497524-26535-2-git-send-email-matthias.bgg@gmail.com>
 <20140808122820.GF29832@distanz.ch>
 <CABuKBeK8shJWD5rT3diYReWQyBbCUmDfeT-oT2uF9ZrJAAf+eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABuKBeK8shJWD5rT3diYReWQyBbCUmDfeT-oT2uF9ZrJAAf+eg@mail.gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-12 at 15:31:51 +0200, Matthias Brugger <matthias.bgg@gmail.com> wrote:
> 2014-08-08 14:28 GMT+02:00 Tobias Klauser <tklauser@distanz.ch>:
> > On 2014-08-08 at 13:32:03 +0200, Matthias Brugger <matthias.bgg@gmail.com> wrote:
> >> This patch adds support for the UART block found on Mediatek SoCs.
> >> The device has a highspeed register which influences the calcualtion of the
> >> divisor. The chip lacks support for some baudrates. When requested, we set the
> >> divisor to the next smaller baudrate and adjust the c_cflag accordingly.
> >>
> >> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> >> ---
> >>  drivers/tty/serial/8250/8250_mtk.c |  296 ++++++++++++++++++++++++++++++++++++
> >>  drivers/tty/serial/8250/Kconfig    |    7 +
> >>  drivers/tty/serial/8250/Makefile   |    1 +
> >>  3 files changed, 304 insertions(+)
> >>  create mode 100644 drivers/tty/serial/8250/8250_mtk.c
> >>
> >> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> >> new file mode 100644
> >> index 0000000..d63080b
> >> --- /dev/null
> >> +++ b/drivers/tty/serial/8250/8250_mtk.c
> >> @@ -0,0 +1,296 @@
> >
> > [...]
> >
> >> +static int mtk8250_probe(struct platform_device *pdev)
> >> +{
> >> +     struct uart_8250_port uart = {};
> >> +     struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +     struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +     struct mtk8250_data *data;
> >> +     int err;
> >> +
> >> +     if (!regs || !irq) {
> >> +             dev_err(&pdev->dev, "no registers/irq defined\n");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     spin_lock_init(&uart.port.lock);
> >> +     uart.port.mapbase = regs->start;
> >> +     uart.port.irq = irq->start;
> >> +     uart.port.pm = mtk8250_do_pm;
> >> +     uart.port.type = PORT_16550;
> >> +     uart.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
> >> +     uart.port.dev = &pdev->dev;
> >> +
> >> +     uart.port.membase = devm_ioremap(&pdev->dev, regs->start,
> >> +                                      resource_size(regs));
> >> +     if (!uart.port.membase)
> >> +             return -ENOMEM;
> >
> > You can use devm_ioremap_resource here and get rid of the check for
> > !regs above, since devm_ioremap_resource already does that.
> >
> >         regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >
> >         ...
> >
> >         uart.port.membase = devm_ioremap_resource(&pdev->dev, regs);
> >         if (IS_ERR(uart.port.membase))
> >                 return PTR_ERR(uart.port.membase);
> >
> 
> devm_ioremap_resource creates a busy resource region in the
> iomem_resource. This leads the UART to silently fail.
> I suppose that's why 8250_dw.c uses devm_ioremap instead of
> devm_ioremap_resource. The 8250_dw has the same issue.

Ah yes, of course. Sorry about that.

Thanks
Tobias
