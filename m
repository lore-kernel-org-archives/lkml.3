Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3K0PLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:11:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3K0PLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:11:07 -0500
Date: Wed, 27 Nov 2013 10:10:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v7 1/2] x86, apic: Add disable_cpu_apicid kernel parameter
Message-ID: <20131127151017.GI18706@redhat.com>
References: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
 <20131127020048.1493.43123.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127020048.1493.43123.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:00:48AM +0900, HATAYAMA Daisuke wrote:
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
> boot_cpu_physical_apicid is designed to have the apicid returned by
> read_apic_id(). However, on some platforms, it is temporarilly
> modified by the apicid reported as BSP through MP table. This function
> is called with the modified boot_cpu_physical_apicid.
> 
> On the platforms, boot_cpu_physical_apicid is always forced to be the
> apicid of the BSP. Then, disabled_cpu_apicid kernel parameter doesn't
> work well for apicids for APs.
> 
> Here we leave improvement of handling boot_cpu_physical_apicid as
> another work for now since the temporary modification is done on
> differnet platforms and tests on each platform are required. As a
> workaround, we directly update boot_cpu_physical_apicid by
> read_apic_id().
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/kernel/apic/apic.c |   49 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d278736..a94f618 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -75,6 +75,13 @@ unsigned int max_physical_apicid;
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
> @@ -2111,9 +2118,42 @@ void disconnect_bsp_APIC(int virt_wire_setup)
>  int generic_processor_info(int apicid, int version)
>  {
>  	int cpu, max = nr_cpu_ids;
> +	/*
> +	 * boot_cpu_physical_apicid is designed to have the apicid
> +	 * returned by read_apic_id(). However, on some platforms, it
> +	 * is temporarilly modified by the apicid reported as BSP
> +	 * through MP table. Concretely:
> +	 *
> +	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
> +	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
> +	 * - arch/x86/platform/visws/visws_quirks.c: MP_processor_info()
> +	 *
> +	 * This function is executed with the modified
> +	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
> +	 * parameter doesn't work.
> +	 *
> +	 * Since fixing handling of boot_cpu_physical_apicid requires
> +	 * another discussion and tests on each platform, we leave it
> +	 * for now and here we use read_apic_id() directly by updating
> +	 * global scope of boot_cpu_physical_id with the local one.
> +	 */
> +	unsigned int boot_cpu_physical_apicid = read_apic_id();

I think this is confusing. Why are you trying to define a local variable
with same name as global variable. There is no need. I think if we
simply put the comment there that why are we not making use of
boot_cpu_physical_apicid, that is good enough and directly read
the apic id.

	if (disabled_cpu_apicid != BAD_APICID &&
	    disabled_cpu_apicid != read_apic_id() &&
	    disabled_cpu_apicid == apicid) {

	}

Thanks
Vivek

>  	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>  				phys_cpu_present_map);
>  
> +	if (disabled_cpu_apicid != BAD_APICID &&
> +	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
> +	    disabled_cpu_apicid == apicid) {
> +		int thiscpu = num_processors + disabled_cpus;
> +
> +		pr_warning("ACPI: Disabling requested cpu."
> +			   " Processor %d/0x%x ignored.\n",
> +			   thiscpu, apicid);
> +
> +		disabled_cpus++;
> +		return -ENODEV;
> +	}
> +
>  	/*
>  	 * If boot cpu has not been detected yet, then only allow upto
>  	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
> @@ -2592,3 +2632,12 @@ static int __init lapic_insert_resource(void)
>   * that is using request_resource
>   */
>  late_initcall(lapic_insert_resource);
> +
> +static int __init apic_set_disabled_cpu_apicid(char *arg)
> +{
> +	if (!arg || !get_option(&arg, &disabled_cpu_apicid))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +early_param("disable_cpu_apicid", apic_set_disabled_cpu_apicid);
