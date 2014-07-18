Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946037AbaGRVAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:00:06 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:59224 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945944AbaGRVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:00:03 -0400
Date: Fri, 18 Jul 2014 22:59:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140718205953.GA21964@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:01:22PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Currently driver writers need to use io{read,write}{8,16,32}_rep() when
> accessing FIFO registers portably. This is bad for two reasons: it is
> inconsistent with how other registers are accessed using the standard
> {read,write}{b,w,l}() functions, which can lead to confusion. On some
> architectures the io{read,write}*() functions also need to perform some
> extra checks to determine whether an address is memory-mapped or refers
> to I/O space. Drivers which can be expected to never use I/O can safely
> use the {read,write}s{b,w,l,q}(), just like they use their non-string
> variants and there's no need for these extra checks.
> 
> This patch implements generic versions of readsb(), readsw(), readsl(),
> readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> these string functions for I/O accesses (ins*() and outs*() as well as
> ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> new functions.
> 
> Going forward, {read,write}{,s}{b,w,l,q}() should be used consistently
> by drivers for devices that will only ever be memory-mapped and hence
> don't need to access I/O space, whereas io{read,write}{8,16,32}_rep()
> should be used by drivers for devices that can be either memory-mapped
> or I/O-mapped.
> 
> While at it, also make sure that any of the functions provided as
> fallback for architectures that don't override them can't be overridden
> subsequently.
> 
> This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> find or build a cross-compiler that would run on my system. But by code
> inspection they shouldn't break with this patch.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Hi Thierry.

While browsing the resulting asm-generic/io.h it is irritating
that the functions are messed up like they are.

>From the start of the file the IO accessors are defined in following order:
__raw_readb
__raw_readw
__raw_readl

readb
readw
readl

__raw_writeb
__raw_writew
__raw_writel

writeb
writew
writel

__raw_readq

readq

__raw_writeq

writeq


See how strange it looks?

A semi related question.
Why do we play all these macro tricks in io.h?

Example:

    #define writeb __raw_writeb

The consensus these days is to use static inline to have the
correct prototype but this file is contains a lot of these
macro conversions.

All these things are not introduced by your patch but now that
you show some love and care for this file maybe we could take
the next step and bring more order to the current semi chaos?

	Sam
