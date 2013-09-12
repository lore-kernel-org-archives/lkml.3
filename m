Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3ILOiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:38:55 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:47028 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3ILOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130912122135.GP10105@radagast>
References: <20130910190901.GA10105@radagast> <CAOmKuSrbaLqaYiJFwonHzC-S003vgg2x0xUG4TGKDpMgvCCGHQ@mail.gmail.com>
 <20130911183825.GC10105@radagast> <CAOmKuSpJ4rX0p0a1gGvc3fVazTg=+43tDfTFiJSrxmAxXihf-A@mail.gmail.com>
 <20130911190033.GD10105@radagast> <CAOmKuSoZQ=uDAD7P94EPfKEp97to3DqwWk=GW7OZ-98+S6nTBA@mail.gmail.com>
 <20130911204714.GH10105@radagast> <CAOmKuSpgwGcTaQTEdtH+9g-6WwNwseVU6X+hhntK31EOTM=WRA@mail.gmail.com>
 <CAOmKuSpRpb0mRnORvK-q1MMV3BHZaY8_yTyQV-iE+=gj1hqK7Q@mail.gmail.com> <20130912122135.GP10105@radagast>
From: Alexey Pelykh <alexey.pelykh@gmail.com>
Date: Thu, 12 Sep 2013 17:38:32 +0300
Message-ID: <CAOmKuSqh0w8GS-rokCsyF5gBHKWuiy+GvV7P5R8YK264UEG7EA@mail.gmail.com>
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

On Thu, Sep 12, 2013 at 3:21 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Sep 12, 2013 at 07:37:07AM +0300, Alexey Pelykh wrote:
>> Actually, here it is, but not formatted properly
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 816d1a2..146e712 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -240,14 +240,14 @@ serial_omap_baud_is_mode16(struct uart_port
>> *port, unsigned int baud)
>>  {
>>   unsigned int n13 = port->uartclk / (13 * baud);
>>   unsigned int n16 = port->uartclk / (16 * baud);
>> - int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
>> - int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
>> + int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
>> + int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
>>   if(baudAbsDiff13 < 0)
>>   baudAbsDiff13 = -baudAbsDiff13;
>>   if(baudAbsDiff16 < 0)
>>   baudAbsDiff16 = -baudAbsDiff16;
>>
>> - return (baudAbsDiff13 > baudAbsDiff16);
>> + return (baudAbsDiff13 >= baudAbsDiff16);
>>  }
>>
>>  /*
>> @@ -258,13 +258,13 @@ serial_omap_baud_is_mode16(struct uart_port
>> *port, unsigned int baud)
>>  static unsigned int
>>  serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
>>  {
>> - unsigned int divisor;
>> + unsigned int mode;
>>
>>   if (!serial_omap_baud_is_mode16(port, baud))
>> - divisor = 13;
>> + mode = 13;
>>   else
>> - divisor = 16;
>> - return port->uartclk/(baud * divisor);
>> + mode = 16;
>> + return port->uartclk/(mode * baud);
>>  }
>>
>>  static void serial_omap_enable_ms(struct uart_port *port)
>
> looks good to me, but I'd split it as suggested as a reply to previous
> email.

Well, the fix of baud rate calculation (giving mode-16 priority) is a
simple >= instead of >.
But indeed, probably commits should be different in terms of their subject.

>
> --
> balbi
