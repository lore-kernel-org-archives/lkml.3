Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaD1XYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:24:10 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52185 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaD1XYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
Date: Mon, 28 Apr 2014 18:24:07 -0500
Message-ID: <CAL_JsqKiYmCNGrkiwS7m-OAt3rHZBq_yNGycen-AojbV-7famg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Rob Herring <robherring2@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 1:29 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Apr 18, 2014 at 3:19 PM, Rob Herring <robherring2@gmail.com> wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> With the generic earlycon infrastructure in place, convert the 8250
>> early console to use it.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> ---
>>  drivers/tty/serial/8250/8250_early.c | 138 ++++-------------------------------
>>  drivers/tty/serial/8250/Kconfig      |   1 +
>>  2 files changed, 16 insertions(+), 123 deletions(-)
>>
>> diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
>> index c100d63..e83c9db 100644
>> --- a/drivers/tty/serial/8250/8250_early.c
>> +++ b/drivers/tty/serial/8250/8250_early.c
>> @@ -35,18 +35,8 @@
> ...
>> -
>> -int __init setup_early_serial8250_console(char *cmdline)
>
> You removed global function, but still left declaration and calling...
>
> arch/mips/mti-malta/malta-init.c:
> setup_early_serial8250_console(console_string);
> drivers/firmware/pcdp.c:        return setup_early_serial8250_console(options);
> include/linux/serial_8250.h:extern int
> setup_early_serial8250_console(char *cmdline);

Thanks for finding these. I missed them in my build tests. This should fix them:

diff --git a/drivers/tty/serial/8250/8250_early.c
b/drivers/tty/serial/8250/8250_early.c
index e83c9db..2094c3b 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -156,6 +156,11 @@ static int __init early_serial8250_setup(struct
earlycon_device *device,
 EARLYCON_DECLARE(uart8250, early_serial8250_setup);
 EARLYCON_DECLARE(uart, early_serial8250_setup);

+int __init setup_early_serial8250_console(char *cmdline)
+{
+       return setup_earlycon(cmdline, "uart8250", early_serial8250_setup);
+}
+
 int serial8250_find_port_for_earlycon(void)
 {
        struct earlycon_device *device = early_device;
