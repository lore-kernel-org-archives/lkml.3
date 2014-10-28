Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaJ1Ofr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:35:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47296 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751400AbaJ1Ofp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:35:45 -0400
Date: Tue, 28 Oct 2014 14:35:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] ARM: use early console instead of early debug in
 allmodconfig kernels
Message-ID: <20141028143536.GI27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-6-git-send-email-kaixu.xia@linaro.org>
 <20141028140536.GF27405@n2100.arm.linux.org.uk>
 <3063784.TXO37ZkrnY@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3063784.TXO37ZkrnY@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:29:01PM +0100, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 14:05:36 Russell King - ARM Linux wrote:
> > On Tue, Oct 28, 2014 at 09:31:35PM +0800, Xia Kaixu wrote:
> > > The early debug could break something when booting 'allmodconfig'
> > > kernels. So we use early console instead of early debug.
> > > 
> > > The early console didn't work yet on OMAP4460 because of missing
> > > earlycon support and I am working on that.
> > 
> > No. bloody. way.
> > 
> > > @@ -78,7 +78,7 @@ config DEBUG_USER
> > >  # These options are only for real kernel hackers who want to get their hands dirty.
> > >  config DEBUG_LL
> > >       bool "Kernel low-level debugging functions (read help!)"
> > > -     depends on DEBUG_KERNEL
> > > +     depends on DEBUG_KERNEL && !ARCH_MULTIPLATFORM_STRICT
> > 
> > Firstly, this is well advertised that it can only be applied to a single
> > configuration.  So I don't think we need this dependency here.  Even if
> > you want to build a strict multiplatform kernel, it should still be
> > possible to enable this for a specific platform.
> 
> I've asked Kaixu to do this patch. This is one of the most fundamental
> uses of ARCH_MULTIPLATFORM_STRICT: as soon as you turn on DEBUG_LL, the
> kernel no longer runs on any other platform, so it can still be built
> as a multiplatform kernel, but not a "strict" one that is known to
> work on all hardware that is enabled.

No, that is not correct.  You can turn on DEBUG_LL, and a multiplatform
kernel will still run.

The point at which it won't run is if you call the DEBUG_LL function on
a platform it wasn't configured for.  That happens if you start using
the printascii() et.al. functions, or (against my better judgement) the
early console support is enabled.

So, as the early console support went against my wishes there, I see
this problem as more of an early console problem than a DEBUG_LL problem.

> Exactly, and I think it's not asking too much from a developer to turn
> off ARCH_MULTIPLATFORM_STRICT if they want to turn on DEBUG_LL. Nothing
> else should change if you do that.
> 
> The main use of the symbol is really to avoid turning on DEBUG_LL is
> allmodconfig kernels, which will always enable ARCH_MULTIPLATFORM_STRICT.

It's pointless if that's all that ARCH_MULTIPLATFORM_STRICT ends up
doing.  It just needlessly adds extra configuration options.  There's
already thousands of kernel options, we don't need any more stupid
idiotic options to clutter the already densely populated forest, and
make it yet harder to work out wtf we're doing with all these options.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
