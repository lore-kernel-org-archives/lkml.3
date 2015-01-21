Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbbAUFg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:36:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:41110 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbAUFgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:36:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443035007"
Message-ID: <54BF3AD5.4070600@linux.intel.com>
Date: Wed, 21 Jan 2015 13:36:21 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 14/19] ACPI: Translate resource into master side address
 for bridge window resources
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-15-git-send-email-jiang.liu@linux.intel.com> <2697984.BuF6Nq9EvE@vostro.rjw.lan>
In-Reply-To: <2697984.BuF6Nq9EvE@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 8:50, Rafael J. Wysocki wrote:
> On Thursday, January 08, 2015 10:33:01 AM Jiang Liu wrote:
>> Add translation_offset into the result address for bridge window
>> resources to form the master side address.
>>
>> Currently acpi_dev_resource_{ext_}address_space() are only used for
>> devices instead of bridges, so it won't break current users. Later
>> it will be used to support PCI host bridge drivers.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/resource.c |   14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>> index d3aa56674bd4..16d334a1ee25 100644
>> --- a/drivers/acpi/resource.c
>> +++ b/drivers/acpi/resource.c
>> @@ -203,6 +203,20 @@ static bool acpi_decode_space(struct resource *res, resource_size_t *offset,
>>  	res->start = addr->minimum;
>>  	res->end = addr->maximum;
>>  
>> +	/*
>> +	 * For bridges that translate addresses across the bridge,
>> +	 * translation_offset is the offset that must be added to the
>> +	 * address on the secondary side to obtain the address on the
>> +	 * primary side. Non-bridge devices must list 0 for all Address
>> +	 * Translation offset bits.
>> +	 */
>> +	if (base->producer_consumer == ACPI_PRODUCER) {
> 
> OK, so the assumption is that this check is never true in the current code, right?
Yes.
> 
>> +		res->start += addr->translation_offset;
>> +		res->end += addr->translation_offset;
>> +	} else if (addr->translation_offset) {
> 
> And won't this break anything even if so?
I'm trying to follow the spec, how about giving a warning here
instead of failure?
Regards!
Gerry
> 
>> +		return false;
>> +	}
>> +
>>  	switch(base->resource_type) {
>>  	case ACPI_MEMORY_RANGE:
>>  		acpi_dev_memresource_flags(res, len, wp);
>>
> 
