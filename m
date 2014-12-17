Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLQFoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:44:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:30695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaLQFoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:44:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499998097"
Message-ID: <54911823.3030602@linux.intel.com>
Date: Wed, 17 Dec 2014 13:44:03 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
References: <20141211191853.613107396@linutronix.de> <20141211193112.813391696@linutronix.de> <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com> <alpine.DEB.2.11.1412120847400.16494@nanos> <548AAB67.9050005@linux.intel.com> <alpine.DEB.2.11.1412121241200.16494@nanos>
In-Reply-To: <alpine.DEB.2.11.1412121241200.16494@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Should I keep the development history or start from scratch
for this ACPI resource patch set?
Thanks!
Gerry

On 2014/12/12 19:43, Thomas Gleixner wrote:
> On Fri, 12 Dec 2014, Jiang Liu wrote:
>> On 2014/12/12 15:53, Thomas Gleixner wrote:
>>> On Thu, 11 Dec 2014, Yinghai Lu wrote:
>>>> On Thu, Dec 11, 2014 at 11:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>> +static inline bool is_valid_mem_resource(struct resource *res)
>>>>> +{
>>>>> +       return !(res->flags & IORESOURCE_DISABLED) &&
>>>>> +               (res->flags & IORESOURCE_MEM);
>>>>> +}
>>>>> +
>>>> There is minor problem about mem pref handling, original code will ignore them.
>>>
>>> Bah. I missed that in that well documented function...
>>>
>>>> with this patch will let it follow through.
>>>>
>>>> should change is_valid_mem_resource to is_valid_mem_nonpref_resource()...
>>>>
>>>> +static inline bool is_valid_mem_nonpref_resource(struct resource *res)
>>>>  {
>>>>         return !(res->flags & IORESOURCE_DISABLED) &&
>>>> -               (res->flags & IORESOURCE_MEM);
>>>> +               (res->flags & IORESOURCE_MEM) &&
>>>> +               !(res->flags & IORESOURCE_PREFETCH);
>>>>  }
>>>
>>> Unfortunately that does not help, because nothing sets the
>>> IORESOURCE_PREFETCH flag. Will fix it proper.
>>>
>>> I still have no explanation why the translation offset needs to be
>>> applied here.
>> Hi Thomas,
>> 	I have read related section in ACPI spec, seems the addition
>> of translation_offset is redundant here.
>>
>> Quotation from ACPI spec 5a, 6.4.3.5.1
>> For bridges that translate addresses across the bridge, this is the
>> offset that must be added to the address on the secondary side to
>> obtain the address on the primary side. Non-bridge devices must list
>> 0 for all Address Translation offset bits.
>>
>> Quotation from ACPI spec 5, 9.17 I/O APIC Device:
>> It must also contain a _CRS object that reports the base address of the
>> I/O APIC device. The _CRS object is required to contain only one
>> resource, a memory resource pointing to the I/O APIC register base.
>>
>> IO APIC is not a bridge, so translation_offset should always be zero.
> 
> Right and we really need a proper interface for this on the acpi side,
> so we can avoid all that dance in the usage sites.
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
