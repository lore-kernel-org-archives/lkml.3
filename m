Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaGKChR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:37:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:37811 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaGKChP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,641,1400050800"; 
   d="scan'208";a="560261399"
Message-ID: <53BF4D67.8020100@intel.com>
Date: Fri, 11 Jul 2014 10:35:19 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Moore, Robert" <robert.moore@intel.com>
CC: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ACPICA: Add acpi_check_gpe_method() to check
 GPE method
References: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com> <94F2FBAB4432B54E8AACC7DFDE6C92E37D1BFA16@ORSMSX112.amr.corp.intel.com>
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37D1BFA16@ORSMSX112.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月11日 03:32, Moore, Robert wrote:
> Since what is returned by this interface is essentially a piece of information about the particular GPE, I think that it might be better to generalize this interface to a "GetInfo" type of interface that returns a few pieces of information about the GPE.
> 
Hi Bob:

	Thanks for your review. Yes, that's good suggestion. But Rafael has new
solution to fix the issue. So this patch maybe not necessary.

> 
> 
>> -----Original Message-----
>> From: Lan, Tianyu
>> Sent: Monday, July 07, 2014 11:58 PM
>> To: Moore, Robert; Zheng, Lv; Wysocki, Rafael J; lenb@kernel.org
>> Cc: Lan, Tianyu; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [RFC PATCH 1/2] ACPICA: Add acpi_check_gpe_method() to check GPE
>> method
>>
>> This patch is to expose acpi_check_gpe_method() to check whether there is
>> a GPE method for the given gpe. Enabling ACPI button devices' gpes will
>> depend on the new function's result.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/acpi/acpica/evxface.c | 39
>> ++++++++++++++++++++++++++++++++++++++-
>>  include/acpi/acpixf.h         |  3 +++
>>  2 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
>> index 11e5803..0fcb248 100644
>> --- a/drivers/acpi/acpica/evxface.c
>> +++ b/drivers/acpi/acpica/evxface.c
>> @@ -717,6 +717,44 @@ ACPI_EXPORT_SYMBOL(acpi_remove_fixed_event_handler)
>>
>>
>> /*************************************************************************
>> ******
>>   *
>> + * FUNCTION:    acpi_check_gpe_method
>> + *
>> + * PARAMETERS:  gpe_device      - Namespace node for the GPE (NULL for
>> FADT
>> + *                                defined GPEs)
>> + *              gpe_number      - The event to remove a handler
>> + *
>> + * RETURN:      Status
>> + *
>> + * DESCRIPTION: Check whether the given GPE has associated event method.
>> + *
>> +
>> +***********************************************************************
>> +*******/
>> +acpi_status
>> +acpi_check_gpe_method(acpi_handle gpe_device, u32 gpe_number) {
>> +	struct acpi_gpe_event_info *gpe_event_info;
>> +	acpi_status status = AE_NOT_EXIST;
>> +	acpi_cpu_flags flags;
>> +
>> +	ACPI_FUNCTION_TRACE(acpi_check_gpe_method);
>> +
>> +	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
>> +	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
>> +	if (!gpe_event_info) {
>> +		status = AE_ERROR;
>> +		goto unlock_and_exit;
>> +	}
>> +
>> +	if (gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD)
>> +		status = AE_OK;
>> +
>> +unlock_and_exit:
>> +	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
>> +	return status;
>> +}
>> +ACPI_EXPORT_SYMBOL(acpi_check_gpe_method)
>> +
>> +/**********************************************************************
>> +*********
>> + *
>>   * FUNCTION:    acpi_install_gpe_handler
>>   *
>>   * PARAMETERS:  gpe_device      - Namespace node for the GPE (NULL for
>> FADT
>> @@ -821,7 +859,6 @@ free_and_exit:
>>  	ACPI_FREE(handler);
>>  	goto unlock_and_exit;
>>  }
>> -
>>  ACPI_EXPORT_SYMBOL(acpi_install_gpe_handler)
>>
>>
>> /*************************************************************************
>> ******
>> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h index
>> 35b525c..5b475c6 100644
>> --- a/include/acpi/acpixf.h
>> +++ b/include/acpi/acpixf.h
>> @@ -554,6 +554,9 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
>>  							  address,
>>  							  void *context))
>>  ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
>> +				acpi_check_gpe_method(acpi_handle gpe_device,
>> +							u32 gpe_number))
>> +ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
>>  				 acpi_remove_gpe_handler(acpi_handle gpe_device,
>>  							 u32 gpe_number,
>>  							 acpi_gpe_handler
>> --
>> 1.8.4.rc0.1.g8f6a3e5.dirty
> 


-- 
Best regards
Tianyu Lan
