Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaD1CpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaD1CpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:45:11 -0400
Date: Mon, 28 Apr 2014 10:19:15 +0800
From: Baoquan He <bhe@redhat.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com
Subject: Re: [PATCH] acpi: try to trust cpu_index from x86_cpu_to_apicid
Message-ID: <20140428021915.GA1625@dhcp-16-105.nay.redhat.com>
References: <1397519754-10205-1-git-send-email-bhe@redhat.com>
 <11963454.DotWb00OAa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11963454.DotWb00OAa@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 at 10:51pm, Rafael J. Wysocki wrote:
> On Tuesday, April 15, 2014 07:55:54 AM Baoquan He wrote:
> > In smp with multi cpus, when enter into kdump kernel with only 1 cpu,
> > a warning message is printed out:
> > 
> > acpi LNXCPU:0a: BIOS reported wrong ACPI id 0 for the processor
> > 
> > In this case kdump kernel use the same ACPI tables as 1st kernel,
> > means lapic information is got from MADT. The acpi_id related to
> > this cpu index and lapic_id may not be 0, so the code to assign
> > value to cpu_index is not correct in this case per cpu0_initialized.
> > cpu index stored in x86_cpu_to_apicid need be respected.
> > 
> > Now fix it in this patch per boot_cpu_physical_apicid. When cpu index
> > related to boot_cpu_physical_apicid is not stored in x86_cpu_to_apicid,
> > then we can say this is UP system running SMP kernel with no LAPIC in MADT
> 
> Why don't you fix the warning message instead to cover this case too? 
> 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  drivers/acpi/acpi_processor.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > index c29c2c3..1ae460c 100644
> > --- a/drivers/acpi/acpi_processor.c
> > +++ b/drivers/acpi/acpi_processor.c
> > @@ -267,7 +267,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
> >  	pr->apic_id = apic_id;
> >  
> >  	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
> > -	if (!cpu0_initialized) {
> > +	if (!cpu0_initialized && (boot_cpu_physical_apicid == pr->apic_id)) {

Self NACK this patch.

Since this check should be limited on no LAPIC in MADT, so acpi_lapic is
better for this. Will repost after test.

Hi Rafael,

Do you have any suggestion on this fix?

Thanks
Baoquan

