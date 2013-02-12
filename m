Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3BLKL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:11:56 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63217 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab3BLKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:11:54 -0500
MIME-Version: 1.0
In-Reply-To: <201302111608.29304.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302111543.46196.arnd@arndb.de>
	<CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
	<201302111608.29304.arnd@arndb.de>
Date: Tue, 12 Feb 2013 11:11:53 +0100
Message-ID: <CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/11 Arnd Bergmann <arnd@arndb.de>:
> On Monday 11 February 2013, Michal Simek wrote:
>> Unfortunately no. Another is spi/i2c (sysace as we discuss in this
>> thread), probably icap
>> network drivers are ok because they are not shared.
>> Timer when it is moved to clocksource(not important right now)
>> xilinx gpio is using __raw IO functions which is incorrect on arm in
>> connection to barriers.
>>
>> But it reminds me that maybe the easiest solution is not to use endian
>> accessors just use two simple macros which should work on all systems.
>>
>> #define <name>_readreg(offset)          ({__raw_readl(offset); rmb(); })
>> #define <name>_writereg(offset, val)    ({wmb(); __raw_writel(val, offset); })
>>
>> which is probably the faster solution which add minimum additional code
>> to driver and can also remove endian detection code.
>
> I tend to disagree. You should never assume that a device is the same
> endianess as the the CPU, and you should try not to use the __raw_*
> accessors in device drivers either.
>
> In particular, ARM can run both big- and little-endian even though
> big-endian is rarely used, so you need to know the endianess for
> the device you are talking to rather than assume that it knows
> what the CPU does at the time.

For high performance IPs using accessors functions is still problematic
because there will be performance regression it means that
from my point of view there still should be any option to "setup"
proper endians for the driver and it can't be setup at run-time.

Sure the question is if drivers like this should be in the mainline.
But if yes, there should be an option to do it in acceptable way.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
