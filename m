Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaBSFrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:47:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:63773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaBSFrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:47:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="483855161"
Message-ID: <5304453F.1050104@linux.intel.com>
Date: Wed, 19 Feb 2014 13:46:39 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC Patch v1 2/6] ACPI: rename acpi_evaluate_hotplug_ost to
 acpi_evaluate_ost for reuse
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com> <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com> <1392613373-11003-2-git-send-email-jiang.liu@linux.intel.com> <6382282.2gCVKeUJUt@vostro.rjw.lan>
In-Reply-To: <6382282.2gCVKeUJUt@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
	We have following code to deal with existing users.
+#ifdef ACPI_HOTPLUG_OST
+#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost
+#else
+static inline acpi_status
 acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
-			u32 status_code, struct acpi_buffer *status_buf);
+			u32 status_code, struct acpi_buffer *status_buf)
+{ return AE_OK; }
+#endif

Thanks!

On 2014/2/18 9:06, Rafael J. Wysocki wrote:
> On Monday, February 17, 2014 01:02:49 PM Jiang Liu wrote:
>> Rename acpi_evaluate_hotplug_ost() to acpi_evaluate_ost() for later resue.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/utils.c    |   14 ++++----------
>>  include/acpi/acpi_bus.h |   10 +++++++++-
>>  2 files changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
>> index 85e3b61..19d0169 100644
>> --- a/drivers/acpi/utils.c
>> +++ b/drivers/acpi/utils.c
>> @@ -433,17 +433,15 @@ EXPORT_SYMBOL(acpi_get_physical_device_location);
>>   * When the platform does not support _OST, this function has no effect.
>>   */
>>  acpi_status
>> -acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
>> -		u32 status_code, struct acpi_buffer *status_buf)
> 
> There are users of this, what about updating them?
> 
>> +acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
>> +		  struct acpi_buffer *status_buf)
>>  {
>> -#ifdef ACPI_HOTPLUG_OST
>>  	union acpi_object params[3] = {
>>  		{.type = ACPI_TYPE_INTEGER,},
>>  		{.type = ACPI_TYPE_INTEGER,},
>>  		{.type = ACPI_TYPE_BUFFER,}
>>  	};
>>  	struct acpi_object_list arg_list = {3, params};
>> -	acpi_status status;
>>  
>>  	params[0].integer.value = source_event;
>>  	params[1].integer.value = status_code;
>> @@ -455,13 +453,9 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
>>  		params[2].buffer.length = 0;
>>  	}
>>  
>> -	status = acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
>> -	return status;
>> -#else
>> -	return AE_OK;
>> -#endif
>> +	return acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
>>  }
>> -EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
>> +EXPORT_SYMBOL(acpi_evaluate_ost);
>>  
>>  /**
>>   * acpi_handle_printk: Print message with ACPI prefix and object path
>> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
>> index 8256eb4..adef502 100644
>> --- a/include/acpi/acpi_bus.h
>> +++ b/include/acpi/acpi_bus.h
>> @@ -49,8 +49,16 @@ acpi_evaluate_reference(acpi_handle handle,
>>  			struct acpi_object_list *arguments,
>>  			struct acpi_handle_list *list);
>>  acpi_status
>> +acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
>> +		  struct acpi_buffer *status_buf);
>> +#ifdef ACPI_HOTPLUG_OST
>> +#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost
>> +#else
>> +static inline acpi_status
>>  acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
>> -			u32 status_code, struct acpi_buffer *status_buf);
>> +			u32 status_code, struct acpi_buffer *status_buf)
>> +{ return AE_OK; }
>> +#endif
>>  
>>  acpi_status
>>  acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
>>
> 
