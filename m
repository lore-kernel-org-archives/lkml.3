Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaIIKzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:55:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:51673 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaIIKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:55:39 -0400
Date: Tue, 9 Sep 2014 12:54:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v4 05/16] ACPI: Add interfaces to parse IOAPIC ID for
 IOAPIC hotplug
In-Reply-To: <1409192561-19744-6-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409091248090.11037@nanos>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-6-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Jiang Liu wrote:
>  
> +static struct acpi_table_madt *madt;
> +static int read_madt;

Pretty lousy file visible variable names.

So we end up with two copies of the butt ugly 

   if (!read_madt) {
      .....
   }

stuff instead of creating a helper function which hides that and do

      madr = get_madt();
      if (!madt)
		return ...;

at the call sites.

>  static int map_lapic_id(struct acpi_subtable_header *entry,
>  		 u32 acpi_id, int *apic_id)
>  {
> @@ -64,8 +71,6 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>  static int map_madt_entry(int type, u32 acpi_id)
>  {
>  	unsigned long madt_end, entry;
> -	static struct acpi_table_madt *madt;
> -	static int read_madt;
>  	int apic_id = -1;
>  
>  	if (!read_madt) {
> @@ -200,3 +205,90 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
>  	return acpi_map_cpuid(apic_id, acpi_id);
>  }
>  EXPORT_SYMBOL_GPL(acpi_get_cpuid);
> +
> +#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
> +static int map_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
> +			 u64 *phys_addr, int *ioapic_id)
> +{
> +	struct acpi_madt_io_apic *ioapic = (struct acpi_madt_io_apic *)entry;
> +
> +	if (ioapic->global_irq_base != gsi_base)
> +		return 0;
> +
> +	*phys_addr = ioapic->address;
> +	*ioapic_id = ioapic->id;
> +	return 1;
> +}
> +
> +static int map_madt_ioapic_entry(u32 gsi_base, u64 *phys_addr)
> +{
> +	struct acpi_subtable_header *hdr;
> +	unsigned long madt_end, entry;
> +	int apic_id = -1;
> +
> +	if (!read_madt) {
> +		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
> +					(struct acpi_table_header **)&madt)))
> +			madt = NULL;
> +		read_madt++;
> +	}
> +
> +	if (!madt)
> +		return apic_id;
> +
> +	entry = (unsigned long)madt;
> +	madt_end = entry + madt->header.length;
> +
> +	/* Parse all entries looking for a match. */
> +	entry += sizeof(struct acpi_table_madt);
> +	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
> +		hdr = (struct acpi_subtable_header *)entry;
> +		if (hdr->type == ACPI_MADT_TYPE_IO_APIC &&
> +		    map_ioapic_id(hdr, gsi_base, phys_addr, &apic_id))
> +			break;
> +		else
> +			entry += hdr->length;
> +	}
> +
> +	return apic_id;
> +}
> +
> +static int map_mat_ioapic_entry(acpi_handle handle, u32 gsi_base,
> +				u64 *phys_addr)
> +{
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj;
> +	struct acpi_subtable_header *header;
> +	int apic_id = -1;
> +
> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
> +		goto exit;
> +
> +	if (!buffer.length || !buffer.pointer)
> +		goto exit;
> +
> +	obj = buffer.pointer;
> +	if (obj->type != ACPI_TYPE_BUFFER ||
> +	    obj->buffer.length < sizeof(struct acpi_subtable_header))
> +		goto exit;
> +
> +	header = (struct acpi_subtable_header *)obj->buffer.pointer;
> +	if (header->type == ACPI_MADT_TYPE_IO_APIC)
> +		map_ioapic_id(header, gsi_base, phys_addr, &apic_id);
> +
> +exit:
> +	kfree(buffer.pointer);
> +	return apic_id;
> +}


This stuff really wants proper documentation. The lack of comments is
just annoying.

> +int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr)
> +{
> +	int apic_id;
> +
> +	apic_id = map_mat_ioapic_entry(handle, gsi_base, phys_addr);
> +	if (apic_id == -1)
> +		apic_id = map_madt_ioapic_entry(gsi_base, phys_addr);
> +
> +	return apic_id;
> +}

Thanks,

	tglx
