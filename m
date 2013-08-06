Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3HFFGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:06:37 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57055 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3HFFGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:06:36 -0400
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 13:06:35 +0800
Message-ID: <CAC7QxAeaaXg2kS1aRxUY7Y_4R7TDJ1cav-ut2TihAEnh68kZTA@mail.gmail.com>
Subject: Why name length of an array can hit case of "Inconsistent kallsyms
 data" fail
From: vincent Ho <squall.ho@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I'm porting a new mach for ARM. I hit a case to produce
"Inconsistent kallsyms data".
I try to find out the solution and then get an interesting case is
about "array name length"

Kernel is 3.4.56 and gcc version 4.3.5 (Buildroot 2010.11)

While register serial8250 platform device, the code are

>#include <linux/serial_8250.h>
>#include <mach/irqs.h>
>#include <mach/maps.h>
>#include <mach/hardware.h>

>static struct plat_serial8250_port abcdef_serial_platform_data[] = {
>{
>        .membase    = (void *)UARTC_0_MMR_BASE_VRT,
>        .mapbase    = VPL_UARTC_0_MMR_BASE_PHY,
>        .irq        = UARTC0_IRQ_NUM,
>        .uartclk    = 24000000,
>        .flags        = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_FIXED_TYPE,
>        .iotype        = UPIO_MEM32,
>        .regshift    = 2,
>        .type        = PORT_16550A,
>    },
>    {},
>};
> static struct platform_device board_serial_device = {
>    .name    = "serial8250",
>    .id    = PLAT8250_DEV_PLATFORM,
>    .dev    = {
>        .platform_data  = abcdef_serial_platform_data,
>    },
>};
>void __init board_serial_init(void)
>{
>    platform_device_register(&board_serial_device);
>}

Kernel make fail of original code by the "Inconsistent kallsyms data"  error.
BUT once I modified the array name of "abcdef_serial_platform_data" to
"abcde_serial_platform_data", i.e reduce one alphabet,
the Kernel make can complete without "Inconsistent kallsyms data" error.
I have no idea why the array name length can make difference.
There is no other change between these two make test, just modify the
array name.
Does this means some "Inconsistent kallsyms data" are caused by symbol
length and effects final two KSYM flow?
