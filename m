Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbaDCG3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:29:02 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:56024 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbaDCG26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:28:58 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: jon@ringle.org
Cc: =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCAxLzJdIHNlcmlhbDogc2MxNmlzN3h4?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Thu, 03 Apr 2014 10:28:37 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1396506517.887689599@f401.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1396500555-28873-1-git-send-email-jon@ringle.org>
References: <1396500555-28873-1-git-send-email-jon@ringle.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s336TAkL015765

Thu,  3 Apr 2014 00:49:14 -0400 Ğ¾Ñ‚ jon@ringle.org:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> high performance UART. The SC16IS7xxâ€™s internal register set is
> backward-compatible with the widely used and widely popular 16C450.
> 
> The SC16IS7xx also provides additional advanced features such as
> auto hardware and software flow control, automatic RS-485 support, and
> software reset.
> 
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
...
> +	tristate "SC16IS7xx serial support"
> +	select SERIAL_CORE
> +	select REGMAP_I2C if I2C
> +	default n

"n" is already default choice. There is no need to specify this.

...
> +#include <linux/serial.h>
> +#include <linux/spi/spi.h>

What a reason to include SPI header?

...
> + * The programmer must program the TCR such that TCR[3:0] > TCR[7:4]. There is
> + * no built-in hardware check to make sure this condition is met. Also, the TCR
> + * must be programmed with this condition before auto RTS or software flow
> + * control is enabled to avoid spurious operation of the device.
> + */
> +#define SC16IS7XX_TCR_RX_HALT(words)	(((words / 4) & 0x0f) << 0)
> +#define SC16IS7XX_TCR_RX_RESUME(words)	(((words / 4) & 0x0f) << 4)

"words" on the right side should be framed by brackets.

...
> + * When TLR is used for RX trigger level control, FCR[7:6] should be left at the
> + * default state, that is, â€˜00â€™.
> + */
> +#define SC16IS7XX_TLR_TX_TRIGGER(words)	(((words / 4) & 0x0f) << 0)
> +#define SC16IS7XX_TLR_RX_TRIGGER(words)	(((words / 4) & 0x0f) << 4)

Ditto.

...
> +static void sc16is7xx_config_rs485(struct uart_port *port,
> +				   struct serial_rs485 *rs485)
> +{
> +	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
> +
> +	one->rs485 = *rs485;
> +
> +	if (one->rs485.flags & SER_RS485_ENABLED) {
> +		sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
> +				      SC16IS7XX_EFCR_AUTO_RS485_BIT,
> +				      SC16IS7XX_EFCR_AUTO_RS485_BIT);
> +	} else {
> +		sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
> +				      SC16IS7XX_EFCR_AUTO_RS485_BIT,
> +				      0);
> +	}
> +}

This function will get "unused" warning if TIOCSRS485 and
TIOCGRS485 is not defined.

...
> +static int sc16is7xx_startup(struct uart_port *port)
> +{
...
> +	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
> +			      SC16IS7XX_EFCR_AUTO_RS485_BIT,
> +			      SC16IS7XX_EFCR_AUTO_RS485_BIT);

You should do not set optional RS485 mode unconditionally.
Since IOCTL for RS485 is used, this should be enough.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
