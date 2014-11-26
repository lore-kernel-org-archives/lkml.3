Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaKZAPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:15:38 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41194 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaKZAPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:15:36 -0500
References: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com> <1416891578-14171-2-git-send-email-ethan.zhao@oracle.com> <547498BC.9020704@intel.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <547498BC.9020704@intel.com>
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-Id: <51EBF1F9-C972-4A40-BC44-944E4DD71CDD@gmail.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "linda.knippers@hp.com" <linda.knippers@hp.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (12B435)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH 1/2 v3] intel_pstate: skip this driver if Sun server has _PPC method
Date: Wed, 26 Nov 2014 08:15:32 +0800
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk,

> 在 2014年11月25日，22:57，Dirk Brandewie <dirk.brandewie@gmail.com> 写道：
> 
>> On 11/24/2014 08:59 PM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
>> enabled.
> How about this patch? only compile tested.
> 
Looks good to me, and obviously my one is much simpler :)
I will test it and give you feed back.

Thanks,
Ethan

> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 3468387..db7b8b2 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -1025,15 +1025,46 @@ static bool intel_pstate_no_acpi_pss(void)
>    return true;
> }
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
> struct hw_vendor_info {
>    u16  valid;
>    char oem_id[ACPI_OEM_ID_SIZE];
>    char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];
> +    int  oem_pwr_table;
> };
> 
> /* Hardware vendor-specific info that has its own power management modes */
> static struct hw_vendor_info vendor_info[] = {
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
>    {0, "", ""},
> };
> 
> @@ -1057,15 +1088,20 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
> 
>    for (v_info = vendor_info; v_info->valid; v_info++) {
>        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> -            !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
> -            intel_pstate_no_acpi_pss())
> -            return true;
> +            !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE))
> +            switch (v_info->oem_pwr_table) {
> +            case PSS:
> +                return intel_pstate_no_acpi_pss();
> +            case PCC:
> +                return intel_pstate_has_acpi_ppc();
> +            }
>    }
> 
>    return false;
> }
> #else /* CONFIG_ACPI not enabled */
> static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
> #endif /* CONFIG_ACPI */
> 
> static int __init intel_pstate_init(void)
> 
> 
