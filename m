Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaFQUrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:47:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62462 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933410AbaFQUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:47:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josef Gajdusek <atx@atx.name>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/battery: fix wrong value of capacity_now reported by few battery types when fully charged (resend)
Date: Tue, 17 Jun 2014 23:04:57 +0200
Message-ID: <2828453.ZgdXeiReHi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140617201359.GA6988@dashie>
References: <20140612145813.GB14085@dashie> <4697863.VH2Gj7n1J0@vostro.rjw.lan> <20140617201359.GA6988@dashie>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 17, 2014 10:14:00 PM Josef Gajdusek wrote:
> It seems that some batteries (noticed on DELL JYPJ136) assume 
> capacity_now = design_capacity when fully charged. This causes 
> reported capacity to suddenly jump to >full_charge_capacity (and that 
> means capacity reported to userspace is >100% and incorrect) 
> values after 99%. This patch attempts to detect this bug, notifies 
> userspace and trims the value to full_charge_capacity.
> 
> Signed-off-by: Josef Gajdusek <atx@atx.name>
> ---
> > 
> > But it still is necessary to check if battery->full_charge_capacity is
> > not ACPI_BATTERY_VALUE_UNKNOWN, isn't it?
> > 
> 
> Fixed, my mistake. When changing the checks, I somehow missed that the values 
> are not unsigned.
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index e48fc98..2e8f699 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -532,6 +532,19 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
>  			" invalid.\n");
>  	}
>  
> +	/* When fully charged, some batteries wrongly report
> +	 * capacity_now = design_capacity instead of = full_charge_capacity
> +	 */
> +	if (battery->capacity_now > battery->full_charge_capacity &&
> +		battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN) {
> +		battery->capacity_now = battery->full_charge_capacity;

Thinking more about the printk_once().  Perhaps it only needs to be printed
when battery->capacity_now != battery->design_capacity (it's a known issue
otherwise).

> +		printk_once(KERN_WARNING FW_BUG
> +			"battery: reported current charge level (%d) "
> +			"is higher than reported maximum charge level (%d)."
> +			"This is normal on some systems.\n",

Also I think that the line above doesn't add any real value. :-)

> +			battery->capacity_now, battery->full_charge_capacity);
> +	}
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
