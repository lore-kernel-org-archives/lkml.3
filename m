Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbbATQsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:48:21 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58300 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbATQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:48:17 -0500
MIME-Version: 1.0
In-Reply-To: <1421623526-20555-3-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1421623526-20555-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1421623526-20555-3-git-send-email-vivien.didelot@savoirfairelinux.com>
Date: Tue, 20 Jan 2015 16:48:15 +0000
Message-ID: <CAHR064jkFMd3FWxGvOrE0FfXzLHoQSb9LU8Mi_AZk-CST01Sqw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] asus-laptop: cleanup is_visible
From: Corentin Chary <corentin.chary@gmail.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>, kernel@savoirfairelinux.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:25 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:
>
> Use the attribute indexes and concise the if statements.

Why ? I really don't see that as an improvement.

> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  drivers/platform/x86/asus-laptop.c | 98 ++++++++++++++++----------------------
>  1 file changed, 40 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 46b2746..b576929 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -1580,77 +1580,59 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
>  }
>
>  static struct attribute *asus_attributes[] = {
> -       &dev_attr_infos.attr,
> -       &dev_attr_wlan.attr,
> -       &dev_attr_bluetooth.attr,
> -       &dev_attr_wimax.attr,
> -       &dev_attr_wwan.attr,
> -       &dev_attr_display.attr,
> -       &dev_attr_ledd.attr,
> -       &dev_attr_ls_value.attr,
> -       &dev_attr_ls_level.attr,
> -       &dev_attr_ls_switch.attr,
> -       &dev_attr_gps.attr,
> +       &dev_attr_infos.attr,           /* 0 */
> +       &dev_attr_wlan.attr,            /* 1 */
> +       &dev_attr_bluetooth.attr,       /* 2 */
> +       &dev_attr_wimax.attr,           /* 3 */
> +       &dev_attr_wwan.attr,            /* 4 */
> +       &dev_attr_display.attr,         /* 5 */
> +       &dev_attr_ledd.attr,            /* 6 */
> +       &dev_attr_ls_value.attr,        /* 7 */
> +       &dev_attr_ls_level.attr,        /* 8 */
> +       &dev_attr_ls_switch.attr,       /* 9 */
> +       &dev_attr_gps.attr,             /* 10 */
>         NULL
>  };
>
>  static umode_t asus_sysfs_is_visible(struct kobject *kobj,
> -                                   struct attribute *attr,
> -                                   int idx)
> +                                    struct attribute *attr, int index)
>  {
>         struct device *dev = container_of(kobj, struct device, kobj);
>         struct platform_device *pdev = to_platform_device(dev);
>         struct asus_laptop *asus = platform_get_drvdata(pdev);
>         acpi_handle handle = asus->handle;
> -       bool supported;
> -
> -       if (asus->is_pega_lucid) {
> +       bool ret = true;
> +
> +       if (index == 1) {
> +               ret = !acpi_check_handle(handle, METHOD_WLAN, NULL);
> +       } else if (index == 2) {
> +               ret = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
> +       } else if (index == 3) {
> +               ret = !acpi_check_handle(handle, METHOD_WIMAX, NULL);
> +       } else if (index == 4) {
> +               ret = !acpi_check_handle(handle, METHOD_WWAN, NULL);
> +       } else if (index == 5) {
> +               ret = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
> +       } else if (index == 6) {
> +               ret = !acpi_check_handle(handle, METHOD_LEDD, NULL);
> +       } else if (index == 7) {
> +               ret = asus->is_pega_lucid;
> +       } else if (index == 8) {
>                 /* no ls_level interface on the Lucid */
> -               if (attr == &dev_attr_ls_switch.attr)
> -                       supported = true;
> -               else if (attr == &dev_attr_ls_level.attr)
> -                       supported = false;
> -               else
> -                       goto normal;
> -
> -               return supported ? attr->mode : 0;
> -       }
> -
> -normal:
> -       if (attr == &dev_attr_wlan.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_WLAN, NULL);
> -
> -       } else if (attr == &dev_attr_bluetooth.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
> -
> -       } else if (attr == &dev_attr_display.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
> -
> -       } else if (attr == &dev_attr_wimax.attr) {
> -               supported =
> -                       !acpi_check_handle(asus->handle, METHOD_WIMAX, NULL);
> -
> -       } else if (attr == &dev_attr_wwan.attr) {
> -               supported = !acpi_check_handle(asus->handle, METHOD_WWAN, NULL);
> -
> -       } else if (attr == &dev_attr_ledd.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_LEDD, NULL);
> -
> -       } else if (attr == &dev_attr_ls_switch.attr ||
> -                  attr == &dev_attr_ls_level.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
> +               ret = !asus->is_pega_lucid &&
> +                       !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
>                         !acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
> -       } else if (attr == &dev_attr_ls_value.attr) {
> -               supported = asus->is_pega_lucid;
> -       } else if (attr == &dev_attr_gps.attr) {
> -               supported = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
> -                           !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
> -                           !acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
> -       } else {
> -               supported = true;
> +       } else if (index == 9) {
> +               ret = asus->is_pega_lucid ||
> +                       (!acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
> +                        !acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL));
> +       } else if (index == 10) {
> +               ret = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
> +                       !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
> +                       !acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
>         }
>
> -       return supported ? attr->mode : 0;
> +       return ret ? attr->mode : 0;
>  }
>
>
> --
> 2.2.2
>



-- 
Corentin Chary
http://xf.iksaif.net
