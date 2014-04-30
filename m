Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbaD3T52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:57:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64769 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759433AbaD3T50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:57:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com
Subject: Re: [Patch v2] lapic need be checked if available when initialize acpi processor id
Date: Wed, 30 Apr 2014 22:13:57 +0200
Message-ID: <20009828.4TTRJo9T7a@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140430060303.GE4774@dhcp-16-105.nay.redhat.com>
References: <1397519754-10205-1-git-send-email-bhe@redhat.com> <20140430055503.GD4774@dhcp-16-105.nay.redhat.com> <20140430060303.GE4774@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 02:03:03 PM Baoquan He wrote:
> Hi Rafael,

Hi,

> Thanks for previous review for v1. Later on I thought acpi_lapic is
> more suitable for checking whether LAPIC in MADT is available, and it can
> hanlde both the UP system running SMP kernel with no LAPIC in MADT and kdump
> kernel after multiple CPUs system crashed on non-1st CPU.
> 
> I tested the 1st case by addding "disableapic nr_cpus=1" into cmdline
> of SMP kenrel, and it works. For 2nd case, it works too, below warning
> message is not printed any more. 
> 
> acpi LNXCPU:0a: BIOS reported wrong ACPI id 0 for the processor
> 
> Do you like this idea?

Well, I don't hate it, but you need to make the code build in all
configurations (including ia64).

Thanks!


> On 04/30/14 at 01:55pm, Baoquan He wrote:
> > In acpi_processor_get_info(), acpi processor info is initialized including
> > id, namely cpu index. Currently, if on UP system running SMP kerenl with
> > no LAPIC in MADT, cpu0_initialized is checked if acpi processor id is
> > initialized.
> > 
> > However this check maybe is not correct for kdump kernel. Most of time
> > only 1 CPU is supported because of known problems. So in 1st kernel
> > multiple CPUs are present, then crash happened in one specific CPU,
> > say 2nd CPU. Then it jump into kdump kernel with "nr_cpus=1" specified
> > in cmdline. In this situation, since kdump kernel is warm reset, it will
> > reuse the ACPI resource passed from crashed kernel directly, namely 1st
> > kernel. It means in MADT all LAPIC is enabled while only 1 CPU is
> > present in running system. The kdump kernel usually is the same as the
> > crashed 1st kernel. So now in kdump kernel, x86_cpu_to_apicid stored the
> > apicid and its related cpu id. If only check cpu0_initialized, it will
> > assign 0 to the acpi processor id of 1st CPU, it's not correct.
> > 
> > So in this patch, check acpi_lapic too. If acpi_lapic is 0, then LAPIC in
> > MADT is not available, assigne 0 to the handling acpi processor. If
> > acpi_lapic is 1, then LAPIC in MADT is available, let's get apic processor
> > id from x86_cpu_to_apicid.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  drivers/acpi/acpi_processor.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > index c29c2c3..33f934d 100644
> > --- a/drivers/acpi/acpi_processor.c
> > +++ b/drivers/acpi/acpi_processor.c
> > @@ -267,7 +267,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
> >  	pr->apic_id = apic_id;
> >  
> >  	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
> > -	if (!cpu0_initialized) {
> > +	if (!cpu0_initialized && !acpi_lapic) {
> >  		cpu0_initialized = 1;
> >  		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
> >  		if ((cpu_index == -1) && (num_online_cpus() == 1))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
