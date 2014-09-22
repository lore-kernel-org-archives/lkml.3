Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaIVNlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:41:49 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63584 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaIVNlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <541F5D12.6080605@gmail.com>
References: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com>
 <541D83AE.1050006@gmail.com> <CAGOxZ52HY0eEukbWdt0OnUzcfrLi3Y726om+GQAQ_Q0vmwk-=Q@mail.gmail.com>
 <541F09B4.6050907@gmail.com> <CAGOxZ504AXRJ4gYdD1NdvomLeBX4oeLT+XDeDxrS6swYCm4rog@mail.gmail.com>
 <541F5D12.6080605@gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Mon, 22 Sep 2014 19:11:06 +0530
Message-ID: <CAGOxZ52jDahcK9m05bMaid9Hh9vsO2cY8uKbdD7kPt_2KUekhw@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: samsung: Add earlycon support
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, gregkh@linuxfoundation.org,
        Rob Herring <robh@kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Mon, Sep 22, 2014 at 4:49 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 22.09.2014 01:10, Alim Akhtar wrote:
>
> [snip]
>
>>>> As you said there is no support for ioremap on ARM, so this is not
>>>> tested on ARM.
>>>
>>> Don't forget that this driver is primarily targeted for ARM platforms
>>> (versus just one ARM64-based Exynos7), so either this feature should be
>>> clearly added as ARM64-specific (and compiled in conditionally) or made
>>> work for all supported platforms.
>>>
>> Well, this will work on every platform which uses
>> "samsung,exynos4210-uart" as a UART controller.
>> Exynos7 also use same, there is nothing special about ARM64 bit here.
>> please see[1].
>> For "s3c24xx-uart", this has to be implemented separably as that is a
>> bit different.
>
> For this feature, they differ only in locations and lengths of
> FIFO-related bit fields. We had this already implemented for all
> hardware variants and so my recommendation to reuse that code.
>
>>>>>
>>>>>>               smh     Use ARM semihosting calls for early console.
>>>>>>
>>>>>>       earlyprintk=    [X86,SH,BLACKFIN,ARM,M68k]
>
> [snip]
>
>> Tomasz/Marek,
>> Do you think something like below make sense here?
>>
>> +static void exynos4210_serial_console_putc(struct uart_port *port, int ch)
>> +{
>> +       while (!(readl(port->membase + S3C2410_UFCON) & S3C2410_UFCON_FIFOMODE))
>> +               ;
>
> Waiting in a loop for a software-writable FIFO mode enable bit doesn't
> look reasonable to me. Probably a typo?
>
>> +
>> +       wr_regb(port, S3C2410_UTXH, ch);
>> +
>> +       while ((readl(port->membase + S3C2410_UFSTAT) & S5PV210_UFSTAT_TXFULL))
>> +               ;
>
> I wonder if you need to wait for the character to be sent. If you ensure
> before writing a character that there is no previous one in the buffer
> or there is space in FIFO then I believe you should be fine.
>
Well, below is what I was about to post:

 #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
+static void s3c24xx_serial_console_putc(struct uart_port *port, int ch)
+{
+ unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
+
+ if (ufcon & S3C2410_UFCON_FIFOMODE) {
+  while((readl(port->membase + S3C2410_UFSTAT) &
+      S5PV210_UFSTAT_TXFULL))
+   ;
+  wr_regb(port, S3C2410_UTXH, ch);
+ }
+}
+
+static void samsung_early_write(struct console *con, const char *s, unsigned n)
+{
+ struct earlycon_device *dev = con->data;
+
+ uart_console_write(&dev->port, s, n, s3c24xx_serial_console_putc);
+}
+
+static int __init samsung_early_console_setup(struct earlycon_device *device,
+           const char *opt)
+{
+ if (!device->port.membase)
+  return -ENODEV;
+ device->con->write = samsung_early_write;
+ return 0;
+}
+EARLYCON_DECLARE(samsung, samsung_early_console_setup);
+OF_EARLYCON_DECLARE(samsung, "samsung,exynos4210-uart",
samsung_early_console_setup);

but just saw patches from Marek few min back which is similar except
for the handle non-fifo mode, which is good anyway. :-)
So lets drops this patch and discussion here.

Thanks!!!

>> +}
>>
>> and call exynos4210_serial_console_putc() in samsung_early_write()?
>> Anyway functions names need to be changes accordingly.
>
> Yes, this is exactly what we had implemented in the patch I mentioned,
> except that the putc function was generic for all hardware variants.
>
> Best regards,
> Tomasz



-- 
Regards,
Alim
