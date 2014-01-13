Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaAMS3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:29:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaAMS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:29:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 5/5] init: efi: arm: enable (U)EFI runtime services on arm
Date: Mon, 13 Jan 2014 19:29:06 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org> <1389445524-30623-6-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1389445524-30623-6-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401131929.07236.arnd@arndb.de>
X-Provags-ID: V02:K0:K+7PG9c7H2HKFMZFlH/vjCzUkfrXep3Jvr/xcIYsI8S
 65BBrgKLqOJn4Jl9F/T0+x4O3+gtdr/HL8DgC8OrQKjEX7qtV8
 yev+jnlvQ26AfXIycFWq28FMqnfAXgnohtw5H2vstvafMvPkjC
 Jk7K0sVcjPkTNVEEWYHraGOIOYedJJU6jecx2OGW6Gy/DJr+Tf
 oDGlo9tUvFNXeigR1+owZcm0F6KZjRRuyBuLaMgF2xkmMY2iEq
 i8dOu+fPibxFckiH71FqOiLM1ZZI6+HVkrZNbS4O2AA/vvzpGH
 wxBNjr2UDPE5qgUhwNeFY3KVg/Il4ujVNMl1tleHEGlIfvPxRg
 cWtEnYPmbnBhgkhseNCo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 January 2014, Leif Lindholm wrote:
> diff --git a/init/main.c b/init/main.c
> index febc511..1331829 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -905,6 +905,10 @@ static noinline void __init kernel_init_freeable(void)
>         smp_prepare_cpus(setup_max_cpus);
>  
>         do_pre_smp_initcalls();
> +
> +       if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
> +               efi_enter_virtual_mode();

What is the dependency on CONFIG_ARM here? Wouldn't most other
architectures need the same? I'd rather not see this turn into
a long list of CONFIG_$(ARCH) checks if other architectures
enable it in the same place.

I also wonder why the three architectures implementing it all
call this from wildly different places during init/main.c, namely
(very early) setup_arch() on ia64, (relatively early) start_kernel
on x86 and (relatively late) kernel_init_freeable on arm.

In general, I'd be happy with adding this as late in the startup
code as possible, but it may be better to use the same place as
x86 in order to avoid surprises with unexpected dependencies.
One such dependency that may cause problems is the fact that
we (try to) call efi_late_init() before efi_enter_virtual_mode()
now.

	Arnd
