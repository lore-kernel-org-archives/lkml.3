Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3KLKou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:44:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36102 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab3KLKor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:44:47 -0500
Date: Tue, 12 Nov 2013 11:44:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v5 2/3] x86, apic: Add disable_cpu_apicid kernel parameter
Message-ID: <20131112104423.GB12849@pd.tnic>
References: <20131112094952.4902.72689.stgit@localhost6.localdomain6>
 <20131112095158.4902.75396.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112095158.4902.75396.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:51:58PM +0900, HATAYAMA Daisuke wrote:
> Add disable_cpu_apicid kernel parameter. To use this kernel parameter,
> specify an initial APIC ID of the corresponding CPU you want to
> disable.
> 
> This is mostly used for the kdump 2nd kernel to disable BSP to wake up
> multiple CPUs without causing system reset or hang due to sending INIT
> from AP to BSP.
> 
> Kdump users first figure out initial APIC ID of the BSP, CPU0 in the
> 1st kernel, for example from /proc/cpuinfo and then set up this kernel
> parameter for the 2nd kernel using the obtained APIC ID.
> 
> However, doing this procedure at each boot time manually is awkward,
> which should be automatically done by user-land service scripts, for
> example, kexec-tools on fedora/RHEL distributions.
> 
> This design is more flexible than disabling BSP in kernel boot time
> automatically in that in kernel boot time we have no choice but
> referring to ACPI/MP table to obtain initial APIC ID for BSP, meaning
> that the method is not applicable to the systems without such BIOS
> tables.
> 
> One assumption behind this design is that users get initial APIC ID of
> the BSP in still healthy state and so BSP is uniquely kept in
> CPU0. Thus, through the kernel parameter, only one initial APIC ID can
> be specified.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/kernel/apic/apic.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b60ad92..075bf23 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -78,6 +78,13 @@ unsigned int max_physical_apicid;
>  physid_mask_t phys_cpu_present_map;
>  
>  /*
> + * Processor to be disabled specified by kernel parameter
> + * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
> + * avoid undefined behaviour caused by sending INIT from AP to BSP.
> + */
> +unsigned int disabled_cpu_apicid = BAD_APICID;
> +
> +/*
>   * Map cpu index to physical APIC ID
>   */
>  DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
> @@ -2117,6 +2124,19 @@ void generic_processor_info(int apicid, int version)
>  	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>  				phys_cpu_present_map);
>  
> +	if (disabled_cpu_apicid != BAD_APICID &&
> +	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
> +	    disabled_cpu_apicid == apicid) {
> +		int thiscpu = num_processors + disabled_cpus;
> +
> +		pr_warning("ACPI: Disable specified CPU."
> +			   " Processor %d/0x%x ignored.\n",
> +			   thiscpu, apicid);

How am I to parse this message - that 'thiscpu' is being disabled
currently? What does "Processor ... ignored" mean?

Why not just write:

	ACPI: Disabling requested CPU %d (APIC ID: 0x%x)

and everyone knows what's happening?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
