Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaGQVF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:05:57 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53521 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaGQVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:05:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Thu, 17 Jul 2014 23:05:12 +0200
Message-ID: <5190668.jExaFa8pKn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C834EA.5030605@tilera.com>
References: <201407130545.23004.marex@denx.de> <53C7B365.4080000@gmail.com> <53C834EA.5030605@tilera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VtI4fSVAFsuGXMIqBIPBN8QTWg4KdlZwrVPpeBU+AqM
 ByFHuhILR/2ul0mL2xV41A9v/u8m/Fr8zkjJzrkCp9nw82d+zW
 YcwIueO3C2/E3SsRS4qNW9vag4NKQ/MWAIZrhf7Wo8+f0d/XNt
 kn6KFWorl/GoN7+DqbPCkWx85p8IOuk4DhwhsqRXW2RF6UJcDc
 ZSAFwwvEGZkK8/n0LsCkGCKOm3QZzCtdSbfTkRWGSMAysquj0P
 yXJCfZnZTJmemyJBRO0xnEzKNUolkTsleuygc2GeO8itsgA/1Y
 0PI2N060XBvGXW8/nzK9ehu63RqQQCDYNU6OzOu/S97S1p6No1
 cvpG8Qo++sMN+4vPmWU0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 16:41:14 Chris Metcalf wrote:
> On 7/17/2014 7:28 AM, Chen Gang wrote:
> > On 07/17/2014 06:48 PM, Arnd Bergmann wrote:
> >> AFAICT, NO_IOMEM only has a real purpose on UML these days. Could we take
> >> a shortcut here and make COMPILE_TEST depend on !UML? Getting random stuff
> >> to build on UML seems pointless to me and we special-case it in a number of
> >> places already.
> >>
> > According to current source code, tile still has chance to choose
> > NO_IOMEM, for me, welcome the tile's maintainer's ideas or suggestions.
> 
> I'm not really sure.  It's true that on tile, if you don't enable PCI
> support there's no other I/O memory (or I/O port) space you can use.
> We pretty much always enable PCI support in our kernel, though.  I'm
> kind of surprised that other architectures don't also have the model
> that IOMEM requires PCI, but perhaps most architectures just don't
> encode that in the Kconfig file?

Only s390 as far as I know. Most architectures have integrated
peripherals that use MMIO without PCI.

> My observation is just that if I remove the "NO_IOMEM if !PCI" from
> arch/tile/Kconfig, my build fails with ioremap() undefined.  No doubt I
> could work around that, but my assumption was that NO_IOMEM was exactly the
> right thing to express the fact that without PCI there is no I/O memory 

Your assumption is correct.

For tile by itself it would certainly be best to leave this
dependency, it makes no sense to enable IOMEM without PCI.

That doesn't solve the problem of COMPILE_TEST enabling drivers
that require IOMEM though. An easy hack for that would be to
make COMPILE_TEST depend on HAS_IOMEM, but it gets into hacky territory
there, and it's not clear if this is any better than the original patch
to provide fallbacks for ioremap and friends. Definitely simpler
though.

	Arnd
