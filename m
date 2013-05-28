Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab3E1RRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:17:38 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:51617
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934735Ab3E1RRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:17:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dI9371I1102I1432Id799hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MNIQP4-01-60C-02
X-M-MSG: 
Message-ID: <51A4E6A8.7080004@amd.com>
Date: Tue, 28 May 2013 12:17:28 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2 V3] perf/x86/amd: AMD IOMMU PC PERF uncore PMU implementation
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com> <1368819813-6481-3-git-send-email-suravee.suthikulpanit@amd.com> <20130528121850.GC2575@8bytes.org>
In-Reply-To: <20130528121850.GC2575@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/2013 7:18 AM, Joerg Roedel wrote:
> On Fri, May 17, 2013 at 02:43:32PM -0500, Suthikulpanit, Suravee wrote:
>> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
>> index b0684e4..fcbd3b8 100644
>> --- a/arch/x86/kernel/cpu/Makefile
>> +++ b/arch/x86/kernel/cpu/Makefile
>> @@ -30,7 +30,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
>>   obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
>>   
>>   ifdef CONFIG_PERF_EVENTS
>> -obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
>> +obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o perf_event_amd_iommu.o
> This should also depend on CONFIG_AMD_IOMMU. If no IOMMU driver is
> compiled in it doesn't make sense to have that PMU.
I will take care of this.
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	/* integrate with iommu base devid (0000), assume one iommu */
> +	perf_iommu->max_banks =
> +		amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID);
> +	perf_iommu->max_counters =
> +		amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID);
> +
> +	/* update the hw_perf_event struct with the iommu config data */
> +	hwc->config = config;
> +	hwc->extra_reg.config = config1;
> +
> +	return 0;
> +}
> That implementation is very basic. Any reason for not using the event
> reporting mechanism of the IOMMU? You could implement a nice perf
> iommutop or something to see which devices do the most transactions or
> something like that.
>
>
> 	Joerg
This patch is adding perf system-wide counting mode support which is 
used by "perf stat" tool.  We are not implementing the sampling mode 
since MSI interrupt of the IOMMU cannot be used for current perf 
sampling tools (e.g. perf record or top) since the IOMMU counters are 
not core-specific.   The current "perf record" and "perf top" needs to 
attribute each sample to a particular core/pid which would allow the 
tools to figure out the instruction pointer and map the sample to a 
paticular module.

If I understand correctly, when you mentioned "perf iommutop", you want 
a new perf user-space tool which will show real-time IOMMU events per 
IOMMU HW and/or device?

Suravee

