Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3BKP5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:57:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57291 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3BKP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:57:12 -0500
MIME-Version: 1.0
In-Reply-To: <201302111543.46196.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302111526.37892.arnd@arndb.de>
	<CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
	<201302111543.46196.arnd@arndb.de>
Date: Mon, 11 Feb 2013 16:57:04 +0100
Message-ID: <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
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
>> I have just found that it won't be so easy as I thought because I have found
>> that microblaze wrong implementation was done because of others device drivers.
>> It means that I have to fix all device drivers to support big and
>> little endian accessors
>> first before I can switch microblaze to asm-generic/io.h. :-(
>>
>> BTW: If you want to take this patch though your tree then ok, or it
>> can go through my
>> microblaze tree. Both ways should just work.
>
> Please use your tree then. I don't have any asm-generic patches
> lined up for 3.9 myself, so we can save me and Linus a little work
> with a trivial pull request that way.
>
>> I will send the patch for uarlite when I finish my testing on
>> microblaze, ppc and arm.
>
> Ok. Is that the only one that you found to require the "wrong-endian" mode
> in microblaze.

Unfortunately no. Another is spi/i2c (sysace as we discuss in this
thread), probably icap
network drivers are ok because they are not shared.
Timer when it is moved to clocksource(not important right now)
xilinx gpio is using __raw IO functions which is incorrect on arm in
connection to barriers.

But it reminds me that maybe the easiest solution is not to use endian
accessors just use two simple macros which should work on all systems.

#define <name>_readreg(offset)		({__raw_readl(offset); rmb(); })
#define <name>_writereg(offset, val)	({wmb(); __raw_writel(val, offset); })

which is probably the faster solution which add minimum additional code
to driver and can also remove endian detection code.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
