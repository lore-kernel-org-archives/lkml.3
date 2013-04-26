Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab3DZJfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:35:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3DZJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:35:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        magnus.p.persson@stericsson.com,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
Date: Fri, 26 Apr 2013 11:34:54 +0200
Message-ID: <1412321.eb7x7S18CK@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <201304251611.39667.arnd@arndb.de> <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Iyo71a3JgkLGmtMZnbCzZq6gAwz2BHR+WkofYMKqL/b
 EIKJWZlY2fg2CdLmygw9tWaonPQTvE3y9BNmz2FM7D7YyhF5cM
 kBUK6dh8O3glvMwAUfTJlscqzqNlTeIk/BEy9Dh6wtqepBHuij
 6ff9u+jR/7p+qkw7DpFhy6B6HTfm2kSPUfbvfEjXuwWZzr5iJk
 rvPWIOkiTzeVcy57Yt8hygMCI5zSVzGMA7TG8NGpwmVd1CFIB+
 ozgeihlnOMgHKAJj8WJPgctCdL8TNw133/bkjMvrMf2ERFnqiA
 WbGTJYKFx0TK5QbYBvhLA2Zu2jfdToD1c686uXIFTneVouBc/d
 OG7iPqiUKezKy1a3656E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013 10:28:39 Linus Walleij wrote:
> 
> However this rings a bell that there may be a possible relation to
> DMA-API, since that API syncs memory buffers to the DMA
> address space if there is some MMU inbetween the DMA and the
> (ordinary, non-device) memory.
> 
> So if we think one step ahead, assuming the DMAC is actually behind
> an MMU making it see the device in some other address than the
> physical (bus) space, where would the address be resolved?

We don't currently have the infrastructure for that I think.
The dma-mapping API has some of the required parts but not all,
in particular it's only designed for mapping pages from the linear
kernel memory into the bus address space, not for devices.

The iommu API could do it for devices that have an IOMMU, but
it's not the best fit, because it does not abstract away the
presence of an IOMMU.

Another missing part is parsing the "dma-ranges" properties in
device tree, which you need to do if the address space translation
is not 1:1, and to find out which side of the IOMMU the DMA master
is connected to: if it's on the bus side, you need 1:1 mapping
and if it's on the host side, you need an IO page table entry.

	Arnd
