Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaGIDKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:10:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:58441 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbaGIDKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,630,1400050800"; 
   d="scan'208";a="559139354"
Message-ID: <53BCB23A.1070304@intel.com>
Date: Wed, 09 Jul 2014 11:08:42 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ACPI/Wakup: Enable button wakeup GPEs if these
 GPEs have associated GPE methods.
References: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com> <1404802679-24019-2-git-send-email-tianyu.lan@intel.com> <3011365.oYtXFx0LHa@vostro.rjw.lan>
In-Reply-To: <3011365.oYtXFx0LHa@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月08日 21:26, Rafael J. Wysocki wrote:
> On Tuesday, July 08, 2014 02:57:58 PM Lan Tianyu wrote:
>> The button wakeup GPEs are enabled unconditionally in the current world by
>> commit 2a5d24(ACPI / Wakeup: Enable button GPEs unconditionally during
>> initialization). Because button's GPE methods needs to be run to clear
>> GPE status on some machines when there is GPE interrupt. If not, it will
>> cause machines resume immediately after being suspended since GPE status
>> isn't cleared correctly.
>>
>> But if there is no GPE method for button wakeup GPE, these GPEs should not
>> be enabled since nothing needs to be done when they are triggered and this
>> also causes LID GPE storm on Lenovo Ideapad y560p.
>>
>> This patch is to check Button GPE method and enable it if there is associated
>> GPE method.
> 
> Part of the problem is that we call acpi_setup_gpe_for_wake() for buttons too
> and it sets ACPI_GPE_DISPATCH_NOTIFY unconditionally.

Yes, this is why the GPE wasn't disabled by CA. From my opinion,
original reason of enabling button wakeup GPE in the runtime is that it
may have associated GPE method and the method will notify button driver
and clear some hardware status. But if it didn't have GPE method, I
don't why we need to enable the GPE. I check some machines and they use
EC Query event to notify button driver.

>  While we could address
> this the way you're proposing, it seems a bit less than straightforward so to
> speak.
> 
> Let me think more about how to address that.

Ok. I get it.

> 
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61051
>> Reported-by: James Tocknell<aragilar@gmail.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/acpi/wakeup.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
>> index 1638401..5b20ae4 100644
>> --- a/drivers/acpi/wakeup.c
>> +++ b/drivers/acpi/wakeup.c
>> @@ -86,9 +86,14 @@ int __init acpi_wakeup_device_init(void)
>>  						       struct acpi_device,
>>  						       wakeup_list);
>>  		if (device_can_wakeup(&dev->dev)) {
>> -			/* Button GPEs are supposed to be always enabled. */
>> -			acpi_enable_gpe(dev->wakeup.gpe_device,
>> -					dev->wakeup.gpe_number);
>> +			/*
>> +			 * Button GPEs are supposed to be always enabled if
>> +			 * they have associated GPE methods.
>> +			 */
>> +			if (ACPI_SUCCESS(acpi_check_gpe_method(
>> +			    dev->wakeup.gpe_device, dev->wakeup.gpe_number)))
>> +				acpi_enable_gpe(dev->wakeup.gpe_device,
>> +						dev->wakeup.gpe_number);
>>  			device_set_wakeup_enable(&dev->dev, true);
>>  		}
>>  	}
>>
> 


-- 
Best regards
Tianyu Lan
