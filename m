Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaD1XU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:20:57 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39940 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaD1XUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
Date: Mon, 28 Apr 2014 18:20:53 -0500
Message-ID: <CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>
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
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 1:19 AM, Yinghai Lu <yinghai@kernel.org> wrote:
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
>
> Hi Greg, Rob
>
> This one in tty-next breaks booting: "console=uart8250,io,0x3f8,115200".
> No early console and regular console anymore.
>
> It should produce "early con and regular con".

This is what I get for running checkpatch and converting
simple_strtoul to kstrto* which are not so equivalent. kstrto* will
not convert things such as 115200n8 to a number.

Greg, Do you want a fix or for me to respin the series? The fix looks like this:

diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index 73bf1e2..c92e830 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -53,7 +53,7 @@ static int __init parse_options(struct
earlycon_device *device,
                                char *options)
 {
        struct uart_port *port = &device->port;
-       int mmio, mmio32, length, ret;
+       int mmio, mmio32, length;
        unsigned long addr;

        if (!options)
@@ -64,25 +64,19 @@ static int __init parse_options(struct
earlycon_device *device,
        if (mmio || mmio32) {
                port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
                options += mmio ? 5 : 7;
-               ret = kstrtoul(options, 0, &addr);
-               if (ret)
-                       return ret;
+               addr = simple_strtoul(options, NULL, 0);
                port->mapbase = addr;
                if (mmio32)
                        port->regshift = 2;
        } else if (!strncmp(options, "io,", 3)) {
                port->iotype = UPIO_PORT;
                options += 3;
-               ret = kstrtoul(options, 0, &addr);
-               if (ret)
-                       return ret;
+               addr = simple_strtoul(options, NULL, 0);
                port->iobase = addr;
                mmio = 0;
        } else if (!strncmp(options, "0x", 2)) {
                port->iotype = UPIO_MEM;
-               ret = kstrtoul(options, 0, &addr);
-               if (ret)
-                       return ret;
+               addr = simple_strtoul(options, NULL, 0);
                port->mapbase = addr;
        } else {
                return -EINVAL;
@@ -93,9 +87,7 @@ static int __init parse_options(struct
earlycon_device *device,
        options = strchr(options, ',');
        if (options) {
                options++;
-               ret = kstrtouint(options, 0, &device->baud);
-               if (ret)
-                       return ret;
+               device->baud = simple_strtoul(options, NULL, 0);
                length = min(strcspn(options, " ") + 1,
                             (size_t)(sizeof(device->options)));
                strlcpy(device->options, options, length);
