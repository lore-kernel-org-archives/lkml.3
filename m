Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbbAVC54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:57:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:12189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbbAVC5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:57:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,446,1418112000"; 
   d="scan'208";a="640753172"
Message-ID: <54C06726.4090805@linux.intel.com>
Date: Thu, 22 Jan 2015 10:57:42 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [RFC Patch 05/19] ACPI: Provide union for address_space64 and
 ext_address_space64
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-6-git-send-email-jiang.liu@linux.intel.com> <1AE640813FDE7649BE1B193DEA596E88026B9EFB@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026B9EFB@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2015/1/22 10:32, Zheng, Lv wrote:
> Hi, Thomas and Jiang
> 
>> From: Jiang Liu [mailto:jiang.liu@linux.intel.com]
>> Sent: Thursday, January 08, 2015 10:33 AM
>>
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> address_space64 and ext_address_space64 share substracts just at
>> different offsets. To unify the parsing functions implement the two
>> structs as unions of their substructs, so we can extract the shared
>> data.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  include/acpi/acrestyp.h |   49 ++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 36 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/acpi/acrestyp.h b/include/acpi/acrestyp.h
>> index eb760ca0b2e0..307d5b2605c8 100644
>> --- a/include/acpi/acrestyp.h
>> +++ b/include/acpi/acrestyp.h
>> @@ -326,23 +326,46 @@ struct acpi_resource_address32 {
>>  	struct acpi_resource_source resource_source;
>>  };
>>
>> -struct acpi_resource_address64 {
>> -	ACPI_RESOURCE_ADDRESS_COMMON u64 granularity;
>> -	u64 minimum;
>> -	u64 maximum;
>> -	u64 translation_offset;
>> +#define ACPI_RESOURCE_ADDRESS64_COMMON \
>> +	u64 granularity;	       \
>> +	u64 minimum;		       \
>> +	u64 maximum;		       \
>> +	u64 translation_offset;	       \
>>  	u64 address_length;
>> -	struct acpi_resource_source resource_source;
>> +
>> +struct acpi_resource_address64_common {
>> +ACPI_RESOURCE_ADDRESS64_COMMON};
>> +
>> +struct acpi_resource_address64 {
>> +	union {
>> +		struct {
>> +			ACPI_RESOURCE_ADDRESS_COMMON
>> +			ACPI_RESOURCE_ADDRESS64_COMMON
>> +			struct acpi_resource_source resource_source;
>> +		};
> 
> This looks wrong to ACPICA upstream.
> 
>> +		struct {
>> +			struct acpi_resource_address base;
>> +			struct acpi_resource_address64_common addr;
>> +			struct acpi_resource_source resource_source;
>> +		} common;
>> +	};
>>  };
> 
> And this.
> Though anonymous structs/unions are now C11 standard, I still didn't see it used in the ACPICA upstream.
> It could be a problem if someone still compiles ACPICA using old compilers.
> 
>>
>>  struct acpi_resource_extended_address64 {
>> -	ACPI_RESOURCE_ADDRESS_COMMON u8 revision_ID;
>> -	u64 granularity;
>> -	u64 minimum;
>> -	u64 maximum;
>> -	u64 translation_offset;
>> -	u64 address_length;
>> -	u64 type_specific;
>> +	union {
>> +		struct {
>> +			ACPI_RESOURCE_ADDRESS_COMMON
>> +			u8 revision_ID;
>> +			ACPI_RESOURCE_ADDRESS64_COMMON
>> +			u64 type_specific;
>> +		};
> 
> Ditto.
> 
>> +		struct {
>> +			struct acpi_resource_address base;
>> +			u8 revision_ID;
>> +			struct acpi_resource_address64_common addr;
>> +			u64 type_specific;
>> +		} common;
>> +	};
> 
> Ditto.
> 
> I think what you want is the ability to access common.addr and common.base from different resource address64 types.
> So we can achieve this directly in the ACPICA upstream without using the union.
> 
> I tried this in the ACPICA upstream and the result is:
> https://github.com/zetalog/acpica/commit/0f4ed510
> Let me send its linuxized version after this email.
Hi Lv,
	Thanks for your great support:)
	What's the normal process to propagate this patch into
linux kernel? Or how long will it take? We have another hotplug
patch set which depends on this patch set, then depends on this
ACPICA core change.
Regards!
Gerry
> 
> Thanks and best regards
> -Lv
> 
>>  };
>>
>>  struct acpi_resource_extended_irq {
>> --
>> 1.7.10.4
> 
