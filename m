Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3KNKnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:43:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42418 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3KNKm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:42:59 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5284A920.8090404@jp.fujitsu.com>
Date: Thu, 14 Nov 2013 19:42:40 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v5 2/3] x86, apic: Add disable_cpu_apicid kernel parameter
References: <20131112094952.4902.72689.stgit@localhost6.localdomain6> <20131112095158.4902.75396.stgit@localhost6.localdomain6> <20131112104423.GB12849@pd.tnic>
In-Reply-To: <20131112104423.GB12849@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/12 19:44), Borislav Petkov wrote:
> On Tue, Nov 12, 2013 at 06:51:58PM +0900, HATAYAMA Daisuke wrote:
>> Add disable_cpu_apicid kernel parameter. To use this kernel parameter,
>> specify an initial APIC ID of the corresponding CPU you want to
>> disable.
>>
>> This is mostly used for the kdump 2nd kernel to disable BSP to wake up
>> multiple CPUs without causing system reset or hang due to sending INIT
>> from AP to BSP.
>>
>> Kdump users first figure out initial APIC ID of the BSP, CPU0 in the
>> 1st kernel, for example from /proc/cpuinfo and then set up this kernel
>> parameter for the 2nd kernel using the obtained APIC ID.
>>
>> However, doing this procedure at each boot time manually is awkward,
>> which should be automatically done by user-land service scripts, for
>> example, kexec-tools on fedora/RHEL distributions.
>>
>> This design is more flexible than disabling BSP in kernel boot time
>> automatically in that in kernel boot time we have no choice but
>> referring to ACPI/MP table to obtain initial APIC ID for BSP, meaning
>> that the method is not applicable to the systems without such BIOS
>> tables.
>>
>> One assumption behind this design is that users get initial APIC ID of
>> the BSP in still healthy state and so BSP is uniquely kept in
>> CPU0. Thus, through the kernel parameter, only one initial APIC ID can
>> be specified.
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>   arch/x86/kernel/apic/apic.c |   29 +++++++++++++++++++++++++++++
>>   1 file changed, 29 insertions(+)
>>
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index b60ad92..075bf23 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -78,6 +78,13 @@ unsigned int max_physical_apicid;
>>   physid_mask_t phys_cpu_present_map;
>>
>>   /*
>> + * Processor to be disabled specified by kernel parameter
>> + * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
>> + * avoid undefined behaviour caused by sending INIT from AP to BSP.
>> + */
>> +unsigned int disabled_cpu_apicid = BAD_APICID;
>> +
>> +/*
>>    * Map cpu index to physical APIC ID
>>    */
>>   DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
>> @@ -2117,6 +2124,19 @@ void generic_processor_info(int apicid, int version)
>>   	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>>   				phys_cpu_present_map);
>>
>> +	if (disabled_cpu_apicid != BAD_APICID &&
>> +	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
>> +	    disabled_cpu_apicid == apicid) {
>> +		int thiscpu = num_processors + disabled_cpus;
>> +
>> +		pr_warning("ACPI: Disable specified CPU."
>> +			   " Processor %d/0x%x ignored.\n",
>> +			   thiscpu, apicid);
>
> How am I to parse this message - that 'thiscpu' is being disabled
> currently? What does "Processor ... ignored" mean?
>
> Why not just write:
>
> 	ACPI: Disabling requested CPU %d (APIC ID: 0x%x)
>
> and everyone knows what's happening?
>

It seems "Disabling requested CPU %d" part is by far better than mine.
I'll apply this in the next patch.

For the latter part "(APIC ID: 0x%x)", there are other two messages about
disabling processors and I tried to use a message consistent with these.
So, I think "Processor %d/0x%x ignored.\n" should be used.

         /*
          * If boot cpu has not been detected yet, then only allow upto
          * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
          */
         if (!boot_cpu_detected && num_processors >= nr_cpu_ids - 1 &&
             apicid != boot_cpu_physical_apicid) {
                 int thiscpu = max + disabled_cpus - 1;

                 pr_warning(
                         "ACPI: NR_CPUS/possible_cpus limit of %i almost"
                         " reached. Keeping one slot for boot cpu."
                         "  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);

                 disabled_cpus++;
                 return;
         }

         if (num_processors >= nr_cpu_ids) {
                 int thiscpu = max + disabled_cpus;

                 pr_warning(
                         "ACPI: NR_CPUS/possible_cpus limit of %i reached."
                         "  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);

                 disabled_cpus++;
                 return;
         }

-- 
Thanks.
HATAYAMA, Daisuke

