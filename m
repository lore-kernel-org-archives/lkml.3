Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbbAHXZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 18:25:13 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34208 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbAHXZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:25:10 -0500
Message-ID: <54AF11CF.9080600@hurleysoftware.com>
Date: Thu, 08 Jan 2015 18:25:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>	<20150108131008.16c9a31c@lxorguk.ukuu.org.uk>	<54AEAC47.1040403@hurleysoftware.com>	<1896224.oMI8M6J5T7@wuerfel> <20150108223626.43fd93d5@lxorguk.ukuu.org.uk>
In-Reply-To: <20150108223626.43fd93d5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 05:36 PM, One Thousand Gnomes wrote:
>> One idea that has come up in the past but never saw an implementation
>> is to make the ttyS namespace and minor numbers completely generic and
>> let any serial port driver use it. This would be a major rework, but
>> have the added advantage of cleaning up a number of other namespace
>> issues as well. There also lots of open question, in particular how
>> to maintain compatibility with existing drivers. One could imagine
>> that each uart always gets a ttyS device and optionally also gets
>> a device node for the same port with a driver specific chardev as
>> most of them do today. Or it could be an either/or decision that is
>> made at compile time or as a module parameter.
> 
> I'm not sure we should use ttyS for it. ttyS means 8250, a lot of
> existing code knows what ttyS is and what sort of ioctls and the like are
> assumed.

That genie has already escaped the bottle.

./arch/powerpc/platforms/powermac/setup.c:	char *devname = "ttyS";
./arch/powerpc/platforms/chrp/setup.c:		add_preferred_console("ttyS", 0, NULL);
./arch/powerpc/kernel/legacy_serial.c:		return add_preferred_console("ttyS", offset, opt);
./arch/xtensa/platforms/iss/console.c:	serial_driver->name = "ttyS";
./arch/mips/sni/setup.c:			add_preferred_console("ttyS", port,
./arch/mips/sgi-ip32/ip32-setup.c:			add_preferred_console("ttyS", *(con + 1) == '2' ? 1 : 0,
./arch/mips/jazz/setup.c:	add_preferred_console("ttyS", 0, "9600");
./arch/mips/sgi-ip22/ip22-setup.c:		add_preferred_console("ttyS", *(ctype + 1) == '2' ? 1 : 0,
./arch/arm/mach-davinci/board-da830-evm.c:	return add_preferred_console("ttyS", 2, "115200");
./arch/arm/mach-davinci/board-mityomapl138.c:	return add_preferred_console("ttyS", 1, "115200");
./arch/arm/mach-davinci/board-da850-evm.c:	return add_preferred_console("ttyS", 2, "115200");
./arch/arm/mach-davinci/board-omapl138-hawk.c:	return add_preferred_console("ttyS", 2, "115200");
./arch/cris/arch-v10/kernel/debugport.c:	name : "ttyS",
./arch/ia64/hp/sim/simserial.c:	hp_simserial_driver->name = "ttyS";
./arch/um/drivers/ssl.c:	.device_name 		= "ttyS",
./arch/s390/kernel/setup.c:			add_preferred_console("ttyS", 1, NULL);
./drivers/tty/amiserial.c:	.name =		"ttyS",
./drivers/tty/serial/serial_txx9.c:#define TXX9_TTY_NAME "ttyS"
./drivers/tty/serial/sunsab.c:	.dev_name		= "ttyS",
./drivers/tty/serial/mcf.c:	.dev_name	= "ttyS",
./drivers/tty/serial/atmel_serial.c:#define ATMEL_DEVICENAME	"ttyS"
./drivers/tty/serial/bcm63xx_uart.c:	.dev_name	= "ttyS",
./drivers/tty/serial/sunsu.c:	.dev_name		= "ttyS",
./drivers/tty/serial/mrst_max3110.c:	.dev_name	= "ttyS",
./drivers/tty/serial/apbuart.c:	.name = "ttyS",
./drivers/tty/serial/apbuart.c:	.dev_name = "ttyS",
./drivers/tty/serial/tilegx.c:#define TILEGX_UART_NAME	"ttyS"
./drivers/tty/serial/pmac_zilog.c:#define PMACZILOG_NAME		"ttyS"
./drivers/tty/serial/pnx8xxx_uart.c:	.dev_name		= "ttyS",
./drivers/tty/serial/m32r_sio.c:	.dev_name		= "ttyS",
./drivers/tty/serial/ip22zilog.c:	.dev_name	= "ttyS",
./drivers/tty/serial/zs.c:	.dev_name		= "ttyS",
./drivers/tty/serial/68328serial.c:	serial_driver->name = "ttyS";
./drivers/tty/serial/crisv10.c:	driver->name = "ttyS";
/drivers/tty/serial/8250/8250_core.c:	.dev_name		= "ttyS",
./drivers/tty/serial/sunzilog.c:	.dev_name	=	"ttyS",
./drivers/tty/serial/pxa.c:	.dev_name	= "ttyS",
./drivers/tty/serial/dz.c:	.dev_name		= "ttyS",
./drivers/tty/serial/sunhv.c:	.dev_name		= "ttyS",
./drivers/s390/char/sclp_vt220.c:#define SCLP_VT220_CONSOLE_NAME		"ttyS"
./drivers/s390/char/sclp_con.c:#define sclp_console_name  "ttyS"
./drivers/s390/char/con3215.c:	driver->name = "ttyS";


Besides, despite its pedigree, omap is no closer to 8250 than anything
else in drivers/tty/serial/

> A generic namespace needs not to be attached to a legacy naming 
> 
> (eg also put all serial ports in /dev/serial/0 /dev/serial/1 etc either
> via the tty layer or via systemd/udev)

This doesn't address pre-init.

Regards,
Peter Hurley
