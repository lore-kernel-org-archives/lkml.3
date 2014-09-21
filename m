Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaIUOhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 10:37:10 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:60997 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaIUOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 10:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <541D83AE.1050006@gmail.com>
References: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com> <541D83AE.1050006@gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Sun, 21 Sep 2014 20:06:26 +0530
Message-ID: <CAGOxZ52HY0eEukbWdt0OnUzcfrLi3Y726om+GQAQ_Q0vmwk-=Q@mail.gmail.com>
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
Thanks for your valuable feedback on this patch.
Please see my comments inline.

On Sat, Sep 20, 2014 at 7:09 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Alim,
>
> Please see my comments inline.
>
> On 16.09.2014 13:32, Alim Akhtar wrote:
>> Add earlycon support for the samsung serial port. This allows enabling
>> the samsung serial port for console when early_params are parse and processed.
>>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>  Documentation/kernel-parameters.txt |    6 ++++++
>>  drivers/tty/serial/Kconfig          |    1 +
>>  drivers/tty/serial/samsung.c        |   17 +++++++++++++++++
>>  3 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 5ae8608..e01c0e5 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -936,6 +936,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                       must already be setup and configured. Options are not
>>                       yet supported.
>>
>> +             samsung,<addr>
>> +                     Start an early, polled-mode console on a samsung serial
>> +                     port at the specified address. The samsung serial port
>> +                     must already be setup and configured. Options are not
>> +                     yet supported.
>> +
>
> Couldn't you simply parse this from DT? I believe there is already code
> parsing stdout property in chosen node for earlycon purposes present in
> the kernel.
>
> Anyway, we already had a patch for this in our internal tree, but it
> wasn't submitted because there was no support for early ioremap on ARM
> at that time. I haven't been following it since then (and I'm no longer
> at Samsung; Marek might be able to take this topic), is it already
> available?
I am not sure what you have internally, any further suggestions on
this is most welcome.
As you said there is no support for ioremap on ARM, so this is not
tested on ARM.
>
>>               smh     Use ARM semihosting calls for early console.
>>
>>       earlyprintk=    [X86,SH,BLACKFIN,ARM,M68k]
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index 249e340..9d42ac8 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -257,6 +257,7 @@ config SERIAL_SAMSUNG_CONSOLE
>>       bool "Support for console on Samsung SoC serial port"
>>       depends on SERIAL_SAMSUNG=y
>>       select SERIAL_CORE_CONSOLE
>> +     select SERIAL_EARLYCON
>>       help
>>         Allow selection of the S3C24XX on-board serial ports for use as
>>         an virtual console.
>> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
>> index c78f43a..f32e9c8 100644
>> --- a/drivers/tty/serial/samsung.c
>> +++ b/drivers/tty/serial/samsung.c
>> @@ -917,6 +917,7 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
>>  #ifdef CONFIG_SERIAL_SAMSUNG_CONSOLE
>>
>>  static struct console s3c24xx_serial_console;
>> +static void s3c24xx_serial_console_putchar(struct uart_port *port, int ch);
>>
>>  static int __init s3c24xx_serial_console_init(void)
>>  {
>> @@ -926,6 +927,22 @@ static int __init s3c24xx_serial_console_init(void)
>>  console_initcall(s3c24xx_serial_console_init);
>>
>>  #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
>> +static void samsung_early_write(struct console *con, const char *s, unsigned n)
>> +{
>> +     struct earlycon_device *dev = con->data;
>> +
>> +     uart_console_write(&dev->port, s, n, s3c24xx_serial_console_putchar);
>
> Hmm, I'm not sure how this is supposed to work before the driver is
> fully initialized.
>
> s3c24xx_serial_console_putchar() will call
> s3c24xx_serial_console_txrdy(), which in turn requires the port argument
> to be a pointer to the member of a s3c24xx_uart_port struct, with filled
> info pointer, which I believe is ready only after s3c24xx_serial_probe().
>
I see your point here, but I did not hit any error or any  runtime
crash with this patch when test on ARM64. In order to keep my changes
minimal I tried to reused the code already there in this file and that
worked for me. The reason why this is working is, if you see
s3c24xx_serial_console_txdy(), _info_ pointer is used in a conditional
operator and not really involved in any manipulation.
I am not sure if compiler should have give some warnings or error here.

But certainly this is not the way this is suppose to work probably.
Let me avoid a call to s3c24xx_serial_console_putchar() in my next respin.
As this is a very early call and earlycon expect that port are already
initialized (by bootloader), I will write a new function to be used
instead of s3c24xx_serial_console_putchar() that will directly write
to the serial port.

> Has this patch been tested with earlycon enabled and it was indeed
> verified that earlycon is actually used?
>
Yes, this is tested on ARM64 with earlycon enabled, the way I tested is:
"Disabled" serial dt node in the device tree file,
passed earlycon = samsung,<addr> in CMDLINE
put some debug prints in setup() method, and it is getting printed on
console very early.
Below is my partial bootlog:

-----
Initializing cgroup subsys cpu
Linux version 3.17.0-rc5+ (alim@alim) (gcc version 4.8.3 20140106 (prerelease)
CPU: AArch64 Processor
Detected VIPT I-cache on CPU0
Early serial console at I/O port 0x0 (options '')
samsung_early_console_setup:954
bootconsole [uart0] enabled
.
.
Kernel command line: earlycon=samsung,0x14c30000 console=ttySAC0,115200
.
.
io scheduler noop registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
.
.
TCP: cubic registered
NET: Registered protocol family 17
9pnet: Installing 9P2000 support
bootconsole [uart0] disabled
-------
As I disabled serial node from DT, it did not printed any further
bootlog after "bootconsole [uar0] disabled"
And removing "earlycon" from CMDLINE does not give any bootlog on console.
So I believe earlycon is working on this platform atleast.

Let me know if this test is convincing to you.

Thanks,

> Best regards,
> Tomasz
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Regards,
Alim
