Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaCRNnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:43:21 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51006 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <1395144178-3729-1-git-send-email-broonie@kernel.org>
References: <1395144178-3729-1-git-send-email-broonie@kernel.org>
Date: Tue, 18 Mar 2014 14:43:18 +0100
X-Google-Sender-Auth: DdxTYYuyCuTsOBhAzmFcML0hoGw
Message-ID: <CAAsK9AG7-12Y7RRdmmHDdGYqNh+qBuciD5YaptXZ_+rkvEGNjg@mail.gmail.com>
Subject: Re: [PATCH] regmap: Ensure regmap_register_patch() is compatible with fast_io
From: Levente Kurusa <levex@linux.com>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Just a single, mini-comment.


2014-03-18 13:02 GMT+01:00 Mark Brown <broonie@kernel.org>:
> From: Mark Brown <broonie@linaro.org>
>
> With fast_io we use mutexes to lock the I/O operations so we would need
> to do GFP_ATOMIC allocations if we wanted to do allocations inside the
> lock as we do currently. Since it is unlikely that we will want to register
> a patch outside of init where concurrency shouldn't be an issue move the
> allocation of the patch data outside the lock.
>
> Reported-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/base/regmap/regmap.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 554119535a64..2d7d55b3bedb 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -2396,6 +2396,9 @@ EXPORT_SYMBOL_GPL(regmap_async_complete);
>   * apply them immediately.  Typically this is used to apply
>   * corrections to be applied to the device defaults on startup, such
>   * as the updates some vendors provide to undocumented registers.
> + *
> + * The caller must ensure that this function cannot be called
> + * concurrently with either itself or regcache_sync().
>   */
>  int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
>                           int num_regs)
> @@ -2408,6 +2411,17 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
>             num_regs))
>                 return 0;
>
> +       p = krealloc(map->patch,
> +                    sizeof(struct reg_default) * (map->patch_regs + num_regs),
> +                    GFP_KERNEL);
> +       if (p) {
> +               memcpy(p + map->patch_regs, regs, num_regs * sizeof(*regs));
> +               map->patch = p;
> +               map->patch_regs += num_regs;
> +       } else {
> +               return -ENOMEM;
> +       }
> +

I think that is not checkpatch-safe :-)

> [...]

--
Regards,
Levente Kurusa
