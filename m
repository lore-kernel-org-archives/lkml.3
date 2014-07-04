Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaGDCPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:15:55 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58626 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDCPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <1404344109-30805-1-git-send-email-colin.king@canonical.com>
References: <1404344109-30805-1-git-send-email-colin.king@canonical.com>
Date: Fri, 4 Jul 2014 10:15:52 +0800
Message-ID: <CAOLK0pxQ=iBXLDLQ8hGkeF0oLHHSs+qTa93ixqWhUh2COq-MqQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI / EC: Free saved_ec on error exit path
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Colin King <colin.king@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-03 7:35 GMT+08:00 Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> Smatch detected two memory leaks on saved_ec:
>
> drivers/acpi/ec.c:1070 acpi_ec_ecdt_probe() warn: possible
>   memory leak of 'saved_ec'
> drivers/acpi/ec.c:1109 acpi_ec_ecdt_probe() warn: possible
>   memory leak of 'saved_ec'
>
> Free saved_ec on these two error exit paths to stop the memory
> leak.  Note that saved_ec maybe null, but kfree on null is allowed.
>

Acked-by: Lan Tianyu <tianyu.lan@intel.com>

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/acpi/ec.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index ad11ba4..9800f50 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -1066,8 +1066,10 @@ int __init acpi_ec_ecdt_probe(void)
>         /* fall through */
>         }
>
> -       if (EC_FLAGS_SKIP_DSDT_SCAN)
> +       if (EC_FLAGS_SKIP_DSDT_SCAN) {
> +               kfree(saved_ec);
>                 return -ENODEV;
> +       }
>
>         /* This workaround is needed only on some broken machines,
>          * which require early EC, but fail to provide ECDT */
> @@ -1105,6 +1107,7 @@ install:
>         }
>  error:
>         kfree(boot_ec);
> +       kfree(saved_ec);
>         boot_ec = NULL;
>         return -ENODEV;
>  }
> --
> 2.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
