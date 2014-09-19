Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaISOSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:18:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56710 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaISOSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:18:37 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com>
References: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com>
Date: Fri, 19 Sep 2014 16:18:36 +0200
Message-ID: <CABxcv=m4CX6ZiWxq0kNZ-3iLg9J8pqguhcr5G7Ud0+8N-8RDjQ@mail.gmail.com>
Subject: Re: [PATCH v4] mfd: syscon: Decouple syscon interface from platform devices
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, vikas.sajjan@samsung.com,
        sunil joshi <joshi@samsung.com>, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, b29396@freescale.com,
        Li.Xiubo@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pankaj,

On Fri, Sep 19, 2014 at 3:06 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain use cases it is desirable to make a device used with another
> driver a syscon interface provider.
>
> For example, certain SoCs (e.g. Exynos) contain system controller
> blocks which perform various functions such as power domain control,
> CPU power management, low power mode control, but in addition contain
> certain IP integration glue, such as various signal masks,
> coprocessor power control, etc. In such case, there is a need to have
> a dedicated driver for such system controller but also share registers
> with other drivers. The latter is where the syscon interface is helpful.
>
> In case of DT based platforms, this patch decouples syscon object from
> syscon platform driver, and allows to create syscon objects first time
> when it is required by calling of syscon_regmap_lookup_by APIs and keep
> a list of such syscon objects along with syscon provider device_nodes
> and regmap handles.
>
> For non-DT based platforms, this patch keeps syscon platform driver
> structure where is can be probed and such non-DT based drivers can use
> syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> we can completly remove platform driver of syscon, and keep only helper
> functions to get regmap handles.
>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> Changes since v3:
>  - Addressed Arnd's comment for v2.
>  - Updated of_syscon_register for adding dev pointer in regmap_init_mmio.
>  - For early users created dummy platform device.
>
> Changes since v2:
>  - Added back platform device support from syscon, with one change that
>    syscon will not be probed for DT based platform.
>  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
>    users of syscon will not be broken.
>  - Removed unwanted change in syscon.h.
>  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
>    Arnd Bergmann.
>  - Added Tested-by of Vivek Gautam for testing on Exynos platform.
>
> Changes since v1:
>  - Removed of_syscon_unregister function.
>  - Modified of_syscon_register function and it will be used by syscon.c
>    to create syscon objects whenever required.
>  - Removed platform device support from syscon.
>  - Removed syscon_regmap_lookup_by_pdevname API support.
>  - As there are significant changes w.r.t patchset v1, I am taking over
>    author for this patchset from Tomasz Figa.
>
> [1]: https://lkml.org/lkml/2014/9/2/299
>  drivers/mfd/syscon.c |  102 ++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 79 insertions(+), 23 deletions(-)
>

I tested this patch on an Exynos5420 Peach Pit Chromebook and I see
that of_syscon_register() is called for the PMU system controller with
compatible string "samsung,exynos5420-pmu", "syscon" which does not
have a dedicated platform driver, so:

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
