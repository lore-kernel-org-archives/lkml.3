Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaCNFjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:39:19 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53291 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaCNFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <1394576402-2910-4-git-send-email-matthew.garrett@nebula.com>
References: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
	<1394576402-2910-4-git-send-email-matthew.garrett@nebula.com>
Date: Fri, 14 Mar 2014 13:39:17 +0800
Message-ID: <CAOLK0pwEzWNHT+yyqKiFMc05iVjTYk4wjLDOb=g=kOm7zttT=A@mail.gmail.com>
Subject: Re: [PATCH 3/3] ACPI: Don't re-select SBS battery if it's already selected
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-12 6:20 GMT+08:00 Matthew Garrett <matthew.garrett@nebula.com>:
> The existing SBS code explicitly sets the selected battery in the SBS
> manager regardless of whether the battery in question is already selected.
> This causes bus timeouts on Apple hardware. Check for this case and avoid
> it.
>

Hi Matthew:
           This patch is to avoid a redundant battery select operation when
the battery is selected. But the symptom "bus timeouts" is a bus transaction
issue, right?  Will this happen during other SBS write/read operations? Do we
need to increase the wait time of SMBUS transaction?

> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/acpi/sbs.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
> index dbd4849..c386505 100644
> --- a/drivers/acpi/sbs.c
> +++ b/drivers/acpi/sbs.c
> @@ -470,17 +470,25 @@ static struct device_attribute alarm_attr = {
>  static int acpi_battery_read(struct acpi_battery *battery)
>  {
>         int result = 0, saved_present = battery->present;
> -       u16 state;
> +       u16 state, selected, desired;
>
>         if (battery->sbs->manager_present) {
>                 result = acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
>                                 ACPI_SBS_MANAGER, 0x01, (u8 *)&state);
>                 if (!result)
>                         battery->present = state & (1 << battery->id);
> -               state &= 0x0fff;
> -               state |= 1 << (battery->id + 12);
> -               acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
> -                                 ACPI_SBS_MANAGER, 0x01, (u8 *)&state, 2);
> +               /*
> +                * Don't switch battery if the correct one is already selected
> +                */
> +               selected = state & 0xf000;
> +               desired = 1 << (battery->id + 12);
> +               if (selected != desired) {
> +                       state &= 0x0fff;
> +                       state |= desired;
> +                       acpi_smbus_write(battery->sbs->hc, SMBUS_WRITE_WORD,
> +                                        ACPI_SBS_MANAGER, 0x01,
> +                                        (u8 *)&state, 2);
> +               }
>         } else if (battery->id == 0)
>                 battery->present = 1;
>         if (result || !battery->present)
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
