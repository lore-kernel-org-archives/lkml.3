Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaFLNiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:38:04 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62419 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaFLNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:37:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Date: Thu, 12 Jun 2014 15:37:18 +0200
Message-ID: <6046244.oz0lY2JOaZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140612130330.GG23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk> <10376496.xoRI3F9EzH@wuerfel> <20140612130330.GG23430@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aq/oQIIEWtU8cRXvXRIGy7SkYZUhgeaoE5b6ksn7a+L
 9EC9RXu1kuOyM90PVpGjKY3I9XmBiCohOACdXh83gu4I3bXJ2Z
 TUF13vhpxVx7o0bOeAMopvIJA59noqI4dLHlrl81g7nEXy9blV
 JMDY0qHcirxsgOHnsNIV9Gpgky5CLa3ZPyaKzG3xu4XEIFKOSt
 51pUEY1sN6ptrpac7eClXoF6+OlULxWWcL1fa/tgdcme4Ky5XY
 g24Ar95Ok5JHzkCtyBvFzUVg8Pag8q302k0xsUC21m56WYi02i
 +41OzEPCJpHJc9lLRTDKwLZNJy33XCO/ajIHzabmpVgV0FXIol
 eSTXcLk1GgcpNtTo1lSg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2014 14:03:30 Russell King - ARM Linux wrote:
> On Thu, Jun 12, 2014 at 02:19:45PM +0200, Arnd Bergmann wrote:
> > On Thursday 12 June 2014 12:34:45 Russell King - ARM Linux wrote:
> > > On Thu, Jun 12, 2014 at 12:31:19PM +0200, Arnd Bergmann wrote:
> > > > On Thursday 12 June 2014 10:47:45 Russell King - ARM Linux wrote:
> > > > > If no one responds, I'll assume that no one is interested, and I'll
> > > > > just create a pile of patches removing a bunch of these idiotic select
> > > > > statements at random to break this loop.
> > > > 
> > > > I missed the original mail, and I don't remember seeing this particular
> > > > dependency chain.
> > > > 
> > > > > On Sat, Jun 07, 2014 at 10:09:44AM +0100, Russell King - ARM Linux wrote:
> > > > > > This is getting silly:
> > > > > > 
> > > > > > scripts/kconfig/conf --silentoldconfig Kconfig
> > > > > > drivers/dma/Kconfig:5:error: recursive dependency detected!
> > > > > > drivers/dma/Kconfig:5:  symbol DMADEVICES is selected by SAMSUNG_DMADEV
> > > > 
> > > > The 'select DMADEVICES' from plat-samsung/Kconfig is certainly wrong,
> > > > we shouldn't do that, but I'd do some extended build regression tests
> > > > to ensure that it doesn't cause other problems.
> > > > 
> > > > I'll have a look.
> > > 
> > > Yes, SAMSUNG_DMADEV looks like it's a shim layer between DMA engine and
> > > the old Samsung platform private DMA API.  I suspect SAMSUNG_DMADEV should
> > > be selected by the drivers which make use of this shim iff DMADEVICES is
> > > enabled.
> > 
> > FWIW, SAMSUNG_DMADEV should get removed in 3.17. At the moment
> > there is only one user (sound/soc/samsung/ac97.c), and that is
> > broken because it calls a NULL function pointer returned from
> > samsung_dma_get_ops().
> 
> Well, we can't wait for 3.17 to fix this, because attempting to build
> an allyesconfig/allmodconfig/randconfig today fails.  Just look at the
> failures of those four configurations on my autobuilder over the last
> few days.

I didn't say we should not fix it, I just meant we don't need to spend
too much time on a perfect solution for code that is going away and that
is already not used anywhere.

I've just replied to an older thread "Re: [PATCH 1/2] [RFC] ASoC: samsung:
move s3c24xx over to dmaengine" with a patch that would let us kill off
the code right away, or at least disable it in Kconfig.

For some reason, I can't reproduce the failure you see in your build system,
I tried torvalds/master and next/master today and I have also done
allmodconfig and randconfig builds in the past few days on slightly
older versions.

> In some cases, kconf generates a configuration, spitting out these
> warnings, but then when you try and build that configuration, it then
> goes on to complain that some symbols need user input.  In other words,
> the first resulting configuration file from the make allyesconfig/
> allmodconfig/randconfig is invalid because the dependencies have not
> reached stability.

I think it just gives up when it sees a recursive dependency, so instead
you start out with whatever the oldconfig was, rather than actually
building the 'allmodconfig' you asked for.

	Arnd
