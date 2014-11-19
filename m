Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaKSUWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:22:16 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:7472 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaKSUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:22:15 -0500
Message-ID: <546CFBEE.6090103@hp.com>
Date: Wed, 19 Nov 2014 15:22:06 -0500
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, dirk.j.brandewie@intel.com,
        viresh.kumar@linaro.org, rjw@rjwysocki.net, corbet@lwn.net
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI
 _PPC method
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 3:37 AM, Ethan Zhao wrote:
> Oracle Sun X86 servers have dynamic power capping capability that works via
> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
> enabled.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 27bb6d3..5498eb0 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>  	return true;
>  }
>  
> +static bool intel_pstate_has_acpi_ppc(void)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		struct acpi_processor *pr = per_cpu(processors, i);
> +
> +		if (!pr)
> +			continue;
> +		if (acpi_has_method(pr->handle, "_PPC"))
> +			return true;
> +	}
> +	return false;
> +}
> +
>  struct hw_vendor_info {
>  	u16  valid;
>  	char oem_id[ACPI_OEM_ID_SIZE];
> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>  /* Hardware vendor-specific info that has its own power management modes */
>  static struct hw_vendor_info vendor_info[] = {
>  	{1, "HP    ", "ProLiant"},
> +	{1, "ORACLE", ""},
>  	{0, "", ""},
>  };
>  
> @@ -969,12 +985,16 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>  		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
>  		    intel_pstate_no_acpi_pss())
>  			return true;
> +		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> +			intel_pstate_has_acpi_ppc())

We need try this on a few platforms to make sure this patch doesn't break the
HP platforms that may or may not need this driver, depending on the BIOS settings.

I don't suppose you tested on a ProLiant too?

-- ljk

> +			return true;
>  	}
>  
>  	return false;
>  }
>  #else /* CONFIG_ACPI not enabled */
>  static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>  #endif /* CONFIG_ACPI */
>  
>  static int __init intel_pstate_init(void)
> 

