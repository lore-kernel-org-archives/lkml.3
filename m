Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbbAUGhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:37:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:46594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbbAUGhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:37:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443050691"
Message-ID: <54BF4911.7030906@linux.intel.com>
Date: Wed, 21 Jan 2015 14:37:05 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Thierry Reding <treding@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [RFC Patch 17/19] resources: Move struct resource_list_entry
 from ACPI into resource core
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-18-git-send-email-jiang.liu@linux.intel.com> <3428063.tN1BxOoXSN@vostro.rjw.lan>
In-Reply-To: <3428063.tN1BxOoXSN@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 9:10, Rafael J. Wysocki wrote:
> On Thursday, January 08, 2015 10:33:04 AM Jiang Liu wrote:
<snit>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index 0bcebffc4e77..414183809383 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -1529,6 +1529,54 @@ int iomem_is_exclusive(u64 addr)
>>  	return err;
>>  }
>>  
>> +struct resource_list_entry *resource_list_alloc(struct resource *res,
>> +						size_t extra_size)
> 
> What about create_resource_list_entry()?  Less confusing surely.
Sure, I will rename it as resource_list_create_entry().

> 
>> +{
>> +	struct resource_list_entry *entry;
>> +
>> +	entry = kzalloc(sizeof(*entry) + extra_size, GFP_KERNEL);
>> +	if (entry) {
>> +		INIT_LIST_HEAD(&entry->node);
>> +		entry->res = res ? res : &entry->__res;
>> +	}
>> +
>> +	return entry;
>> +}
>> +EXPORT_SYMBOL(resource_list_alloc);
>> +
>> +void resource_list_free(struct resource_list_entry *entry)
>> +{
>> +	kfree(entry);
>> +}
>> +EXPORT_SYMBOL(resource_list_free);
> 
> Well, I'm not sure I like this.  The name suggests that it would free the
> entire list and what's wrong with using kfree() directly on "entry" anyway?
I just want to make interface symmetric. We may also support some type
of callback when freeing resources in future.

> 
>> +
>> +void resource_list_insert(struct list_head *head,
>> +			  struct resource_list_entry *entry, bool tail)
> 
> I would call this resource_list_add() if anything.
> 
> Also it may be better to have two helpers, one for "add" and one for "add_tail"
> (and perhaps define them as static inline?).
We can't use inline functions here because that needs pulling list.h
into ioport.h, then causing building issues to header inclusion order.

> 
> And why change the ordering between "head" and "entry".  That's alomost
> guaranteed to confuse people.
My fault, will change in next version.
> 
>> +{
>> +	if (tail)
>> +		list_add_tail(&entry->node, head);
>> +	else
>> +		list_add(&entry->node, head);
>> +}
>> +EXPORT_SYMBOL(resource_list_insert);
>> +
>> +void resource_list_delete(struct resource_list_entry *entry)
>> +{
>> +	list_del(&entry->node);
>> +}
>> +EXPORT_SYMBOL(resource_list_delete);
> 
> Couldn't this be a static inline)?
Inline will cause header file inclusion order issue:(

> 
> Or maybe we can combine the "list_del" with "kfree" in one function?
There are callers which need separating list_del from kfree,
so exported two interfaces here. Will add another helper interface
resource_list_destroy_entry().

Regards!
Gerry
> 
>> +
>> +void resource_list_free_list(struct list_head *head)
>> +{
>> +	struct resource_list_entry *entry, *tmp;
>> +
>> +	list_for_each_entry_safe(entry, tmp, head, node) {
>> +		list_del(&entry->node);
>> +		resource_list_free(entry);
>> +	}
>> +}
>> +EXPORT_SYMBOL(resource_list_free_list);
>> +
>>  static int __init strict_iomem(char *str)
>>  {
>>  	if (strstr(str, "relaxed"))
>>
> 
