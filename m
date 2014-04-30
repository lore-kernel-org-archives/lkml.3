Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbaD3TzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:55:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55381 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759439AbaD3TzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:55:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com
Subject: Re: [Patch v2] lapic need be checked if available when initialize acpi processor id
Date: Wed, 30 Apr 2014 22:11:34 +0200
Message-ID: <8303149.p62vWCFBDA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140430055503.GD4774@dhcp-16-105.nay.redhat.com>
References: <1397519754-10205-1-git-send-email-bhe@redhat.com> <20140430055503.GD4774@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 01:55:03 PM Baoquan He wrote:
> In acpi_processor_get_info(), acpi processor info is initialized including
> id, namely cpu index. Currently, if on UP system running SMP kerenl with
> no LAPIC in MADT, cpu0_initialized is checked if acpi processor id is
> initialized.
> 
> However this check maybe is not correct for kdump kernel. Most of time
> only 1 CPU is supported because of known problems. So in 1st kernel
> multiple CPUs are present, then crash happened in one specific CPU,
> say 2nd CPU. Then it jump into kdump kernel with "nr_cpus=1" specified
> in cmdline. In this situation, since kdump kernel is warm reset, it will
> reuse the ACPI resource passed from crashed kernel directly, namely 1st
> kernel. It means in MADT all LAPIC is enabled while only 1 CPU is
> present in running system. The kdump kernel usually is the same as the
> crashed 1st kernel. So now in kdump kernel, x86_cpu_to_apicid stored the
> apicid and its related cpu id. If only check cpu0_initialized, it will
> assign 0 to the acpi processor id of 1st CPU, it's not correct.
> 
> So in this patch, check acpi_lapic too. If acpi_lapic is 0, then LAPIC in
> MADT is not available, assigne 0 to the handling acpi processor. If
> acpi_lapic is 1, then LAPIC in MADT is available, let's get apic processor
> id from x86_cpu_to_apicid.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  drivers/acpi/acpi_processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index c29c2c3..33f934d 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -267,7 +267,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  	pr->apic_id = apic_id;
>  
>  	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
> -	if (!cpu0_initialized) {
> +	if (!cpu0_initialized && !acpi_lapic) {

That doesn't compile:

drivers/acpi/acpi_processor.c:271:28: error: 'acpi_lapic' undeclared (first use in this function)

>  		cpu0_initialized = 1;
>  		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
>  		if ((cpu_index == -1) && (num_online_cpus() == 1))
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
