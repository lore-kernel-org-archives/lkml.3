Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3HVQPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:15:42 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55167 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3HVQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <1377157484-28972-1-git-send-email-sachin.kamat@linaro.org>
References: <1377157484-28972-1-git-send-email-sachin.kamat@linaro.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 Aug 2013 10:15:17 -0600
Message-ID: <CAErSpo65czTEzWHUGwq656smJ1Wz3R+n=QKwp+Ya8Jrfg3=VWA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ACPI / PNP: Fix incorrect placement of __initdata
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-kernel]

On Thu, Aug 22, 2013 at 1:44 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> __initdata should be placed between the variable name and equal
> sign for the variable to be placed in the intended section.

I'm not sure this is true, or maybe there's some sort of toolchain
issue.  On my system, I see the same section placement for
acpi_pnp_bus whether your patch is applied or not:

  $ objdump -t drivers/pnp/pnpacpi/core.o | grep acpi_pnp_bus
  ...
  0000000000000020 l     O .init.data 0000000000000038 acpi_pnp_bus
  $ cc -v
  Using built-in specs.
  COLLECT_GCC=/usr/bin/gcc-4.6.real
  COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.6/lto-wrapper
  Target: x86_64-linux-gnu
  Configured with: ../src/configure -v
--with-pkgversion='Ubuntu/Linaro 4.6.3-1ubuntu5'
--with-bugurl=file:///usr/share/doc/gcc-4.6/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-4.6 --enable-shared --enable-linker-build-id
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.6
--libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes
--enable-gnu-unique-object --enable-plugin --enable-objc-gc
--disable-werror --with-arch-32=i686 --with-tune=generic
--enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
  Thread model: posix
  gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)


If we *do* need a change like this, it looks like there are dozens or
hundreds of similar errors in other places, e.g.:

  Documentation/pinctrl.txt:static struct pinctrl_map __initdata pinmap[] = {
  arch/arm/common/mcpm_platsmp.c:static struct smp_operations
__initdata mcpm_smp_ops = {
  arch/tile/mm/init.c:static int __initdata ktext_hash = 1;  /* .text pages */

and they should all be changed at once, maybe with a Coccinelle script.

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pnp/pnpacpi/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index 34049b0..763e41d 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -358,7 +358,7 @@ static bool acpi_pnp_bus_match(struct device *dev)
>         return dev->bus == &pnp_bus_type;
>  }
>
> -static struct acpi_bus_type __initdata acpi_pnp_bus = {
> +static struct acpi_bus_type acpi_pnp_bus __initdata = {
>         .name        = "PNP",
>         .match       = acpi_pnp_bus_match,
>         .find_device = acpi_pnp_find_device,
> --
> 1.7.9.5
>
