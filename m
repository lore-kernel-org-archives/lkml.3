Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab3CMPhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:37:19 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36065 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACmBeS01vs=fHOXu1Lnq8GX8YAbF6aBKmqopKPVt78mPYm=_9w@mail.gmail.com>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com>
	<CACmBeS01vs=fHOXu1Lnq8GX8YAbF6aBKmqopKPVt78mPYm=_9w@mail.gmail.com>
Date: Wed, 13 Mar 2013 16:37:16 +0100
Message-ID: <CACmBeS05cyT8N9nZeqbJUPMSGeZYLWjL0Tu1GSZ-ms+Hjc0UoQ@mail.gmail.com>
Subject: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        jirislaby@gmail.com, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ask for feedback and to submit (if possible) a new ARM SoC platform
port. This is now near complete (I think) (tested on UC-7112-LX Plus)
and applies to 2.6.34.14.

The patch contains the following drivers and platform specific implementations:

* ARCH_MOXART (FA526 processor)
* 100Hz interrupt timer
* UART
* MTD map driver
* Ethernet driver (RTL8201CP)
* MMC driver
* MOXA Smartio/Industio family multiport serial driver
* RTC driver
* Watchdog driver
* GPIO driver

Predicted patch rejects below (in need of a solution, feedback is much
appreciated) because they are critical in areas of boot, MMC and TTY.

arch/arm/boot/compressed/head.S:
A valid (and unique) architecture ID is not loaded to r1. Looks like
the bootloader is broken, it should be doing this!
http://gicl.cs.drexel.edu/people/sevy/linux/ARM_Linux_boot_sequence.html

arch/arm/tools/mach-types:
Omitted (do not edit manually / add a new machine using
http://www.arm.linux.org.uk/developer/machines/?action=new). A fix to
this and above is not feasible as long as MOXA withholds bootloader
sources (requested without success).

drivers/char/mxser.c drivers/char/mxser.h: MOXA
SMARTIO/INDUSTIO/INTELLIO SERIAL CARD (Jiří Slabý):
Force board setup for CONFIG_ARCH_MOXART.
ASYNCB_CLOSING is avoided because of a lockup (infinite wait after
tty_wait_until_sent). Why this happens is unknown (to me) I'm hoping
someone (Jiří?) can shed light. SysRq trace @ http://ideone.com/e845mr
What significance does ASYNCB_CLOSING have?
Obviously, automatic detection is better but "mxser_read_register" is
pointless on this hardware. What to do instead? Is it better to make a
copy and submit a new driver?

drivers/mmc/core/sd.c:
The MMC controller is "special"? "UNSTUFF_BITS" is redefined here
http://repo.or.cz/w/linux-2.6.19-moxart.git/blob/50cdf2c57662f9f69c5615976412f76bfd73311a:/drivers/mmc/mmc.c
. Without the new macro it'll report the wrong geometry and prod_name.
I'm thinking a driver should never have to redefine UNSTUFF_BITS.
Possible workaround: modify bits (in driver) to line up as expected
before returning the response (mmc_request_done).


For reference, this is my previous post from a few months back:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137130.html

Gitweb: http://repo.or.cz/w/linux-2.6.34.14-moxart.git/commitdiff/?h=3bc2e98ebb92961e1c5992736186920cd070f4ee&hp=b7f1d43323eceb02fd663a71eb2f8be9c17e6740

Download link (size: 193K):
https://linux-2-6-34-14-moxart.googlecode.com/files/linux-2.6.34.14-moxart.patch
