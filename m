Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbbAUPCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:02:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:51363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbAUPB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,442,1418112000"; 
   d="scan'208";a="673474420"
Message-ID: <54BFBF4E.8070302@linux.intel.com>
Date: Wed, 21 Jan 2015 23:01:34 +0800
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
Subject: Re: [RFC Patch 15/19] ACPI: Add field offset to struct resource_list_entry
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1524434.hGg7sZaCUr@vostro.rjw.lan> <54BF3B24.10209@linux.intel.com> <5866060.ZvSTmUr2GQ@vostro.rjw.lan>
In-Reply-To: <5866060.ZvSTmUr2GQ@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 22:47, Rafael J. Wysocki wrote:
> On Wednesday, January 21, 2015 01:37:40 PM Jiang Liu wrote:
>> On 2015/1/21 8:53, Rafael J. Wysocki wrote:
>>> On Thursday, January 08, 2015 10:33:02 AM Jiang Liu wrote:
>>>> Add field offset to struct resource_list_entry to host address space
>>>> translation offset so it could be used to represent bridge resources.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>>> ---
>>>>  drivers/acpi/resource.c |   13 ++++++++-----
>>>>  include/linux/acpi.h    |    1 +
>>>>  2 files changed, 9 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>>>> index 16d334a1ee25..54204ac94f8e 100644
>>>> --- a/drivers/acpi/resource.c
>>>> +++ b/drivers/acpi/resource.c
>>>> @@ -462,7 +462,8 @@ struct res_proc_context {
>>>>  };
>>>>  
>>>>  static acpi_status acpi_dev_new_resource_entry(struct resource *r,
>>>> -					       struct res_proc_context *c)
>>>> +					       struct res_proc_context *c,
>>>> +					       resource_size_t offset)
>>>>  {
>>>>  	struct resource_list_entry *rentry;
>>>>  
>>>> @@ -472,6 +473,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
>>>>  		return AE_NO_MEMORY;
>>>>  	}
>>>>  	rentry->res = *r;
>>>> +	rentry->offset = offset;
>>>>  	list_add_tail(&rentry->node, c->list);
>>>>  	c->count++;
>>>>  	return AE_OK;
>>>> @@ -480,6 +482,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
>>>>  static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
>>>>  					     void *context)
>>>>  {
>>>> +	resource_size_t offset = 0;
>>>>  	struct res_proc_context *c = context;
>>>>  	struct resource r;
>>>>  	int i;
>>>> @@ -500,14 +503,14 @@ static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
>>>>  
>>>>  	if (acpi_dev_resource_memory(ares, &r)
>>>>  	    || acpi_dev_resource_io(ares, &r)
>>>> -	    || acpi_dev_resource_address_space(ares, &r, NULL)
>>>> -	    || acpi_dev_resource_ext_address_space(ares, &r, NULL))
>>>> -		return acpi_dev_new_resource_entry(&r, c);
>>>> +	    || acpi_dev_resource_address_space(ares, &r, &offset)
>>>> +	    || acpi_dev_resource_ext_address_space(ares, &r, &offset))
>>>> +		return acpi_dev_new_resource_entry(&r, c, offset);
>>>>  
>>>>  	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
>>>>  		acpi_status status;
>>>>  
>>>> -		status = acpi_dev_new_resource_entry(&r, c);
>>>> +		status = acpi_dev_new_resource_entry(&r, c, 0);
>>>>  		if (ACPI_FAILURE(status))
>>>>  			return status;
>>>>  	}
>>>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>>>> index bde8119f5897..fea78e772450 100644
>>>> --- a/include/linux/acpi.h
>>>> +++ b/include/linux/acpi.h
>>>> @@ -300,6 +300,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
>>>>  struct resource_list_entry {
>>>>  	struct list_head node;
>>>>  	struct resource res;
>>>> +	resource_size_t offset;
>>>
>>> Well, so instead of adding the offset thing here and there, wouldn't it be
>>> cleaner to introduce something like
>>>
>>> 	struct ext_resource {
>>> 		sturct resource res;
>>> 		resource_size_t offset;
>>> 	};
>>>
>>> and use struct ext_resource instead of struct resource where an offset is needed?
>>>
>>> Just a thought ...
>> Hi Rafael,
>> 	Following patches will achieve this by sharing struct resource_list_entry.
> 
> Well, yes, they will partially, but that still won't avoid the need to pass
> offset (or pointers to that) to several functions separately if I'm not
> mistaken.  Which is kind of ugly.
Hi Rafael,
	Sorry, I missed your point with last reply. I have the basic
idea about how to follow your suggestion now, will do it in next
version.
Regards,
Gerry
