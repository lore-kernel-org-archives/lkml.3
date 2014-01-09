Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaAIL7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:59:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51858 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695AbaAIL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:58:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: print error message and bail out early if failed to parse APIC ID for CPU
Date: Thu, 09 Jan 2014 13:12:42 +0100
Message-ID: <5603175.k76fij1bcj@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389255320-1563-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389255320-1563-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 04:15:19 PM Jiang Liu wrote:
> Enhance ACPI CPU hotplug driver to print clear error message and
> bail out early if BIOS returns wrong value in ACPI MADT table or
> _MAT method. Otherwise it will add the CPU device even if failed
> to get APIC ID and fails any operations against sysfs interface:
> /sys/devices/system/cpu/cpux/online
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Do you have any pointers to bug reports regarding this etc.?  If so,
it would be good to add links to them to the commit log.

Thanks!

> ---
>  drivers/acpi/acpi_processor.c |   24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index 3c1d6b0..6ce71b0 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -212,7 +212,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  	union acpi_object object = { 0 };
>  	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
>  	struct acpi_processor *pr = acpi_driver_data(device);
> -	int cpu_index, device_declaration = 0;
> +	int apic_id, cpu_index, device_declaration = 0;
>  	acpi_status status = AE_OK;
>  	static int cpu0_initialized;
>  	unsigned long long value;
> @@ -258,18 +258,21 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  		device_declaration = 1;
>  		pr->acpi_id = value;
>  	}
> -	pr->apic_id = acpi_get_apicid(pr->handle, device_declaration,
> -					pr->acpi_id);
> -	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
>  
> -	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
> -	if (!cpu0_initialized && (cpu_index == -1) &&
> -	    (num_online_cpus() == 1)) {
> -		cpu_index = 0;
> +	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
> +	if (apic_id < 0) {
> +		acpi_handle_err(pr->handle, "failed to get CPU APIC ID.\n");
> +		return -ENODEV;
>  	}
> +	pr->apic_id = apic_id;
>  
> -	cpu0_initialized = 1;
> -
> +	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
> +	if (!cpu0_initialized) {
> +		cpu0_initialized = 1;
> +		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
> +		if ((cpu_index == -1) && (num_online_cpus() == 1))
> +			cpu_index = 0;
> +	}
>  	pr->id = cpu_index;
>  
>  	/*
> @@ -282,6 +285,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  		if (ret)
>  			return ret;
>  	}
> +
>  	/*
>  	 * On some boxes several processors use the same processor bus id.
>  	 * But they are located in different scope. For example:
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
