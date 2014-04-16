Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161249AbaDPWOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:14:31 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46645 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140324112821.GE3850@arm.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
	<1395436128-11244-7-git-send-email-robherring2@gmail.com>
	<20140324112821.GE3850@arm.com>
Date: Wed, 16 Apr 2014 17:14:28 -0500
Message-ID: <CAL_Jsq+rQA8p9oYk-Urh_z6MTqCy0RNr=k0nz7r0OTuMCPUNWA@mail.gmail.com>
Subject: Re: [PATCH 6/8] tty/serial: pl011: add generic earlycon support
From: Rob Herring <robherring2@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 6:28 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Mar 21, 2014 at 09:08:46PM +0000, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Add earlycon support for the pl011 serial port. This allows enabling
>> the pl011 for console when early_params are processed. This is based
>> on the arm64 earlyprintk support and is intended to replace it.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> ---
>>  Documentation/kernel-parameters.txt |  5 +++--
>>  drivers/tty/serial/amba-pl011.c     | 30 +++++++++++++++++++++++++++++-
>>  2 files changed, 32 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 5ce8b7a..81bdd52 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -887,8 +887,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>               uart[8250],io,<addr>[,options]
>>               uart[8250],mmio,<addr>[,options]
>>               uart[8250],mmio32,<addr>[,options]
>> -                     Start an early, polled-mode console on the 8250/16550
>> -                     UART at the specified I/O port or MMIO address.
>> +             pl011,<addr>
>> +                     Start an early, polled-mode console on a serial port
>> +                     at the specified I/O port or MMIO address. 8250
>>                       MMIO inter-register address stride is either 8-bit
>>                       (mmio) or 32-bit (mmio32).
>>                       The options are the same as for ttyS, above.
>
> I think the last line is a bit misleading. Or did you intend to leave it
> with the uart[8250] parameter? See below:

How about this (excuse the gmail lack of tabs):

earlycon= [KNL] Output early console device and options.

 uart[8250],io,<addr>[,options]
 uart[8250],mmio,<addr>[,options]
 uart[8250],mmio32,<addr>[,options]
  Start an early, polled-mode console on an 8250 serial
  port at the specified I/O port or MMIO address. 8250
  MMIO inter-register address stride is either 8-bit
  (mmio) or 32-bit (mmio32).

  The options are the same as for ttyS, above.

 pl011,<addr>
  Start an early, polled-mode console on a pl011 serial
  port at the specified address. The pl011 serial port
  must already be setup and configured. Options are not
  yet supported.

 smh Use ARM semihosting calls for early console.


>
>> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
>> index d4eda24..4227c0a 100644
>> --- a/drivers/tty/serial/amba-pl011.c
>> +++ b/drivers/tty/serial/amba-pl011.c
> [...]
>> +static int __init pl011_early_console_setup(struct earlycon_device *device,
>> +                                         const char *opt)
>> +{
>> +     if (!device->port.membase)
>> +             return -ENODEV;
>> +
>> +     device->con->write = pl011_early_write;
>> +     return 0;
>> +}
>> +EARLYCON_DECLARE(pl011, pl011_early_console_setup);
>
> Here we expect the PL011 to be already initialised by the boot loader
> and the kernel continues using the same settings. So maybe clarify this
> in the pl011 kernel parameter doc and we can add proper configuration
> using a separate patch.

Enabling and setup would not be too hard, but either baud rate will
always have to be configured or we'll have to specify the input clock
rate too. The 8250 driver basically does the former or assumes a fixed
clock.

Adding any setup will also break any non-pl011 based SBSA compliant
uart since the configuration registers are not standardized. I guess
we can add "sbsauart" when/if that happens.

Rob
