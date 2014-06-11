Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaFKR6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:58:33 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34880 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaFKR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:58:31 -0400
Message-ID: <539898C3.8090903@gmail.com>
Date: Wed, 11 Jun 2014 12:58:27 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>	<1397859600-11507-4-git-send-email-robherring2@gmail.com>	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>	<CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>	<20140503220731.GA10927@kroah.com>	<20140503221658.GA13403@kroah.com>	<CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>	<CA+8MBbKE1E2uq9LefiDAV9hv2Z8OTkjx9mkXjE6_--F_emRC8A@mail.gmail.com>	<CAL_JsqKvoO9acX==-LdD6boO=B3xr=ijra_G0uqRZGzACZZUJg@mail.gmail.com> <CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
In-Reply-To: <CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 03:52 PM, Tony Luck wrote:
> On Mon, Jun 9, 2014 at 4:18 PM, Rob Herring <robherring2@gmail.com> wrote:
>> It should do auto detect of the baud-rate if it is not specified which
>> for 8250 is just reading the baud-rate divider and calculating the
>> baud-rate using the uart clock. It should just reprogram the divider
>> with the same divider value. I don't see anything obvious why this
>> would have broken.
> 
> Something very weird is happening.  Output is good so long as I put the
> trailing ",115200" on the command line.
> 
> But I made early_serial8250_setup() printk() the return value it got
> from probe_baud() - in case is was somehow getting 115201 or some
> other silly value ... nope. Exactly 115200.
> 
> I also can't explain why the "noise" comes and goes a dozen
> times during boot,
> 
> Does some other place in the kernel look at the "uart..." command
> line argument?

I think I figured it out. The function 
serial8250_find_port_for_earlycon is failing to match 'uart' console to 
'ttyS' console and transfer the options. It was also failing to create 
an option string when the baud rate is probed. Can you try out the 
below patch?

Rob

8<-------------------------------------------------------------------
diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index cfef801..4858b8a 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -144,8 +144,11 @@ static int __init early_serial8250_setup(struct earlycon_device *device,
 	if (!(device->port.membase || device->port.iobase))
 		return 0;
 
-	if (!device->baud)
+	if (!device->baud) {
 		device->baud = probe_baud(&device->port);
+		snprintf(device->options, sizeof(device->options), "%u",
+			 device->baud);
+	}
 
 	init_port(device);
 
diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index 5131b5e..d20e6d8 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -25,7 +25,7 @@
 #include <asm/serial.h>
 
 static struct console early_con = {
-	.name =		"earlycon",
+	.name =		"uart",
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };

