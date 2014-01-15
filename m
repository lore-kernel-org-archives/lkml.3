Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaAOSZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:25:22 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49155 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaAOSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:25:15 -0500
Date: Wed, 15 Jan 2014 19:25:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        d.hatayama@jp.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, apic, kexec: Add disable_cpu_apicid kernel
 parameter
Message-ID: <20140115182511.GA22737@gmail.com>
References: <20140115064458.1545.38775.stgit@localhost6.localdomain6>
 <tip-151e0c7de616310f95393d9306903900fcd8b277@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-151e0c7de616310f95393d9306903900fcd8b277@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for HATAYAMA Daisuke <tipbot@zytor.com> wrote:

>  /*
> + * Processor to be disabled specified by kernel parameter
> + * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
> + * avoid undefined behaviour caused by sending INIT from AP to BSP.
> + */
> +unsigned int disabled_cpu_apicid = BAD_APICID;

Any reason why this isn't static & read_mostly?

> @@ -2114,6 +2121,39 @@ int generic_processor_info(int apicid, int version)
>  				phys_cpu_present_map);
>  
>  	/*
> +	 * boot_cpu_physical_apicid is designed to have the apicid
> +	 * returned by read_apic_id(), i.e, the apicid of the
> +	 * currently booting-up processor. However, on some platforms,
> +	 * it is temporarilly modified by the apicid reported as BSP

s/temporarily

> +	 * through MP table. Concretely:
> +	 *
> +	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
> +	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
> +	 * - arch/x86/platform/visws/visws_quirks.c: MP_processor_info()
> +	 *
> +	 * This function is executed with the modified
> +	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
> +	 * parameter doesn't work to disable APs on kdump 2nd kernel.
> +	 *
> +	 * Since fixing handling of boot_cpu_physical_apicid requires
> +	 * another discussion and tests on each platform, we leave it
> +	 * for now and here we use read_apic_id() directly in this
> +	 * function, generic_processor_info().
> +	 */
> +	if (disabled_cpu_apicid != BAD_APICID &&
> +	    disabled_cpu_apicid != read_apic_id() &&
> +	    disabled_cpu_apicid == apicid) {
> +		int thiscpu = num_processors + disabled_cpus;
> +
> +		pr_warning("ACPI: Disabling requested cpu."
> +			   " Processor %d/0x%x ignored.\n",
> +			   thiscpu, apicid);

Why does this message say 'ACPI'? Shouldn't it say 'apic' instead?

Thanks,

	Ingo
