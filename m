Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332Ab3BNW40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:56:26 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42164 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277Ab3BNW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <1360867132-13004-1-git-send-email-dirk.brandewie@gmail.com>
References: <6075901.uWCJMxDDFf@vostro.rjw.lan>
	<1360867132-13004-1-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 14 Feb 2013 14:56:23 -0800
X-Google-Sender-Auth: IZ0odAfHIBTcvcHZ8-iTBH5soL0
Message-ID: <CAE9FiQWSoXafuzkpegZ_DV9GA23YtTVgXMjzkqqpQWEDOXqJaA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add kernel command line option
 disable intel_pstate.
From: Yinghai Lu <yinghai@kernel.org>
To: dirk.brandewie@gmail.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:38 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> When intel_pstate is configured into the kernel it will become the
> perferred scaling driver for processors that is supports.  Allow the
> user to override this by adding:
>    intel_pstate=disable
> on the kernel command line.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  drivers/cpufreq/intel_pstate.c      |   16 ++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6c72381..41c5d9e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1131,6 +1131,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         0       disables intel_idle and fall back on acpi_idle.
>                         1 to 6  specify maximum depth of C-state.
>
> +       intel_pstate=  [X86]
> +                      disable
> +                        Do not enable intel_pstate as the default
> +                        scaling driver for the supported processors
> +
>         intremap=       [X86-64, Intel-IOMMU]
>                         on      enable Interrupt Remapping (default)
>                         off     disable Interrupt Remapping
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index e879963..9cbb733 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -773,11 +773,16 @@ static void intel_pstate_exit(void)
>  }
>  module_exit(intel_pstate_exit);
>
> +static int no_load;

Looks like you can use __initdata with it.

Thanks

Yinghai


> +
>  static int __init intel_pstate_init(void)
>  {
>         int rc = 0;
>         const struct x86_cpu_id *id;
>
> +       if (no_load)
> +               return -ENODEV;
> +
>         id = x86_match_cpu(intel_pstate_cpu_ids);
>         if (!id)
>                 return -ENODEV;
> @@ -802,6 +807,17 @@ out:
>  }
>  device_initcall(intel_pstate_init);
>
> +static int __init intel_pstate_setup(char *str)
> +{
> +       if (!str)
> +               return -EINVAL;
> +
> +       if (!strcmp(str, "disable"))
> +               no_load = 1;
> +       return 0;
> +}
> +early_param("intel_pstate", intel_pstate_setup);
> +
>  MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
>  MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
>  MODULE_LICENSE("GPL");
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
