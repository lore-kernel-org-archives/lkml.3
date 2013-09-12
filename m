Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3ILEha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:37:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36811 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3ILEh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
References: <20130910190901.GA10105@radagast> <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast> <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast> <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
 <20130911204714.GH10105@radagast> <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Thu, 12 Sep 2013 07:37:07 +0300
Message-ID: <CAOmKuSpRpb0mRnORvK-q1MMV3BHZaY8_yTyQV-iE+=gj1hqK7Q@mail.gmail.com>
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

Actually, here it is, but not formatted properly

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 816d1a2..146e712 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -240,14 +240,14 @@ serial_omap_baud_is_mode16(struct uart_port
*port, unsigned int baud)
 {
  unsigned int n13 = port->uartclk / (13 * baud);
  unsigned int n16 = port->uartclk / (16 * baud);
- int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
- int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
+ int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
+ int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
  if(baudAbsDiff13 < 0)
  baudAbsDiff13 = -baudAbsDiff13;
  if(baudAbsDiff16 < 0)
  baudAbsDiff16 = -baudAbsDiff16;

- return (baudAbsDiff13 > baudAbsDiff16);
+ return (baudAbsDiff13 >= baudAbsDiff16);
 }

 /*
@@ -258,13 +258,13 @@ serial_omap_baud_is_mode16(struct uart_port
*port, unsigned int baud)
 static unsigned int
 serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
 {
- unsigned int divisor;
+ unsigned int mode;

  if (!serial_omap_baud_is_mode16(port, baud))
- divisor = 13;
+ mode = 13;
  else
- divisor = 16;
- return port->uartclk/(baud * divisor);
+ mode = 16;
+ return port->uartclk/(mode * baud);
 }

 static void serial_omap_enable_ms(struct uart_port *port)

On Thu, Sep 12, 2013 at 7:32 AM, Alexey Pelykh <alexey.pelykh@gmail.com> wrote:
> On Wed, Sep 11, 2013 at 11:47 PM, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>>
>> On Wed, Sep 11, 2013 at 10:19:47PM +0300, Alexey Pelykh wrote:
>>> On Wed, Sep 11, 2013 at 10:00 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> > On Wed, Sep 11, 2013 at 09:48:13PM +0300, Alexey Pelykh wrote:
>>> >> On Wed, Sep 11, 2013 at 9:38 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> >> > Hi,
>>> >> >
>>> >> > On Wed, Sep 11, 2013 at 09:22:26AM +0300, Alexey Pelykh wrote:
>>> >> >> Hi Felipe,
>>> >> >>
>>> >> >> Thanks for finding this issue. Indeed, there is a bug on 3M+ baud
>>> >> >> rates. First patch is close to a complete fix, but still contains
>>> >> >> div-by-zero issue. Here is my version:
>>> >> >>
>>> >> >> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>>> >> >> index 816d1a2..808a880 100644
>>> >> >> --- a/drivers/tty/serial/omap-serial.c
>>> >> >> +++ b/drivers/tty/serial/omap-serial.c
>>> >> >> @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
>>> >> >> unsigned int baud)
>>> >> >>  {
>>> >> >>         unsigned int n13 = port->uartclk / (13 * baud);
>>> >> >>         unsigned int n16 = port->uartclk / (16 * baud);
>>> >> >> -       int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
>>> >> >> -       int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
>>> >> >> +       int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
>>> >> >> +       int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
>>> >> >
>>> >> > IOW:
>>> >> >
>>> >> > int baudAbsDiff13 = 0;
>>> >> >
>>> >> > if (n13)
>>> >> >         baudAbsDiff13 = (baud - (port->uartclk / (13 * n13)));
>>> >>
>>> >> Not quite same code, INT_MAX instead of 0. With 0 a div-by-zero
>>> >> exception will still occur on 3686400.
>>> >
>>> > why, there's no division after that point, right ? Besides,
>>> > serial_omap_baud_is_mode16() is supposed to return a boolean value.
>>> >
>>> > Setting baudAbsDiff1[36] to 0 will cause no problems, you're only using
>>> > that value with a boolean expression, no divisions whatsoever. Division
>>> > is done after using serial_omap_baud_is_mode16() to initialize divisor
>>> > to 13 or 16 (which is a misnamer, since that's the oversampling
>>> > parameter).
>>> >
>>>
>>> Yes, variables are a bit misnamed, that should be fixed someday.
>>> Regarding 0 vs INT_MAX, in case of 0 values will be
>>> 300: divisor = 12307 (13)
>>> 600: divisor = 6153 (13)
>>> 1200: divisor = 3076 (13)
>>> 2400: divisor = 1538 (13)
>>> 4800: divisor = 625 (16)
>>> 9600: divisor = 384 (13)
>>> 14400: divisor = 256 (13)
>>> 19200: divisor = 192 (13)
>>> 28800: divisor = 128 (13)
>>> 38400: divisor = 96 (13)
>>> 57600: divisor = 64 (13)
>>> 115200: divisor = 32 (13)
>>> 230400: divisor = 16 (13)
>>> 460800: divisor = 8 (13)
>>> 921600: divisor = 4 (13)
>>> 1000000: divisor = 3 (16)
>>> 1843200: divisor = 2 (13)
>>> 3000000: divisor = 1 (16)
>>> 3686400: divisor = 0 (16) << error here, should be 1 (13), as it is with INT_MAX
>>
>> I get it now... your boolean check wants to use the closer baud to
>> requested baud, so it's mode16 if the delta between baudAbsDiff16 and
>> requested rate is less than delta between baudAbsDiff13 and requested
>> baud.
>>
>>> >> > which is exactly what my patch did. I fail to see where division by zero
>>> >> > would be coming from.
>>> >> >
>>> >> >>         if(baudAbsDiff13 < 0)
>>> >> >>                 baudAbsDiff13 = -baudAbsDiff13;
>>> >> >>         if(baudAbsDiff16 < 0)
>>> >> >>
>>> >> >>
>>> >> >> With 48MHz UART clock, it will give
>>> >> >> 300: divisor = 12307 (13), real rate 300 (0.000000%)
>>> >> >> 600: divisor = 6153 (13), real rate 600 (0.000000%)
>>> >> >> 1200: divisor = 3076 (13), real rate 1200 (0.000000%)
>>> >> >> 2400: divisor = 1538 (13), real rate 2400 (0.000000%)
>>> >> >
>>> >> > TRM has these all set with oversampling of 16. In fact only 460800,
>>> >> > 921600, 1843200 and 3686400 should be using oversampling of 13.
>>> >> >
>>> >>
>>> >> That's true, but TRM anyways does not contain all possible baud rates
>>> >> (1M e.g.). IMO, as long as error rate is the same as in TRM,
>>> >> it makes no difference what combination of (mode, divisor) to use.
>>> >>
>>> >> > --
>>> >> > balbi
>>> >>
>>> >> A complex solution may be implemented: use LUT for baud rates that TRM
>>> >> defines explicitly, and use calculation if lookup failed.
>>> >
>>> > why would you try calculating anything if there is nothing in the table
>>> > which can support it ? Whatever is in the lookup table, are the only
>>> > baud rates the SoC supports, right ?
>>> >
>>>
>>> Actually, I haven't found any statement in TRM, which would mention
>>> that listed baudrates in referenced table are the only supported baud
>>> rates,
>>> and all others are illegal.
>>
>> "The UART clocks are connected to produce a baud rate of up to 3.6 Mbps.
>> Table 24-122 lists the *supported* baud rates, requested divisor, and
>> corresponding error versus the standard baud rate."
>>
>>> At least 1M which I use extensively works perfectly, and I can not
>>> figure out any idea why it would not do so.
>>
>> it might very well work, but it's not officially *supported* by the IP.
>
> That's true, but I don't see any reason why driver should disallow
> usage of baud rates that are not supported, but possible by hardware:
> "The UART clocks are connected to produce a baud rate of up to 3.6M bits/s."
>
>>
>> --
>> balbi
>
> I've changed calculation a bit to give priority to mode16, and now it
> gives TRM table as-is + extra baud rates
> 300: divisor = 10000 (16), real rate 300 (0.000000%)
> 600: divisor = 5000 (16), real rate 600 (0.000000%)
> 1200: divisor = 2500 (16), real rate 1200 (0.000000%)
> 2400: divisor = 1250 (16), real rate 2400 (0.000000%)
> 4800: divisor = 625 (16), real rate 4800 (0.000000%)
> 9600: divisor = 312 (16), real rate 9615 (0.156250%)
> 14400: divisor = 208 (16), real rate 14423 (0.159722%)
> 19200: divisor = 156 (16), real rate 19230 (0.156250%)
> 28800: divisor = 104 (16), real rate 28846 (0.159722%)
> 38400: divisor = 78 (16), real rate 38461 (0.158854%)
> 57600: divisor = 52 (16), real rate 57692 (0.159722%)
> 115200: divisor = 26 (16), real rate 115384 (0.159722%)
> 230400: divisor = 13 (16), real rate 230769 (0.160156%)
> 460800: divisor = 8 (13), real rate 461538 (0.160156%)
> 921600: divisor = 4 (13), real rate 923076 (0.160156%)
> 1000000: divisor = 3 (16), real rate 1000000 (0.000000%)
> 1843200: divisor = 2 (13), real rate 1846153 (0.160211%)
> 3000000: divisor = 1 (16), real rate 3000000 (0.000000%)
> 3686400: divisor = 1 (13), real rate 3692307 (0.160238%)
>
> If that's acceptable behavior, I'll prepare a patch.
>
> Thanks,
> Alexey
