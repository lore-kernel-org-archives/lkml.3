Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaBLLvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:51:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBLLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:51:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Laura Abbott <lauraa@codeaurora.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Date: Wed, 12 Feb 2014 12:51:05 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402121251.06280.arnd@arndb.de>
X-Provags-ID: V02:K0:c4zTKF7tea0XS6mSn9zr4U0B3IOagVZzfuYhvLKSrRh
 GBKbPwnye9DGfkL4Z2f6ZpSCdHA95DPIhfjRxlgNpptU00p1Ue
 8dM1c6CB0eYwMLx5wppPirnqJDIuIy134VDuypBExhfNuxbmvV
 PIRK+qmzI5YHgMox29omzBbrNpzaoykWTsBJV1LHchhGXnP9QM
 QEjLkKrg4RPqTld4NTi85QeLeM2JEUwo9ZFHVsVPxp1iQRYLgp
 ZCCMD3fxPM7aAwWeSHr536f2aoxWHysUnmx3nCu85dHELP7bhm
 SXhY0yjJ657wQCwkivkchdnirQq8o08VL/OqFnt4HuFOD+Laci
 KGMFIMcjfM2FpyPwHs1w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014, Laura Abbott wrote:
> This is an RFC to seed the random number pool earlier when using devicetree.
> The big issue this is trying to solve is the fact that the stack canary for
> ARM tends to be the same across bootups of the same device. This is because
> the random number pools do not get initialized until after the canary has
> been set up. The canary can be moved later, but in general there is still
> no way to reliably get random numbers early for other features (e.g. vector
> randomization).

Implementation-wise this looks reasonable, and it obviously addresses a
very real problem.

> The goal here is to allow devices to add to the random pools via
> add_device_randomness or some other method of their chosing at FDT time.
> I realize that ARCH_RANDOM is already available but this didn't work because
> 1) ARCH_RANDOM is not multi-platform compatible without added
> infrastructure to ARM

That could certainly be done, but I agree that a more generic
approach like you did is nicer. One thing that might be useful
would be to wire up your OF_RANDOM infrastructure as a generic
implementation of ARCH_RANDOM, and merge your header file into
include/asm-generic/archrandom.h, with an added way to call
arch_get_random_long() for the devices you add.

> The big reason to skip ARCH_RANDOM though is that the random number generation
> we have would be reasonable if only seeded earlier.

Yes, makes sense.

I also wonder if we should add a 'trivial' implementation that just
reads a DT property full of random numbers to use as either an initial
seed, or to feed into arch_get_random_long(). This would allow the
boot loader to pass any entropy it has already gathered into the kernel,
but leaves the danger that people might pass static not-so-random data
through a precompiled dtb file ;-). If we get the boot loaders to be
smart enough, doing only this would be a much simpler kernel implementation
than your suggestion, but I'm not sure how far I want to trust boot loaders.

Another possibilitiy is to mix in the any contents of a "local-mac-address"
property into the entropy at early DT probing, which would still be
deterministic for a given machine and should not count as entropty,
but at least give each machine with this property a unique seed in the
absence of any other entropy source.

	Arnd
