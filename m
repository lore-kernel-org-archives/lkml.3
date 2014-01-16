Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaAPErW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:47:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48138 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAPErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:47:19 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52D763BC.8050909@jp.fujitsu.com>
Date: Thu, 16 Jan 2014 13:44:44 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@linux.intel.com
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, apic: Make disabled_cpu_apicid static read_mostly,
 fix typos
References: <20140115182511.GA22737@gmail.com> <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org>
In-Reply-To: <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/16 6:09), tip-bot for H. Peter Anvin wrote:
> Commit-ID:  5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
> Gitweb:     http://git.kernel.org/tip/5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Wed, 15 Jan 2014 13:02:08 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed, 15 Jan 2014 13:02:08 -0800
>
> x86, apic: Make disabled_cpu_apicid static read_mostly, fix typos
>
> Make disabled_cpu_apicid static and read_mostly, and fix a couple of
> typos.
>
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Link: http://lkml.kernel.org/r/20140115182511.GA22737@gmail.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>   arch/x86/kernel/apic/apic.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index e78ab8c..7f26c9a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -79,7 +79,7 @@ physid_mask_t phys_cpu_present_map;
>    * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
>    * avoid undefined behaviour caused by sending INIT from AP to BSP.
>    */
> -unsigned int disabled_cpu_apicid = BAD_APICID;
> +static unsigned int disabled_cpu_apicid __read_mostly = BAD_APICID;
>
>   /*
>    * Map cpu index to physical APIC ID
> @@ -2124,7 +2124,7 @@ int generic_processor_info(int apicid, int version)
>   	 * boot_cpu_physical_apicid is designed to have the apicid
>   	 * returned by read_apic_id(), i.e, the apicid of the
>   	 * currently booting-up processor. However, on some platforms,
> -	 * it is temporarilly modified by the apicid reported as BSP
> +	 * it is temporarily modified by the apicid reported as BSP
>   	 * through MP table. Concretely:
>   	 *
>   	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
> @@ -2145,7 +2145,7 @@ int generic_processor_info(int apicid, int version)
>   	    disabled_cpu_apicid == apicid) {
>   		int thiscpu = num_processors + disabled_cpus;
>
> -		pr_warning("ACPI: Disabling requested cpu."
> +		pr_warning("APIC: Disabling requested cpu."
>   			   " Processor %d/0x%x ignored.\n",
>   			   thiscpu, apicid);

This is not typo in my intention.

generic_processor_info() has two more cases where it ignores cpus.
In either cases, printed messages are tagged with "ACPI" because this
function is called when parsing ACPI MADT table in acpi_boot_init();
this function is also being used to parse other kind of tables but
the "ACPI" tag would mean that the function was first for ACPI only.

int generic_processor_info(int apicid, int version)
{
         int cpu, max = nr_cpu_ids;
         bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
                                 phys_cpu_present_map);

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
                 return -ENODEV;
         }

         if (num_processors >= nr_cpu_ids) {
                 int thiscpu = max + disabled_cpus;

                 pr_warning(
                         "ACPI: NR_CPUS/possible_cpus limit of %i reached."
                         "  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);

                 disabled_cpus++;
                 return -EINVAL;
         }


-- 
Thanks.
HATAYAMA, Daisuke

