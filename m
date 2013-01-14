Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3ANHgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:36:00 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:53870 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3ANHf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:35:58 -0500
Message-ID: <50F3B54D.7010801@synopsys.com>
Date: Mon, 14 Jan 2013 13:05:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: early init dt for earlyprintk (was Re: [RFC PATCH v1 25/31] ARC:
 [plat-arcfpga] Hooking up platform to ARC UART)
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-26-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de>
In-Reply-To: <201211071416.08012.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wednesday 07 November 2012 07:46 PM, Arnd Bergmann wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> +static struct platform_device arc_uart##n##_dev = {    \
>> +       .name = "arc-uart",                             \
>> +       .id = n,                                        \
>> +       .num_resources = ARRAY_SIZE(arc_uart##n##_res), \
>> +       .resource = arc_uart##n##_res,                  \
>> +       .dev = {                                        \
>> +               .platform_data = &arc_uart_info,        \
>> +       },                                              \
>> +}
>> +
>> +ARC_UART_DEV(0);
>> +#if CONFIG_SERIAL_ARC_NR_PORTS > 1
>> +ARC_UART_DEV(1);
>> +#endif
>> +
>> +static struct platform_device *fpga_early_devs[] __initdata = {
>> +#if defined(CONFIG_SERIAL_ARC_CONSOLE)
>> +       &arc_uart0_dev,
>> +#endif
>> +};
> 
> statically defining platform devices like this is considered very
> bad style, especially since it prevents you from doing proper
> boot-time configuration. Please get the available devices from
> the boot loader. Normally this is done using a flattened device
> tree blob that gets passed, unless you can probe the hardware
> directly.
> 
> 	Arnd
> 

OK, I have DeviceTree infrastructure in place. After wrapping my head around
irq-domains, the whole thing indeed seems like a nice abstraction. ARC Port
converted to it and patches to arc-uart driver to that effect posted to serial
lists. Thanks for your ACK to the arc-uart DT binding patch for same.

Couple of things though:

1. While I've eliminated the platform_device population for SERIAL_ARC, we still
need the static resource definitions and aux platform data for
early_platform_add_devices() for SERIAL_ARC_CONSOLE since it uses the early param
based driver registration and device probe. AFAIKS, there's no existing way to
scan a special "earlyprintk" node (from flat tree) which at a minimum contains a
"reg" property and some device specific platform info. There are only a few  other
drivers which uses the same design (e.g. tty/serial/sh-sci.c) but they don't seem
to be DT enabled. Thus in the short term we will have to live with static coding
for early platform device. Later on we can clean it up - I can take a stab at
adding earlyprintk based bits to fdt.c - if that makes sense.

2. We really need a Documentation/dt-for-new-linux-arches.txt, as the existing
refs - while very helpful - fail to mention subtleties such as you absolutely need
a intc instance and a default irq domain ..... before the driver can start using
the DT. Also the board specific callbacks etc are not really fundamental to the DT
concept (at least I initially thought so) causing a distraction when adding the
initial implementation. The minimal dynamic device population can very well be
done in a arch initcall. I'll sum these up in a documentation-for-dummies and
float around.

Thx,
-Vineet
