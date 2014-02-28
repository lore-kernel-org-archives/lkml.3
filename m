Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaB1Fdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:33:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:2011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaB1Fdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:33:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="483336031"
Message-ID: <53101FAB.3080609@linux.intel.com>
Date: Fri, 28 Feb 2014 13:33:31 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len.Brown@intel.com, "alan@linux.intel.com" <alan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] ACPI/Sleep: pm_power_off need more sanity check to be
 installed
References: <530D558D.6090607@linux.intel.com> <1853937.5e0COHhnpP@vostro.rjw.lan>
In-Reply-To: <1853937.5e0COHhnpP@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/27 7:50, Rafael J. Wysocki wrote:
> On Wednesday, February 26, 2014 10:46:37 AM Li, Aubrey wrote:
>> Sleep control and status registers need santity check before ACPI
>> install acpi_power_off to pm_power_off hook. The checking code in
>> acpi_enter_sleep_state() is too late, we should not allow a not-working
>> pm_power_off function hooked.
>>
>> Signed-off-by: Aubrey Li <aubrey.li@intel.com>
>> ---
>>  drivers/acpi/sleep.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index b718806..0284d22 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -809,8 +809,11 @@ int __init acpi_sleep_init(void)
>>  	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
>>  	if (ACPI_SUCCESS(status)) {
>>  		sleep_states[ACPI_STATE_S5] = 1;
> 
> Do we still want to set this if the check below fails?  If so, then why?

We know \_S5_ is valid. The fault is sleep registers, not S5 ACPI object

Thanks,
-Aubrey

> 
>> -		pm_power_off_prepare = acpi_power_off_prepare;
>> -		pm_power_off = acpi_power_off;
>> +		if (acpi_gbl_FADT.sleep_control.address &&
>> +			acpi_gbl_FADT.sleep_status.address) {
>> +			pm_power_off_prepare = acpi_power_off_prepare;
>> +			pm_power_off = acpi_power_off;
>> +		}
>>  	}
>>
>>  	supported[0] = 0;
>>
> 

