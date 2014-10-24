Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbaJXKiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:38:19 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54556 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaJXKiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:38:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Date: Fri, 24 Oct 2014 12:37:33 +0200
Message-ID: <7410166.17BME9oUT7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1410231607340.6969@knanqh.ubzr>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org> <20141023195119.GL27405@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1410231607340.6969@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PlnmExFmwrFoBjFicoDbv/tDJqnvIOuuv+QaV83vxza
 vbQbWZydW8M5+hGuWY/YtyIbaoYn1+NoSxRMbP0IjGUOI+j7ur
 YD7RwkgzLKjcXJj80yzMsYKJfqMWUT5dMIpYk5l+G4BU1itSaD
 4l+iTWy6wwCN5zQIu7hl6IGM0pKWAuiavwDNF6YmzSjv7xOP35
 q0xJKSS60gxWZHx3EDxDh0zLod23BIjYj8EhxnB7w0aW24nKpT
 T4aesfaHiPEBr07d8Qz0/Mxs2HHFRdgG9IBrc3525w+FaWQO9R
 tgj6XffNtmFKN06msyUECoflptTNXEWrzZsHp1x6ACInC4Dp1g
 m3PK8vyfoYXORbS/Xnag=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2014 16:15:19 Nicolas Pitre wrote:
> On Thu, 23 Oct 2014, Russell King - ARM Linux wrote:
> 
> > On Thu, Oct 23, 2014 at 03:47:32PM -0400, Nicolas Pitre wrote:
> > > On Wed, 22 Oct 2014, Catalin Marinas wrote:
> > > 
> > > > On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
> > > > > +#if __LINUX_ARM_ARCH__ >= 5
> > > > 
> > > > My old ARMv5 book does not list LDRD/STRD. It looks like they only come
> > > > with ARMv5TE. Are there any processors prior to this supported by the
> > > > kernel?
> > > 
> > > We still supports ARMv4 targets.
> > > 
> > > As far as I know, all the ARMv5 targets we support are also TE capable.
> > 
> > Not quite.  We have ARM1020, which according to our proc-*.S files is
> > only ARMv5T, not ARMv5TE.

Does this actually work when we are building with -march=armv5te?

The Makefile contains this line:

arch-$(CONFIG_CPU_32v5) =-D__LINUX_ARM_ARCH__=5 $(call cc-option,-march=armv5te,-march=armv4t)

which looks like it would break for ARM1020.


On a related note, I also wonder about this part:

tune-$(CONFIG_CPU_ARM946E)      =$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
tune-$(CONFIG_CPU_ARM920T)      =-mtune=arm9tdmi
tune-$(CONFIG_CPU_ARM922T)      =-mtune=arm9tdmi
tune-$(CONFIG_CPU_ARM925T)      =-mtune=arm9tdmi
tune-$(CONFIG_CPU_ARM926T)      =-mtune=arm9tdmi

I stumbled over this a while ago and couldn't figure it out. Does ARM926T
actually exist, or is that a mistake that should actually be ARM926E?

If this is always ARM926E, shouldn't we build with -mtune=arm9e as we do
for ARM946E?

> Oh well.  Never saw such a beast in the field though.

The only ARM10 implementation aside from integrator/realview that I'm aware
of is an ARM1026E based Conexant/Ikanos DSL modem SoC (CX94xxx), and that
is of course ARMv5TE.

> Maybe to be on the very safe side, given that no ARMV5TE is likely to 
> need 64-bit IO accessors at this point, this could simply be 
> __LINUX_ARM_ARCH__ >= 6 instead.

Which drivers need that support anyway? We definitely need to ensure
that we don't try to build them on architectures without this support
when CONFIG_COMPILE_TEST is set.

	Arnd
