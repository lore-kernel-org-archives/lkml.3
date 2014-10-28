Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaJ1PBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:01:13 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61976 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaJ1PBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-kernel@vger.kernel.org, Xia Kaixu <kaixu.xia@linaro.org>
Subject: Re: [PATCH v2 5/5] ARM: use early console instead of early debug in allmodconfig kernels
Date: Tue, 28 Oct 2014 16:01:02 +0100
Message-ID: <1974731.Nqyg6BoJOO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028143536.GI27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <3063784.TXO37ZkrnY@wuerfel> <20141028143536.GI27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1GSnHDx8JZnMc5z7LE8BeBHwyqhFbbLZxaJHKOIW0rp
 iM/2VXkUSUoSsUgm9R5jar9JaDOfkOtjr+5mtZgXDVhuoJWXyt
 n+1orNXtAOw9z8lEOSQjnOGmpzk3NtF2LH9kYhWpWcQ0QCUq8N
 NRr7y7+FLoailT8ENH1vDecSiQ1WN8S5Y0yUxYz0ottF7pPbKK
 WcVhnzGUA6XSH2vjM34d8TvwzAbOrU15jOj9E4bW6VtOy2mW7F
 aSsppIMqyIeCCbCD7JUl/2R0O0JUYIostkCOmvKRD3B3FlRAll
 wM6JIXtybtbDGNw9UCiiLZOmtY5g8AqosMdu5cCudxzPwacjoq
 JY5U4GdGoyENgs68rUmY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 14:35:36 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 03:29:01PM +0100, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 14:05:36 Russell King - ARM Linux wrote:
> > > On Tue, Oct 28, 2014 at 09:31:35PM +0800, Xia Kaixu wrote:
> > > > The early debug could break something when booting 'allmodconfig'
> > > > kernels. So we use early console instead of early debug.
> > > > 
> > > > The early console didn't work yet on OMAP4460 because of missing
> > > > earlycon support and I am working on that.
> > > 
> > > No. bloody. way.
> > > 
> > > > @@ -78,7 +78,7 @@ config DEBUG_USER
> > > >  # These options are only for real kernel hackers who want to get their hands dirty.
> > > >  config DEBUG_LL
> > > >       bool "Kernel low-level debugging functions (read help!)"
> > > > -     depends on DEBUG_KERNEL
> > > > +     depends on DEBUG_KERNEL && !ARCH_MULTIPLATFORM_STRICT
> > > 
> > > Firstly, this is well advertised that it can only be applied to a single
> > > configuration.  So I don't think we need this dependency here.  Even if
> > > you want to build a strict multiplatform kernel, it should still be
> > > possible to enable this for a specific platform.
> > 
> > I've asked Kaixu to do this patch. This is one of the most fundamental
> > uses of ARCH_MULTIPLATFORM_STRICT: as soon as you turn on DEBUG_LL, the
> > kernel no longer runs on any other platform, so it can still be built
> > as a multiplatform kernel, but not a "strict" one that is known to
> > work on all hardware that is enabled.
> 
> No, that is not correct.  You can turn on DEBUG_LL, and a multiplatform
> kernel will still run.
> 
> The point at which it won't run is if you call the DEBUG_LL function on
> a platform it wasn't configured for.  That happens if you start using
> the printascii() et.al. functions, or (against my better judgement) the
> early console support is enabled.
>
> So, as the early console support went against my wishes there, I see
> this problem as more of an early console problem than a DEBUG_LL problem.

Good point, yes.

What about DEBUG_UNCOMPRESS then? It is currently defined as

config DEBUG_UNCOMPRESS
        bool
        depends on ARCH_MULTIPLATFORM || ARCH_MSM || PLAT_SAMSUNG
        default y if DEBUG_LL && !DEBUG_OMAP2PLUS_UART && \
                     (!DEBUG_TEGRA_UART || !ZBOOT_ROM)

so it will be turned on implicitly when DEBUG_LL is set on a
multiplatform kernel. Doesn't that cause an external abort or similar
as soon as you start writing to some random physical address from the
decompressor when running on the wrong platform?

	Arnd
