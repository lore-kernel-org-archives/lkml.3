Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3JAJXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:23:44 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44601 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3JAJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:23:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130924131703.4834a055892285858338003c@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com>
	<20130924131703.4834a055892285858338003c@ops.dti.ne.jp>
Date: Tue, 1 Oct 2013 18:23:38 +0900
Message-ID: <CANqRtoQdwyjX8Mr8+NRah_F=yUM81xZmPQJ_1Z-xdzVqedbMGQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: shmobile: kzm9d-reference: Use common clock framework
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:17 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Use common clock framework version of clock
>  drivers/clk/shmobile/clk-emev2.c
> instead of sh-clkfwk version
>  arch/arm/mach-shmobile/clock-emev2.c
>
> kzm9d(without -reference) still uses sh-clkfwk version.
>
> Because two of that framework can not live in one kernel binary,
> there will be SoCs and Boards that can not be in one binary as
> multiplatform binary or so.
> For example, kzm9d and kzm9d-reference is now exclusive.
>
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  arch/arm/mach-shmobile/Kconfig                 | 1 +
>  arch/arm/mach-shmobile/board-kzm9d-reference.c | 5 ++---
>  2 files changed, 3 insertions(+), 3 deletions(-)

Hi Yoshii-san,

Thanks for your patch. I have some comments on this portion to try to
simplify things, please see below.

> diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> index 50bab8d..d20d4ce 100644
> --- a/arch/arm/mach-shmobile/Kconfig
> +++ b/arch/arm/mach-shmobile/Kconfig
> @@ -237,6 +237,7 @@ config MACH_KZM9D_REFERENCE
>         depends on ARCH_EMEV2
>         select REGULATOR_FIXED_VOLTAGE if REGULATOR
>         select USE_OF
> +       select COMMON_CLK

I don't think this hunk is needed. This is probably the
ARCH_SHMOBILE_MULTI case, and if so then ARCH_MULTIPLATFORM in
arch/arm/Kconfig already selects COMMON_CLK. And if it's the
ARCH_SHMOBILE case you're aiming at then I recommend you to only focus
on ARCH_SHMOBILE_MULTI instead.

> diff --git a/arch/arm/mach-shmobile/board-kzm9d-reference.c b/arch/arm/mach-shmobile/board-kzm9d-reference.c
> index 8f8bb2f..e0b8317 100644
> --- a/arch/arm/mach-shmobile/board-kzm9d-reference.c
> +++ b/arch/arm/mach-shmobile/board-kzm9d-reference.c
> @@ -20,15 +20,14 @@
>
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
> +#include <linux/clk-provider.h>
>  #include <mach/emev2.h>
>  #include <mach/common.h>
>  #include <asm/mach/arch.h>
>
>  static void __init kzm9d_add_standard_devices(void)
>  {
> -       if (!IS_ENABLED(CONFIG_COMMON_CLK))
> -               emev2_clock_init();
> -
> +       of_clk_init(NULL);
>         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  }

To keep on allowing build of board-kzm9d-reference.c for both
ARCH_SHMOBILE_MULTI and ARCH_SHMOBILE I recommend you to adjust your
code into something liket this instead:

@@ -18,6 +18,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */

+#include <linux/clk-provider.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
 #include <mach/emev2.h>
@@ -26,9 +27,11 @@

 static void __init kzm9d_add_standard_devices(void)
 {
-       if (!IS_ENABLED(CONFIG_COMMON_CLK))
-               emev2_clock_init();
-
+#ifdef CONFIG_COMMON_CLK
+       of_clk_init(NULL);
+#else
+       emev2_clock_init();
+#endif
        of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }

Cheers,

/ magnus
