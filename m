Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaK0D2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:28:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaK0D2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:28:37 -0500
Message-ID: <54769A54.3020304@oracle.com>
Date: Thu, 27 Nov 2014 11:28:20 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linda.knippers@hp.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net, dirk.j.brandewie@intel.com, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 1/2 v3] intel_pstate: skip this driver if Sun server has
 _PPC method
References: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com> <1416891578-14171-2-git-send-email-ethan.zhao@oracle.com> <547498BC.9020704@intel.com>
In-Reply-To: <547498BC.9020704@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk,

On 2014/11/25 22:57, Dirk Brandewie wrote:
> On 11/24/2014 08:59 PM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that 
>> works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has 
>> ACPI _PPC
>> enabled.
>>
>
> How about this patch? only compile tested.
>
> diff --git a/drivers/cpufreq/intel_pstate.c 
> b/drivers/cpufreq/intel_pstate.c
> index 3468387..db7b8b2 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -1025,15 +1025,46 @@ static bool intel_pstate_no_acpi_pss(void)
>      return true;
>  }
>
> +static bool intel_pstate_has_acpi_ppc(void)
> +{
> +    int i;
> +
> +    for_each_possible_cpu(i) {
> +        struct acpi_processor *pr = per_cpu(processors, i);
> +
> +        if (!pr)
> +            continue;
> +        if (acpi_has_method(pr->handle, "_PPC"))
> +            return true;
> +    }
> +    return false;
> +}
> +
> +enum {
> +    PSS,
> +    PCC,
> +};
> +
>  struct hw_vendor_info {
>      u16  valid;
>      char oem_id[ACPI_OEM_ID_SIZE];
>      char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];
> +    int  oem_pwr_table;
>  };
>
>  /* Hardware vendor-specific info that has its own power management 
> modes */
>  static struct hw_vendor_info vendor_info[] = {
> -    {1, "HP    ", "ProLiant"},
> +    {1, "HP    ", "ProLiant", PSS},
> +    {1, "ORACLE", "X4-2    ", PCC},
> +    {1, "ORACLE", "X4-2L   ", PCC},
> +    {1, "ORACLE", "X4-2B   ", PCC},
> +    {1, "ORACLE", "X3-2    ", PCC},
> +    {1, "ORACLE", "X3-2L   ", PCC},
> +    {1, "ORACLE", "X3-2B   ", PCC},
> +    {1, "ORACLE", "X4470M2 ", PCC},
> +    {1, "ORACLE", "X4270M3 ", PCC},
> +    {1, "ORACLE", "X4270M2 ", PCC},
> +    {1, "ORACLE", "X4170M2 ", PCC},
   But if someone would append line here and...
     +    {1, "VENDOR","XXXIX", PPC},
> {0, "", ""},
>  };
>
> @@ -1057,15 +1088,20 @@ static bool 
> intel_pstate_platform_pwr_mgmt_exists(void)
>
>      for (v_info = vendor_info; v_info->valid; v_info++) {
>          if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> -            !strncmp(hdr.oem_table_id, v_info->oem_table_id, 
> ACPI_OEM_TABLE_ID_SIZE) &&
> -            intel_pstate_no_acpi_pss())
> -            return true;
> +            !strncmp(hdr.oem_table_id, v_info->oem_table_id, 
> ACPI_OEM_TABLE_ID_SIZE))
> +            switch (v_info->oem_pwr_table) {
> +            case PSS:
> +                return intel_pstate_no_acpi_pss();
> +            case PCC:
> +                return intel_pstate_has_acpi_ppc();
   All good till append the force loading parameter here, looks ugly if 
someone would add one line to vendor_info[] as above.

                       return intel_pstate_has_acpi_ppc() & (!load_on_sun);

Any idea ?

Thanks,
Ethan


> + }
>      }
>
>      return false;
>  }
>  #else /* CONFIG_ACPI not enabled */
>  static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { 
> return false; }
> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>  #endif /* CONFIG_ACPI */
>
>  static int __init intel_pstate_init(void)
>
>

