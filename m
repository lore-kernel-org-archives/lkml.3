Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaJ1OvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:51:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52174 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaJ1OvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:51:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] ARM: allow errata and XIP options to be enabled without ARCH_MULTIPLATFORM_STRICT
Date: Tue, 28 Oct 2014 15:50:31 +0100
Message-ID: <1831362.dUvM0VHfPi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028143118.GH27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <6893071.4YhqEbdaBz@wuerfel> <20141028143118.GH27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QULWjnn4bz6B/IFD2o7LoGQehh89aM9zvjqJwJatZuq
 rs5jm+Bip1QCHDdrY0kvk+OQmBOGpTk5kbk6UhITZezfTTFtT3
 HYTjMsuWMq9rnltKzSr475X4zGrbWv8HHE0YzKI8Y2KNQX/gO3
 mgHdzggPHIonakb+R+cHeoVOxWyt5Kp7qtjXHjsr2af6vR6QHS
 QEYIjOTd2l+4jeVAESOBAKhvWqLbFzecgDCDABBGWmZCgeC3Og
 TmCAM/rM7AzOAOcq9fQSgrWdmoZv5U7iFTIgxx9jNV+sEWLznD
 4Nvs//HYRzZL43uFKiKNRkQ2mtFnZ2ykFfecczJMPfG5BUAilY
 IVBem+SgW9emaH90cHxY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 14:31:18 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 03:24:38PM +0100, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 14:02:31 Russell King - ARM Linux wrote:
> > > On Tue, Oct 28, 2014 at 09:31:34PM +0800, Xia Kaixu wrote:
> > > > With the ARCH_MULTIPLATFORM_STRICT option, it becomes much easier to
> > > > enable the ERRATA options when we know at configuration time that we
> > > > don't care about the generic case. The previous configuration makes
> > > > XIP_KERNEL option fundamentally non-MULTIPLATFORM, but it's still
> > > > valid to select it when building for !ARCH_MULTIPLATFORM_STRICT and
> > > > selecting only the one machine that you want to run on.
> > > 
> > > XIP_KERNEL isn't supported on anything past ARMv5 though.
> > 
> > I would really like to get some of the platforms that currently use
> > XIP_KERNEL to use ARCH_MULTIPLATFORM in the long run. One of them
> > is EFM32, which is ARMv7-M.
> 
> Right, and on ARMv7-M, the restrictions against XIP_KERNEL don't apply.
> The restrictions on XIP_KERNEL only apply with MMU-full kernels, because
> of the remapping needed - the kernel is executed from flash, which is
> mapped separately, and that mapping needs to be setup in order to turn
> the MMU on.
> 
> With ARMv7-M, there is no MMU to worry about, no other mappings are
> required, so there is no special platform specific setup applicable.
> 
> So, I don't see any reason why XIP_KERNEL can't depend on
> !ARCH_MULTIPLATFORM || CPU_V7M.

That would solve the problem for V7M, but I also don't see a reason
to disallow XIP_KERNEL on a platform that depends on ARCH_MULTIPLATFORM.

The main problem is that any ARMv4/v5 platform that currently uses
XIP_KERNEL breaks when we do a conversion to ARCH_MULTIPLATFORM, and
I think that is bad.

The same applies to ZBOOT_ROM, which we should probably treat the
same way here. An example for that is the Renesas SH-Mobile SH7372 that
can boot directly from MMC. I really want Renesas to convert
all of their SH-Mobile machines to multiplatform, just like all other
ARMv7 platforms. There is nothing preventing you from running a
multiplatform kernel on SH7372 as long as you don't want to load the
kernel from MMC without a proper bootloader. I also don't see a reason
to take out that feature just because they are migrating to multiplatform
(there may or may not be other reasons to deprecate this feature, but that
is a different matter). At the moment SH-Mobile can be built either
as a standalone platform or as multiplatform, but even now you can build
a kernel that uses CONFIG_ZBOOT_ROM_MMCIF and will only ever work on
SH7372 but includes all other shmobile targets as well.

I don't see anything wrong with that, and I would like to see this
keep working when SH7372 is part of ARCH_MULTIPLATFORM, but at the
same time think it's good to have ARCH_MULTIPLATFORM_STRICT to prevent
this from being selected for a kernel that is supposed to run everywhere.

	Arnd
