Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3IKTUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:20:12 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:64452 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IKTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130911190033.GD10105@radagast>
References: <20130910190901.GA10105@radagast> <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast> <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Wed, 11 Sep 2013 22:19:47 +0300
Message-ID: <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
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

On Wed, Sep 11, 2013 at 10:00 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Sep 11, 2013 at 09:48:13PM +0300, Alexey Pelykh wrote:
>> On Wed, Sep 11, 2013 at 9:38 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
>> >> Hi Felipe,
>> >>
>> >> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
>> >> rates. First patch is close to a complete fix, but still contains
>> >> div-by-zero issue. Here is my version:
>> >>
>> >> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> >> index 816d1a2..808a880 100644
>> >> --- a/drivers/tty/serial/omap-serial.c
>> >> +++ b/drivers/tty/serial/omap-serial.c
>> >> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
>> >> unsigned int baud)
>> >>  {
>> >>         unsigned int n13 = port->uartclk / (13 * baud);
>> >>         unsigned int n16 = port->uartclk / (16 * baud);
>> >> -       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
>> >> -       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
>> >> +       int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
>> >> +       int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
>> >
>> > IOW:
>> >
>> > int baudAbsDiff13 = 0;
>> >
>> > if (n13)
>> >         baudAbsDiff13 = (baud - (port->uartclk / (13 * n13)));
>>
>> Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
>> exception will still occur on 3686400.
>
> why, there's no division after that point, right ? Besides,
> serial_omap_baud_is_mode16() is supposed to return a boolean value.
>
> Setting baudAbsDiff1[36] to 0 will cause no problems, you're only using
> that value with a boolean expression, no divisions whatsoever. Division
> is done after using serial_omap_baud_is_mode16() to initialize divisor
> to 13 or 16 (which is a misnamer, since that's the oversampling
> parameter).
>

Yes, variables are a bit misnamed, that should be fixed someday.
Regarding 0 vs INT_MAX, in case of 0 values will be
300: divisor = 12307 (13)
600: divisor = 6153 (13)
1200: divisor = 3076 (13)
2400: divisor = 1538 (13)
4800: divisor = 625 (16)
9600: divisor = 384 (13)
14400: divisor = 256 (13)
19200: divisor = 192 (13)
28800: divisor = 128 (13)
38400: divisor = 96 (13)
57600: divisor = 64 (13)
115200: divisor = 32 (13)
230400: divisor = 16 (13)
460800: divisor = 8 (13)
921600: divisor = 4 (13)
1000000: divisor = 3 (16)
1843200: divisor = 2 (13)
3000000: divisor = 1 (16)
3686400: divisor = 0 (16) << error here, should be 1 (13), as it is with INT_MAX

>> > which is exactly what my patch did. I fail to see where division by zero
>> > would be coming from.
>> >
>> >>         if(baudAbsDiff13 < 0)
>> >>                 baudAbsDiff13 = -baudAbsDiff13;
>> >>         if(baudAbsDiff16 < 0)
>> >>
>> >>
>> >> With 48MHz UART clock, it will give
>> >> 300: divisor = 12307 (13), real rate 300 (0.000000%)
>> >> 600: divisor = 6153 (13), real rate 600 (0.000000%)
>> >> 1200: divisor = 3076 (13), real rate 1200 (0.000000%)
>> >> 2400: divisor = 1538 (13), real rate 2400 (0.000000%)
>> >
>> > TRM has these all set with oversampling of 16. In fact only 460800,
>> > 921600, 1843200 and 3686400 should be using oversampling of 13.
>> >
>>
>> That's true, but TRM anyways does not contain all possible baud rates
>> (1M e.g.). IMO, as long as error rate is the same as in TRM,
>> it makes no difference what combination of (mode, divisor) to use.
>>
>> > --
>> > balbi
>>
>> A complex solution may be implemented: use LUT for baud rates that TRM
>> defines explicitly, and use calculation if lookup failed.
>
> why would you try calculating anything if there is nothing in the table
> which can support it ? Whatever is in the lookup table, are the only
> baud rates the SoC supports, right ?
>

Actually, I haven't found any statement in TRM, which would mention
that listed baudrates in referenced table are the only supported baud
rates,
and all others are illegal.
At least 1M which I use extensively works perfectly, and I can not
figure out any idea why it would not do so.
General idea behind original commit is "to provide actual baudrate
that is as close as possible to requested one",
while keeping values in allowed range of divisor and mode.

> cheers
>
> --
> balbi

Best regards,
Alexey
