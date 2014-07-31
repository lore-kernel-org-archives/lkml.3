Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaGaUJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:09:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39877 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGaUJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:09:50 -0400
X-CheckPoint: {53DAA28C-8-2100090A-C0000000}
Message-ID: <53DAA28C.508@tilera.com>
Date: Thu, 31 Jul 2014 16:09:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chen Gang <gang.chen.5i5j@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <dmitry.torokhov@gmail.com>, <linux-iio@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, <teg@jklm.no>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, <msalter@redhat.com>,
        <linux-pwm@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-watchdog@vger.kernel.org>, <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <knaack.h@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        <Mischa.Jonker@synopsys.com>, <jic23@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <53C7B365.4080000@gmail.com> <53C834EA.5030605@tilera.com> <5190668.jExaFa8pKn@wuerfel>
In-Reply-To: <5190668.jExaFa8pKn@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/2014 5:05 PM, Arnd Bergmann wrote:
> On Thursday 17 July 2014 16:41:14 Chris Metcalf wrote:
>> On 7/17/2014 7:28 AM, Chen Gang wrote:
>>> According to current source code, tile still has chance to choose
>>> NO_IOMEM, for me, welcome the tile's maintainer's ideas or suggestions.
>> I'm not really sure.  It's true that on tile, if you don't enable PCI
>> support there's no other I/O memory (or I/O port) space you can use.
>> We pretty much always enable PCI support in our kernel, though.  I'm
>> kind of surprised that other architectures don't also have the model
>> that IOMEM requires PCI, but perhaps most architectures just don't
>> encode that in the Kconfig file?
> Only s390 as far as I know. Most architectures have integrated
> peripherals that use MMIO without PCI.

Yes, and tilegx has these too (quite a few of them).  The memory-mapped
devices are accessed by specifying a shim x,y coordinate in the high bits
of the physical address, in conjunction with an MMIO type in the TLB entry.
Various tilegx drivers set up these kinds of mappings in the page table.

The issue with ioremap() is that it takes a generic resource_size_t
"physical address", and we don't have any general-purpose layer that maps
particular PAs to shim coordinates, other than for TRIO (our PCI peripheral).
Right now we just check the PCI root complexes that we have configured in
the kernel, and if the pseudo physical address requested is in a range that
we're associating with one of the root complexes, we will use the appropriate
mapping against the appropriate TRIO shim to set up its x,y coordinate in
the page table.

So it makes some kind of sense to condition HAS_IOMEM on PCI, even though
naively it seems like it shouldn't be strictly related.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

