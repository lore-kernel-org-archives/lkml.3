Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3HaFWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:22:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37878 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab3HaFWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:22:44 -0400
Date: Sat, 31 Aug 2013 07:22:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 2/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20130831052252.GC12617@x1.alien8.de>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
 <20130829092804.5476.95588.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130829092804.5476.95588.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 06:28:04PM +0900, HATAYAMA Daisuke wrote:
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 66cab35..fd969d1 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2113,13 +2113,29 @@ void disconnect_bsp_APIC(int virt_wire_setup)
>  	apic_write(APIC_LVT1, value);
>  }
>  
> -void generic_processor_info(int apicid, int version)
> +void generic_processor_info(int apicid, bool isbsp, int version)
>  {
>  	int cpu, max = nr_cpu_ids;
>  	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>  				phys_cpu_present_map);
>  
>  	/*
> +	 * If boot cpu is AP, we now don't have any way to initialize
> +	 * BSP. To save memory consumed, we disable BSP this case and

I don't think we disable the BSP just so that we save memory and rather
because we hang in the kdump kernel otherwise, right?

> +	 * use (N-1)-cpus.
> +	 */
> +	if (isbsp && !boot_cpu_is_bsp) {

This variable naming looks confusing, IMHO. It would probably be more
understandable if 'isbsp' was called 'boot_cpu' to denote that this is
the CPU we're booting on currently. The comment above it then explains
that it is an AP and it might also refer to the issue why we're doing
that.

> +		int thiscpu = num_processors + disabled_cpus;
> +
> +		pr_warning("ACPI: The boot cpu is not BSP. "
> +			   "The BSP Processor %d/0x%x ignored.\n",
> +			   thiscpu, apicid);

Visible comment, so needs a bit of correcting:

	"ACPI: We're not booting on the BSP; BSP %d/0x%x ignored."

> +
> +		disabled_cpus++;
> +		return;
> +	}
> +
> +	/*
>  	 * If boot cpu has not been detected yet, then only allow upto
>  	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
>  	 */

Thanks.

-- 
Regards/Gruss,
Boris.
