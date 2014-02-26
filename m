Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaBZXfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:35:07 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55108 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752826AbaBZXfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:35:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len.Brown@intel.com, "alan@linux.intel.com" <alan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] ACPI/Sleep: pm_power_off need more sanity check to be installed
Date: Thu, 27 Feb 2014 00:50:05 +0100
Message-ID: <1853937.5e0COHhnpP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <530D558D.6090607@linux.intel.com>
References: <530D558D.6090607@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 10:46:37 AM Li, Aubrey wrote:
> Sleep control and status registers need santity check before ACPI
> install acpi_power_off to pm_power_off hook. The checking code in
> acpi_enter_sleep_state() is too late, we should not allow a not-working
> pm_power_off function hooked.
> 
> Signed-off-by: Aubrey Li <aubrey.li@intel.com>
> ---
>  drivers/acpi/sleep.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index b718806..0284d22 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -809,8 +809,11 @@ int __init acpi_sleep_init(void)
>  	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
>  	if (ACPI_SUCCESS(status)) {
>  		sleep_states[ACPI_STATE_S5] = 1;

Do we still want to set this if the check below fails?  If so, then why?

> -		pm_power_off_prepare = acpi_power_off_prepare;
> -		pm_power_off = acpi_power_off;
> +		if (acpi_gbl_FADT.sleep_control.address &&
> +			acpi_gbl_FADT.sleep_status.address) {
> +			pm_power_off_prepare = acpi_power_off_prepare;
> +			pm_power_off = acpi_power_off;
> +		}
>  	}
> 
>  	supported[0] = 0;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
