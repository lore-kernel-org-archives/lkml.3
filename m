Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaDOWig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:38:36 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:41453 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDOWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <1396538615-9128-1-git-send-email-jon@ringle.org>
References: <1396538615-9128-1-git-send-email-jon@ringle.org>
Date: Tue, 15 Apr 2014 18:38:31 -0400
X-Google-Sender-Auth: I5s5Ctbtd_wIFJ2ue4v2FEK4GtU
Message-ID: <CAMwGMjxnVhGanbG-2NNr5ekA489qJsc+J6hyLv+zyMCq+o=LVg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] serial: sc16is7xx
From: Jon Ringle <jon@ringle.org>
To: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 11:23 AM,  <jon@ringle.org> wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>
> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> high performance UART. The SC16IS7xx's internal register set is
> backward-compatible with the widely used and widely popular 16C450.
>
> The SC16IS7xx also provides additional advanced features such as
> auto hardware and software flow control, automatic RS-485 support, and
> software reset.
>
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/tty/serial/Kconfig       |    9 +
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sc16is7xx.c   | 1302 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  4 files changed, 1315 insertions(+)
>  create mode 100644 drivers/tty/serial/sc16is7xx.c
>
[snip]

> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> new file mode 100644
> index 0000000..20d96cc
> --- /dev/null
> +++ b/drivers/tty/serial/sc16is7xx.c
[snip]

> +static bool sc16is7xx_regmap_writeable(struct device *dev, unsigned int reg)
> +{
> +       switch (reg >> SC16IS7XX_REG_SHIFT) {
> +       case SC16IS7XX_THR_REG:
> +       case SC16IS7XX_IER_REG:
> +       case SC16IS7XX_FCR_REG:
> +       case SC16IS7XX_LCR_REG:
> +       case SC16IS7XX_MCR_REG:
> +       case SC16IS7XX_SPR_REG:
> +       case SC16IS7XX_IODIR_REG:
> +       case SC16IS7XX_IOSTATE_REG:
> +       case SC16IS7XX_IOINTENA_REG:
> +       case SC16IS7XX_IOCONTROL_REG:
> +       case SC16IS7XX_EFCR_REG:
> +               return true;
> +       default:
> +               break;
> +       }
> +
> +       return false;
> +}

Having the above regmap_writeable callback causes problem with the
bulk I2C write (via regmap_raw_write()) that is done in
sc16is7xx_handle_tx(). Removing this callback fixes the issue.


[snip]
> +static void sc16is7xx_handle_tx(struct uart_port *port)
> +{
> +       struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
> +       struct circ_buf *xmit = &port->state->xmit;
> +       unsigned int txlen, to_send, i;
> +       u8 buf[port->fifosize];
> +
> +       if (unlikely(port->x_char)) {
> +               sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
> +               port->icount.tx++;
> +               port->x_char = 0;
> +               return;
> +       }
> +
> +       if (uart_circ_empty(xmit) || uart_tx_stopped(port))
> +               return;
> +
> +       /* Get length of data pending in circular buffer */
> +       to_send = uart_circ_chars_pending(xmit);
> +       if (likely(to_send)) {
> +               /* Limit to size of TX FIFO */
> +               txlen = sc16is7xx_port_read(port, SC16IS7XX_TXLVL_REG);
> +               to_send = (to_send > txlen) ? txlen : to_send;
> +
> +               /* Add data to send */
> +               port->icount.tx += to_send;
> +
> +               /* Convert to linear buffer */
> +               for (i = 0; i < to_send; ++i) {
> +                       buf[i] = xmit->buf[xmit->tail];
> +                       xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
> +               }
> +               regcache_cache_bypass(s->regmap, true);
> +               regmap_raw_write(s->regmap, SC16IS7XX_THR_REG, buf, to_send);

This call fails with -EINVAL if to_send is > 20 because it assumes
that we are writing to consecutive registers rather than writing to a
single register over and over.

> +               regcache_cache_bypass(s->regmap, false);
> +       }
> +
> +       if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +               uart_write_wakeup(port);
> +}

[snip]

> +static struct regmap_config regcfg = {
> +       .reg_bits = 7,
> +       .pad_bits = 1,
> +       .val_bits = 8,
> +       .cache_type = REGCACHE_RBTREE,
> +       .writeable_reg = sc16is7xx_regmap_writeable,
Removing writeable_reg

New patch forthcoming that removes the regmap writeable_reg callback.
But, I also wonder if there is a way to keep it, but teach regcache
that regmap_raw_write/read() done necessariy increment the register
being written to or read from. Then I probably wouldn't have to do the
regcach_cache_bypass business I am doing either.

Jon
