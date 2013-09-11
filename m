Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3IKSsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:48:36 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45738 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3IKSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:48:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130911183825.GC10105@radagast>
References: <20130910190901.GA10105@radagast> <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Wed, 11 Sep 2013 21:48:13 +0300
Message-ID: <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
Subject: Re: commit 5fe212364 causes division by zero with large bauds
To: balbi@ti.com
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 9:38 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
>> Hi Felipe,
>>
>> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
>> rates. First patch is close to a complete fix, but still contains
>> div-by-zero issue. Here is my version:
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 816d1a2..808a880 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
>> unsigned int baud)
>>  {
>>         unsigned int n13 = port->uartclk / (13 * baud);
>>         unsigned int n16 = port->uartclk / (16 * baud);
>> -       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
>> -       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
>> +       int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
>> +       int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
>
> IOW:
>
> int baudAbsDiff13 = 0;
>
> if (n13)
>         baudAbsDiff13 = (baud - (port->uartclk / (13 * n13)));

Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
exception will still occur on 3686400.

>
> which is exactly what my patch did. I fail to see where division by zero
> would be coming from.
>
>>         if(baudAbsDiff13 < 0)
>>                 baudAbsDiff13 = -baudAbsDiff13;
>>         if(baudAbsDiff16 < 0)
>>
>>
>> With 48MHz UART clock, it will give
>> 300: divisor = 12307 (13), real rate 300 (0.000000%)
>> 600: divisor = 6153 (13), real rate 600 (0.000000%)
>> 1200: divisor = 3076 (13), real rate 1200 (0.000000%)
>> 2400: divisor = 1538 (13), real rate 2400 (0.000000%)
>
> TRM has these all set with oversampling of 16. In fact only 460800,
> 921600, 1843200 and 3686400 should be using oversampling of 13.
>

That's true, but TRM anyways does not contain all possible baud rates
(1M e.g.). IMO, as long as error rate is the same as in TRM,
it makes no difference what combination of (mode, divisor) to use.

> --
> balbi

A complex solution may be implemented: use LUT for baud rates that TRM
defines explicitly, and use calculation if lookup failed.

Thanks,
Alexey
