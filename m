Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3KTUvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:51:00 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:48393 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3KTUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
	<1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 20 Nov 2013 14:50:53 -0600
Message-ID: <CAL_Jsq+ri0rVg-urU74cE__tor7WSu_0xexUDzQHc+o=Qo8E3A@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt: Handle passed/built-in DT selection in early_init_dt_scan()
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 5:12 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Let early_init_dt_scan() fall-back to the built-in DT if no DT was passed,
> or if it's invalid, so architectures don't have to duplicate this logic.
>
> Suggested-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Looks good to me. I can take this series if you want to send me a pull
request. In any case, for the series:

Reviewed-by: Rob Herring <rob.herring@calxeda.com>

Rob

>  drivers/of/fdt.c       |   24 +++++++++++++++++-------
>  include/linux/of_fdt.h |    1 +
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 2fa024b97c43..a797cd43bc8b 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -868,18 +868,28 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
>
>  bool __init early_init_dt_scan(void *params)
>  {
> -       if (!params)
> -               return false;
> -
>         /* Setup flat device-tree pointer */
>         initial_boot_params = params;
>
> -       /* check device tree validity */
> -       if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
> -               initial_boot_params = NULL;
> -               return false;
> +       /* check passed device tree validity */
> +       if (initial_boot_params &&
> +           be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
> +               pr_info("FDT at %p\n", initial_boot_params);
> +               goto found;
> +       }
> +
> +       /* check built-in device tree validity */
> +       initial_boot_params = &__dtb_start;
> +       if (__dtb_end != (void *)&__dtb_start &&
> +           be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
> +               pr_info("Compiled-in FDT at %p\n", initial_boot_params);
> +               goto found;
>         }
>
> +       initial_boot_params = NULL;
> +       return false;
> +
> +found:
>         /* Retrieve various information from the /chosen node */
>         of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
>
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index aabc49f3e403..6c4a60454854 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -59,6 +59,7 @@ struct boot_param_header {
>
>  /* For kernels with a built-in device tree */
>  extern struct boot_param_header __dtb_start;
> +extern char __dtb_end[];
>
>  #if defined(CONFIG_OF_FLATTREE)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
