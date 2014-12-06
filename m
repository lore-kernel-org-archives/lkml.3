Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaLFCQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:16:47 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56221 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaLFCQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:16:45 -0500
References: <1417772453-22483-1-git-send-email-ethan.zhao@oracle.com> <5481D8B9.2030603@hp.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5481D8B9.2030603@hp.com>
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-Id: <CEF8DE9B-262F-4EED-B982-9CD52617EEC5@gmail.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "alexey.kodanev@oracle.com" <alexey.kodanev@oracle.com>
X-Mailer: iPad Mail (12B435)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH 2/2 V8] intel_pstate: add kernel parameter to force loading.
Date: Sat, 6 Dec 2014 10:16:37 +0800
To: Linda Knippers <linda.knippers@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda，

> 在 2014年12月6日，00:09，Linda Knippers <linda.knippers@hp.com> 写道：
> 
>> On 12/5/2014 4:40 AM, Ethan Zhao wrote:
>> To force loading on Oracle Sun X86 servers, provide one kernel command line
>> parameter
>> 
>>  intel_pstate = force
>> 
>> For those who be aware of the risk of no power capping capabily working and
>> try to get better performance with this driver.
>> 
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> Tested-by: Alexey Kodanev <alexey.kodanev@oracle.com>
>> ---
>> v2: change to hardware vendor specific naming parameter.
>> v4: refine code and doc.
>> v5&v6: fix a typo in doc.
>> v7: change enum PCC to PPC.
>> v8: change the name of kernel command line parameter to generic one.
>> 
>> Documentation/kernel-parameters.txt | 5 +++++
>> drivers/cpufreq/intel_pstate.c      | 6 +++++-
>> 2 files changed, 10 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 479f332..7d0983e 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1446,6 +1446,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>               disable
>>                 Do not enable intel_pstate as the default
>>                 scaling driver for the supported processors
>> +               force
>> +             Enable intel_pstate on systems where it may cause problems to
>> +             happen due to conflicts with platform firmware attempting to
>> +             drive P-states by itself in certain situations (for thermal 
>> +             control or power capping in general or other purposes).
> 
> I suggest something like:
>            Enable intel_pstate on systems that prohibit it by
>            default in favor of acpi-cpufreq.  Forcing the
>            intel_pstate driver instead of acpi-cpufreq may disable
>            platform features, such as thermal controls and power
>            capping, that rely on ACPI p-state information being
                                                         P-States 
>             Used by the OS and therefore should be used with care.
               Indicated to OSPM                                                   caution 
>            This option does not work with processors that aren't
>            supported by the intel_pstate driver or on platforms
>            that use pcc-cpufreq instead of acpi-cpufreq.
> 
> Maybe this is too specific but I believe it is accurate.  Comments?
> 

Looks better to me, except some words commented. 

Thanks,
Ethan
> -- ljk
> 
>> 
>>    intremap=    [X86-64, Intel-IOMMU]
>>            on    enable Interrupt Remapping (default)
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 1bb62ca..2654e13 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -866,6 +866,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>> };
>> 
>> static int __initdata no_load;
>> +static unsigned int  force_load;
>> 
>> static int intel_pstate_msrs_not_valid(void)
>> {
>> @@ -1003,7 +1004,8 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>            case PSS:
>>                return intel_pstate_no_acpi_pss();
>>            case PPC:
>> -                return intel_pstate_has_acpi_ppc();
>> +                return intel_pstate_has_acpi_ppc() &&
>> +                    (!force_load);
>>            }
>>    }
>> 
>> @@ -1078,6 +1080,8 @@ static int __init intel_pstate_setup(char *str)
>> 
>>    if (!strcmp(str, "disable"))
>>        no_load = 1;
>> +    if (!strcmp(str, "force"))
>> +        force_load = 1;
>>    return 0;
>> }
>> early_param("intel_pstate", intel_pstate_setup);
> 
