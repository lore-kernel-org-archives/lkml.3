Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaDYOId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:08:33 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39802 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaDYOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.03.1404250941590.2625@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
	<alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
	<alpine.LRH.2.03.1404250941590.2625@frank.harvard.edu>
Date: Fri, 25 Apr 2014 10:08:26 -0400
X-Google-Sender-Auth: Ki7DnJHhxynb-TYSjjOBi_fhWVY
Message-ID: <CAMwGMjyqiC1DLKfz0LUFg-iN8mDKc54w+8AYKFHOydiwtXHrFQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
From: Jon Ringle <jon@ringle.org>
To: Charles Coldwell <coldwell@gmail.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 9:44 AM, Charles Coldwell <coldwell@gmail.com> wrote:
> On Fri, 25 Apr 2014, Charles Coldwell wrote:
>
>> On Thu, 24 Apr 2014, jon@ringle.org wrote:
>>
>> > diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
>> > new file mode 100644
>> > index 0000000..ed139f5
>> > --- /dev/null
>> > +++ b/drivers/tty/serial/sc16is7xx.c
>>
>> > +
>> > +/* SC16IS7XX register definitions */
>> > +#define SC16IS7XX_RHR_REG          (0x00) /* RX FIFO */
>> > +#define SC16IS7XX_THR_REG          (0x00) /* TX FIFO */
>> > +#define SC16IS7XX_IER_REG          (0x01) /* Interrupt enable */
>> > +#define SC16IS7XX_IIR_REG          (0x02) /* Interrupt Identification */
>> > +#define SC16IS7XX_FCR_REG          (0x02) /* FIFO control */
>> > +#define SC16IS7XX_LCR_REG          (0x03) /* Line Control */
>> > +#define SC16IS7XX_MCR_REG          (0x04) /* Modem Control */
>> > +#define SC16IS7XX_LSR_REG          (0x05) /* Line Status */
>> > +#define SC16IS7XX_MSR_REG          (0x06) /* Modem Status */
>> > +#define SC16IS7XX_SPR_REG          (0x07) /* Scratch Pad */
>>
>> Isn't this a lot of duplication?

I started off doing that, but got frustrated enough by
incompatibilities between the register bit definitions that I
abandoned that and decided to make the driver self contained regarding
the register and bit definitions. For example:

serial_reg.h defines:
#define UART_MCR_TCRTLR        0x40 /* Access TCR/TLR (TI16C752, EFR[4]=1) */

but this is wrong for sc16is7xx. I need:

#define SC16IS7XX_MCR_TCRTLR_BIT    (1 << 2) /* TCR/TLR register enable */

>
> Actually, the whole thing seems like duplication to me.  The SC16IS7X0
> parts are designed to be 16550-compatible (hence the duplication in the
> register map), and so I would vote for putting the driver into the
> drivers/tty/serial/8250 framework.  There's really not much difference
> between these parts and other 16550 parts except that they are reached
> over the SPI/I2C bus.

The fact that we need to reach over the SPI/I2C bus makes a big
difference in the way access is handled.

To achieve acceptable throughput, it is necessary to use threaded irq
and also bulk i2c transfers for RX and TX using
regmap_raw_{read,write}() to optimize the use of the i2c bus.

This is not a good fit for 8250.

Jon
