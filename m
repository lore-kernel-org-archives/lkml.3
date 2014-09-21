Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaIURYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:24:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49047 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIURYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:24:08 -0400
Message-ID: <541F09B4.6050907@gmail.com>
Date: Sun, 21 Sep 2014 19:24:04 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, gregkh@linuxfoundation.org,
        Rob Herring <robh@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] tty/serial: samsung: Add earlycon support
References: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com> <541D83AE.1050006@gmail.com> <CAGOxZ52HY0eEukbWdt0OnUzcfrLi3Y726om+GQAQ_Q0vmwk-=Q@mail.gmail.com>
In-Reply-To: <CAGOxZ52HY0eEukbWdt0OnUzcfrLi3Y726om+GQAQ_Q0vmwk-=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.2014 16:36, Alim Akhtar wrote:
> Hi Tomasz,
> Thanks for your valuable feedback on this patch.

You're welcome.

>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index 5ae8608..e01c0e5 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -936,6 +936,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>                       must already be setup and configured. Options are not
>>>                       yet supported.
>>>
>>> +             samsung,<addr>
>>> +                     Start an early, polled-mode console on a samsung serial
>>> +                     port at the specified address. The samsung serial port
>>> +                     must already be setup and configured. Options are not
>>> +                     yet supported.
>>> +
>>
>> Couldn't you simply parse this from DT? I believe there is already code
>> parsing stdout property in chosen node for earlycon purposes present in
>> the kernel.
>>
>> Anyway, we already had a patch for this in our internal tree, but it
>> wasn't submitted because there was no support for early ioremap on ARM
>> at that time. I haven't been following it since then (and I'm no longer
>> at Samsung; Marek might be able to take this topic), is it already
>> available?
> I am not sure what you have internally, any further suggestions on
> this is most welcome.

I believe Marek should be able to post our internal patch, so maybe you
could reuse it and adapt for your needs.

> As you said there is no support for ioremap on ARM, so this is not
> tested on ARM.

Don't forget that this driver is primarily targeted for ARM platforms
(versus just one ARM64-based Exynos7), so either this feature should be
clearly added as ARM64-specific (and compiled in conditionally) or made
work for all supported platforms.

>>
>>>               smh     Use ARM semihosting calls for early console.
>>>
>>>       earlyprintk=    [X86,SH,BLACKFIN,ARM,M68k]
>>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>>> index 249e340..9d42ac8 100644
>>> --- a/drivers/tty/serial/Kconfig
>>> +++ b/drivers/tty/serial/Kconfig
>>> @@ -257,6 +257,7 @@ config SERIAL_SAMSUNG_CONSOLE
>>>       bool "Support for console on Samsung SoC serial port"
>>>       depends on SERIAL_SAMSUNG=y
>>>       select SERIAL_CORE_CONSOLE
>>> +     select SERIAL_EARLYCON
>>>       help
>>>         Allow selection of the S3C24XX on-board serial ports for use as
>>>         an virtual console.
>>> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
>>> index c78f43a..f32e9c8 100644
>>> --- a/drivers/tty/serial/samsung.c
>>> +++ b/drivers/tty/serial/samsung.c
>>> @@ -917,6 +917,7 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
>>>  #ifdef CONFIG_SERIAL_SAMSUNG_CONSOLE
>>>
>>>  static struct console s3c24xx_serial_console;
>>> +static void s3c24xx_serial_console_putchar(struct uart_port *port, int ch);
>>>
>>>  static int __init s3c24xx_serial_console_init(void)
>>>  {
>>> @@ -926,6 +927,22 @@ static int __init s3c24xx_serial_console_init(void)
>>>  console_initcall(s3c24xx_serial_console_init);
>>>
>>>  #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
>>> +static void samsung_early_write(struct console *con, const char *s, unsigned n)
>>> +{
>>> +     struct earlycon_device *dev = con->data;
>>> +
>>> +     uart_console_write(&dev->port, s, n, s3c24xx_serial_console_putchar);
>>
>> Hmm, I'm not sure how this is supposed to work before the driver is
>> fully initialized.
>>
>> s3c24xx_serial_console_putchar() will call
>> s3c24xx_serial_console_txrdy(), which in turn requires the port argument
>> to be a pointer to the member of a s3c24xx_uart_port struct, with filled
>> info pointer, which I believe is ready only after s3c24xx_serial_probe().
>>
> I see your point here, but I did not hit any error or any  runtime
> crash with this patch when test on ARM64. In order to keep my changes
> minimal I tried to reused the code already there in this file and that
> worked for me. The reason why this is working is, if you see
> s3c24xx_serial_console_txdy(), _info_ pointer is used in a conditional
> operator and not really involved in any manipulation.
> I am not sure if compiler should have give some warnings or error here.
> 

The info pointer is always used whenever FIFO mode is enabled at
boot-up, which is often the case on many boards (and depends on
firmware). So the fact that it worked for you was purely a coincidence
due to your bootloader not using this mode. (Btw. it should be mentioned
in patch description on what hardware it was tested.)

> But certainly this is not the way this is suppose to work probably.
> Let me avoid a call to s3c24xx_serial_console_putchar() in my next respin.
> As this is a very early call and earlycon expect that port are already
> initialized (by bootloader), I will write a new function to be used
> instead of s3c24xx_serial_console_putchar() that will directly write
> to the serial port.
> 

The mentioned patch already has this implemented, including support for
all hardware variants. I'd strongly suggest basing your work on top of that.

Marek, could you post that patch as an RFC, so that Alim could continue
his work?

Best regards,
Tomasz
