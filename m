Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaFQLvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:51:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62152 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753608AbaFQLvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:51:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josef Gajdusek <atx@atx.name>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/battery: fix wrong value of capacity_now reported by few battery types when fully charged (resend)
Date: Tue, 17 Jun 2014 14:09:22 +0200
Message-ID: <3564280.IKKn41NV0x@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140612145813.GB14085@dashie>
References: <20140612145813.GB14085@dashie>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 12, 2014 04:58:13 PM Josef Gajdusek wrote:
> It seems that some batteries (noticed on DELL JYPJ136) assume 
> capacity_now = design_capacity when fully charged. This causes 
> reported capacity to suddenly jump to >full_charge_capacity (and that 
> means capacity reported to userspace is >100% and incorrect) 
> values after 99%. This patch attempts to detect this bug and trims 
> capacity_now properly.
> 
> Signed-off-by: Josef Gajdusek <atx@atx.name>
> ---
> Oops, I forgot to sign the previous one.
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index e48fc98..3338dd5 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -532,6 +532,14 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
>  			" invalid.\n");
>  	}
>  
> +	/* When fully charged, some batteries wrongly report
> +	 * capacity_now = design_capacity instead of = full_charge_capacity
> +	 */
> +	if (battery->capacity_now == battery->design_capacity &&

Why don't you use the

	battery->capacity_now > battery->full_charge_capacity

check here?  That would be more robust, wouldn't it?

> +	    battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN)
> +		battery->capacity_now = battery->full_charge_capacity;
> +
> +
>  	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
>  	    && battery->capacity_now >= 0 && battery->capacity_now <= 100)
>  		battery->capacity_now = (battery->capacity_now *
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
