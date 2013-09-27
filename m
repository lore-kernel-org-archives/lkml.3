Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3I0MmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:42:22 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:47810 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3I0MmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAOmKuSo6tNoMKB_-H9Z-PEBGpZCmOZ9EdfSbyy2ymP+Wvhy_3Q@mail.gmail.com>
References: <20130921074344.GA15524@inertiallabs-linux64> <20130921104202.GR25647@n2100.arm.linux.org.uk>
 <CAOmKuSo6tNoMKB_-H9Z-PEBGpZCmOZ9EdfSbyy2ymP+Wvhy_3Q@mail.gmail.com>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Fri, 27 Sep 2013 15:41:58 +0300
Message-ID: <CAOmKuSpFcy8g9yPasWngtHqpurJrqLeyB5ppt33TodpsU_DzqQ@mail.gmail.com>
Subject: Re: [PATCH] OMAP/serial: Fix division by zero exception on 3M+ baud rates
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for HTML mail, resend

On Fri, Sep 27, 2013 at 3:37 PM, Alexey Pelykh <alexey.pelykh@gmail.com> wrote:
> Hi Russel,
>
> Probably then it would be great if you could summarize that in a patch to
> replace mine, since basically mine is totally improper.
>
> Thanks,
> Alexey
>
>
>
> On Sat, Sep 21, 2013 at 1:42 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>>
>> On Sat, Sep 21, 2013 at 03:43:44AM -0400, Alexey Pelykh wrote:
>> > diff --git a/drivers/tty/serial/omap-serial.c
>> > b/drivers/tty/serial/omap-serial.c
>> > index 816d1a2..808a880 100644
>> > --- a/drivers/tty/serial/omap-serial.c
>> > +++ b/drivers/tty/serial/omap-serial.c
>> > @@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port,
>> > unsigned int baud)
>> >  {
>> >       unsigned int n13 = port->uartclk / (13 * baud);
>> >       unsigned int n16 = port->uartclk / (16 * baud);
>> > -     int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
>> > -     int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
>> > +     int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) :
>> > INT_MAX;
>> > +     int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) :
>> > INT_MAX;
>> >       if(baudAbsDiff13 < 0)
>> >               baudAbsDiff13 = -baudAbsDiff13;
>> >       if(baudAbsDiff16 < 0)
>>
>> So, this code is trying to work out whether it's better to use a prescaler
>> of 13 or 16?  In which case, the above code is rather buggy in many ways.
>> Let's take an example - what if port->uartclk is 19MHz?
>>
>> n13 = 19M / 13 * 115200 = 1
>> n16 = 19M / 16 * 115200 = 1
>> baudAbsDiff13 = 115200 - (19M / 13 * 1) = 115200 - 146153 = -30953 ->
>> 30953
>> baudAbsDiff16 = 115200 - (19M / 16 * 1) = 115200 - 118750 = -3550 -> 3350
>>
>> return (baudAbsDiff13 > baudAbsDiff16); -> 1
>>
>> That seems like it's right.
>>
>> Now, what if it's 18MHz?
>>
>> n13 = 18M / 13 * 115200 = 1
>> n16 = 18M / 16 * 115200 = 0
>> baudAbsDiff13 = 115200 - (18M / 13 * 1) = 115200 - 146153 = -23261 ->
>> 23261
>> baudAbsDiff16 = 115200 - (18M / 16 * 0) = 115200 - 118750 = INT_MAX
>>
>> return (baudAbsDiff13 > baudAbsDiff16); -> 0
>>
>> Now, consider the question: with a 18MHz clock, which produces a more
>> accurate 115200 baud rate - a prescaler of 16 or 13?  Let's go back to
>> the math.
>>
>>         115200 * 13 => 1497600
>>         115200 * 16 => 1843200
>>
>> So, choosing a prescaler of 16 will give a slower baud rate, but it's
>> a lot closer to 115200 than using the prescaler of 13.  Yet, the code
>> will select the latter.
>>
>> I'd suggest that this code gets rewritten to do "what it says on the tin"
>> a bit better:
>>
>>         unsigned n13 = DIV_ROUND_CLOSEST(port->uartclk, 13 * baud);
>>         unsigned n16 = DIV_ROUND_CLOSEST(port->uartclk, 16 * baud);
>>         int delta_clk_13 = 13 * baud * n13 - port->uartclk;
>>         int delta_clk_16 = 16 * baud * n16 - port->uartclk;
>>
>>         if (delta_clk_13 < 0)
>>                 delta_clk_13 = -delta_clk_13;
>>         if (delta_clk_16 < 0)
>>                 delta_clk_16 = -delta_clk_16;
>>
>>         return delta_clk_13 > delta_clk_16;
>>
>> Note that baud will never be larger than port->uartclk / 13, so n13
>> will always be greater than 1.  n16 may be zero though, and in this
>> case, at the point of the test, delta_clk_16 becomes much larger than
>> delta_clk_13, so the above calculation returns false, meaning we
>> correctly use a prescaler of 13.
>>
>> Not only does this avoid the problem with the divider being zero, but
>> it also selects the prescaler which gives us the closest baud rate to
>> the one which is being requested.
>>
>> Finally, serial_omap_get_divisor should also use DIV_ROUND_CLOSEST() -
>> or for extra points, integrate this into serial_omap_get_divisor(),
>> and have it also return the prescaler too.
>>
>
