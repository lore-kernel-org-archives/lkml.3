Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbaCUMnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:43:04 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:58636 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760681AbaCUMm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140321082609.GA3801@xps8300>
References: <1395324333-21221-1-git-send-email-jon@ringle.org>
	<20140321082609.GA3801@xps8300>
Date: Fri, 21 Mar 2014 08:42:56 -0400
X-Google-Sender-Auth: GpXUBntEMBcC-RxUJAfbOlvaTG8
Message-ID: <CAMwGMjxeiCNxFbz4v3eQzKL5-pcMHAjX2WiHoX8-uArz-q_tNA@mail.gmail.com>
Subject: Re: [PATCH v2] tty: serial: sc16is7xx
From: Jon Ringle <jon@ringle.org>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        Alexander Shiyan <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 4:26 AM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi,
>
> On Thu, Mar 20, 2014 at 10:05:33AM -0400, jon@ringle.org wrote:
>> From: Jon Ringle <jringle@gridpoint.com>
>>
>> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
>> high performance UART. The SC16IS7xx's internal register set is
>> backward-compatible with the widely used and widely popular 16C450.
>
> So couldn't this be just a probe driver for 8250?

8250 UART has a MMIO-access, but this driver communicate through I2C
bus (and potentially SPI bus, if anyone cares to add that support,
which should be fairly easy to do). This is completely different
handling.

To achieve acceptable throughput, it is necessary to use threaded irq
and also bulk i2c transfers for RX and TX using
regmap_raw_{read,write}() to optimize the use of the i2c bus.

This is not a good fit for 8250.

>
>> +/* SC16IS7XX register definitions */
>> +#define SC16IS7XX_RHR_REG            (0x00) /* RX FIFO */
>> +#define SC16IS7XX_THR_REG            (0x00) /* TX FIFO */
>> +#define SC16IS7XX_IER_REG            (0x01) /* Interrupt enable */
>> +#define SC16IS7XX_IIR_REG            (0x02) /* Interrupt Identification */
>> +#define SC16IS7XX_FCR_REG            (0x02) /* FIFO control */
>> +#define SC16IS7XX_LCR_REG            (0x03) /* Line Control */
>> +#define SC16IS7XX_MCR_REG            (0x04) /* Modem Control */
>> +#define SC16IS7XX_LSR_REG            (0x05) /* Line Status */
>> +#define SC16IS7XX_MSR_REG            (0x06) /* Modem Status */
>> +#define SC16IS7XX_SPR_REG            (0x07) /* Scratch Pad */
>
> At least there should not be any need to redefine those register or
> their bits. Just include serial_reg.h.

I started off doing that, but got frustrated enough by
incompatibilities between the register bit definitions that I
abandoned that and decided to make the driver self contained regarding
the register and bit definitions. For example:

serial_reg.h defines:
#define UART_MCR_TCRTLR        0x40 /* Access TCR/TLR (TI16C752, EFR[4]=1) */

but this is wrong for sc16is7xx. I need:
#define SC16IS7XX_MCR_TCRTLR_BIT    (1 << 2) /* TCR/TLR register enable */

Jon
