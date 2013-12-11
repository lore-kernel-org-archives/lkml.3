Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3LKHDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:03:16 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44550 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3LKHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:03:11 -0500
Message-ID: <52A80E15.50404@linaro.org>
Date: Wed, 11 Dec 2013 15:02:45 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel@lists.linaro.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part2 PATCH 4/9] ARM64 / ACPI: Use Parked Address in GIC
 structure for spin table SMP initialisation
References: <1385999094-3152-1-git-send-email-hanjun.guo@linaro.org> < 1385999094-3152-5-git-send-email-hanjun.guo@linaro.org> <20131210130330.65087C40A27@trevor.secretlab.ca>
In-Reply-To: <20131210130330.65087C40A27@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-10 21:03, Grant Likely wrote:
[...]
>> +/* Parked Address in ACPI GIC structure can be used as cpu release addr */
>> +int acpi_get_parked_address_with_gic_id(u32 gic_id, u64 *parked_address)
>> +{
>> +	struct acpi_table_header *table_header = NULL;
>> +	struct acpi_subtable_header *entry;
>> +	int err = 0;
>> +	unsigned long table_end;
>> +	acpi_size tbl_size;
>> +	struct acpi_madt_generic_interrupt *processor = NULL;
>> +
>> +	if (!parked_address)
>> +		return -EINVAL;
>> +
>> +	acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table_header, &tbl_size);
>> +	if (!table_header) {
>> +		pr_warn(PREFIX "MADT table not present\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	table_end = (unsigned long)table_header + table_header->length;
>> +
>> +	/* Parse all entries looking for a match. */
>> +	entry = (struct acpi_subtable_header *)
>> +	    ((unsigned long)table_header + sizeof(struct acpi_table_madt));
>> +
>> +	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
>> +	       table_end) {
>> +		if (entry->type != ACPI_MADT_TYPE_GENERIC_INTERRUPT
>> +			|| BAD_MADT_ENTRY(entry, table_end))
>> +			continue;
>> +
>> +		processor = (struct acpi_madt_generic_interrupt *)entry;
>> +
>> +		if (processor->gic_id == gic_id) {
>> +			*parked_address = processor->parked_address;
>> +			goto out;
>> +		}
>> +
>> +		entry = (struct acpi_subtable_header *)
>> +		    ((unsigned long)entry + entry->length);
> 
> All of the casting in this table looks suspicious. If you have to resort
> to casting, then the variable types are very likely wrong.
> 
> In the case immediately above, it seems that the entry size doesn't
> necessarily equal the acpi_subtable_header size, in which case you
> should cast the values to a void* instead of an unsigned long. That
> would mean you can do this:
> 
> 	entry = ((void*)entry) + entry->length;
> 
> In fact, if I were writing the code, I would have two variables; the
> iterator pointer as a void* and a header pointer as a struct
> acpi_subtable_header*. Like so:
> 
> 	void *entry, *table_end;
> 	struct acpi_subtable_header *header;
> 
> 	entry = ((void*)table_header) + sizeof(struct acpi_table_madt);
> 	table_end = ((void*)table_header) + table_header->length;
> 	while (entry + sizeof(*header)) < table_end) {
> 		header = entry;
> 
> 		if (header->type != ACPI_MADT_TYPE_GENERIC_INTERRUPT ||
> 			BAD_MADT_ENTRY(entry, table_end))
> 			continue;
> 		processor = entry;
> 
> 		if (processor->gic_id == gic_id) {
> 			*parked_address = processor->parked_address;
> 			goto out;
> 		}
> 
> 		entry += header->length;
> 	}
> 
> See? Much cleaner code.

Aha, much much cleaner, thanks for the guidance, will rework my patch
and test it.

Hanjun

