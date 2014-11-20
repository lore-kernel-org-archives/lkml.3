Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaKTAwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:52:07 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54561 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaKTAwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:52:04 -0500
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com> <546CFBEE.6090103@hp.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <546CFBEE.6090103@hp.com>
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-Id: <901EE838-D37C-462D-B6FD-E94A2F7AE4F2@gmail.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "brian.maly@oracle.com" <brian.maly@oracle.com>
X-Mailer: iPad Mail (12B410)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI _PPC method
Date: Thu, 20 Nov 2014 08:52:02 +0800
To: Linda Knippers <linda.knippers@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda，

> 在 2014年11月20日，04:22，Linda Knippers <linda.knippers@hp.com> 写道：
> 
>> On 11/18/2014 3:37 AM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
>> enabled.
>> 
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> ---
>> drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>> 1 file changed, 20 insertions(+)
>> 
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 27bb6d3..5498eb0 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>    return true;
>> }
>> 
>> +static bool intel_pstate_has_acpi_ppc(void)
>> +{
>> +    int i;
>> +
>> +    for_each_possible_cpu(i) {
>> +        struct acpi_processor *pr = per_cpu(processors, i);
>> +
>> +        if (!pr)
>> +            continue;
>> +        if (acpi_has_method(pr->handle, "_PPC"))
>> +            return true;
>> +    }
>> +    return false;
>> +}
>> +
>> struct hw_vendor_info {
>>    u16  valid;
>>    char oem_id[ACPI_OEM_ID_SIZE];
>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>> /* Hardware vendor-specific info that has its own power management modes */
>> static struct hw_vendor_info vendor_info[] = {
>>    {1, "HP    ", "ProLiant"},
>> +    {1, "ORACLE", ""},
>>    {0, "", ""},
>> };
>> 
>> @@ -969,12 +985,16 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>            !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
>>            intel_pstate_no_acpi_pss())
>>            return true;
>> +        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>> +            intel_pstate_has_acpi_ppc())
> 
> We need try this on a few platforms to make sure this patch doesn't break the
> HP platforms that may or may not need this driver, depending on the BIOS settings.
> 
> I don't suppose you tested on a ProLiant too?
I  am very glad you could catch this though I missed to CC you.
The code only touch oem_id 'ORACLE' platform, wouldn't break HP's.
But it is good you could test on ProLiant.(not find one around yet)

Thanks,
Ethan

> 
> -- ljk
> 
>> +            return true;
>>    }
>> 
>>    return false;
>> }
>> #else /* CONFIG_ACPI not enabled */
>> static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>> #endif /* CONFIG_ACPI */
>> 
>> static int __init intel_pstate_init(void)
>> 
> 
