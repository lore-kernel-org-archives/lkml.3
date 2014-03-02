Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaCBXXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:23:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55899 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753503AbaCBXXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:23:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len.Brown@intel.com, "alan@linux.intel.com" <alan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] ACPI/Sleep: pm_power_off need more sanity check to be installed
Date: Mon, 03 Mar 2014 00:38:58 +0100
Message-ID: <1519780.354CyqizXu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53128125.1080809@linux.intel.com>
References: <530D558D.6090607@linux.intel.com> <2386234.LOj9mo4PX0@vostro.rjw.lan> <53128125.1080809@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 02, 2014 08:53:57 AM Li, Aubrey wrote:
> On 2014/3/2 8:39, Rafael J. Wysocki wrote:
> > On Saturday, March 01, 2014 06:24:23 AM Li, Aubrey wrote:
> >>>> Do we still want to set this if the check below fails?  If so, then why?
> >>>
> >>> We know \_S5_ is valid. The fault is sleep registers, not S5 ACPI object
> >>
> >> Hi Rafael, do you still have any concern?
> > 
> > Well, I simply don't think we should say that it is "supported" if we aren't
> > going to do anything with it.
> > 
> 
> Make sense to me. Patch refined as below:
> 
> Sleep control and status registers need santity check as well before
> ACPI install acpi_power_off to pm_power_off hook. The checking code in
> acpi_enter_sleep_state() is too late, we should not allow a not-working
> pm_power_off function hooked.
> 
> Signed-off-by: Aubrey Li <aubrey.li@intel.com>

Queued up for 3.15 (with minor changes), thanks!

> 
> ---
>  drivers/acpi/sleep.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index b718806..0abfbb1 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -807,7 +807,12 @@ int __init acpi_sleep_init(void)
>  	acpi_sleep_hibernate_setup();
> 
>  	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
> -	if (ACPI_SUCCESS(status)) {
> +	/*
> +	 * Check both ACPI S5 object and ACPI sleep registers to
> +	 * install pm_power_off_prepare/pm_power_off hook
> +	 */
> +	if (ACPI_SUCCESS(status) && acpi_gbl_FADT.sleep_control.address &&
> +		acpi_gbl_FADT.sleep_status.address) {
>  		sleep_states[ACPI_STATE_S5] = 1;
>  		pm_power_off_prepare = acpi_power_off_prepare;
>  		pm_power_off = acpi_power_off;
> -- 1.7.10.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
