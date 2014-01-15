Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaAOOmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:42:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:15839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaAOOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:42:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="459229753"
Message-ID: <52D69E57.5020208@intel.com>
Date: Wed, 15 Jan 2014 22:42:31 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, l@dorileo.org, "Zheng, Lv" <lv.zheng@intel.com>,
        robert.moore@intel.com
Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com> <5255063.SeYbBZqxVQ@vostro.rjw.lan> <20140114212406.GA25438@srcf.ucam.org> <4100200.O09E65sAKi@vostro.rjw.lan>
In-Reply-To: <4100200.O09E65sAKi@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 06:17 AM, Rafael J. Wysocki wrote:
> On Tuesday, January 14, 2014 09:24:06 PM Matthew Garrett wrote:
>> On Tue, Jan 14, 2014 at 10:37:02PM +0100, Rafael J. Wysocki wrote:
>>> On Tuesday, January 14, 2014 04:06:01 PM Matthew Garrett wrote:
>>>> On Mon, Jan 06, 2014 at 11:25:53PM +0100, Rafael J. Wysocki wrote:
>>>>
>>>>> Queued up as a fix for 3.13 (I fixed up the indentation).
>>>>
>>>> Ah, sorry, I missed this chunk of the thread. If the system provides
>>>> valid _BIF data then we should possibly just fall back to that rather
>>>> than adding another quirk table.
>>>
>>> The problem is to know that _BIX is broken.  If we could figure that out
>>> upfront, we woulnd't need the quirk table in any case.
>>
>> It's obvious that it is in this case - the package is the wrong size.
>
> Then Tianyu should be able to come up with a better fix relatively easily. :-)
>
Hi Rafael&Matthew:

	I think we can evaluate _BIX before setting ACPI_BATTERY_XINFO_PRESENT 
flag. CA routine(acpi_ns_check_package) will check the package size and 
return error code when there is wrong size package.

Something like this.

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fbf1ace..e98fa83 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -770,7 +770,7 @@ static int acpi_battery_add(struct acpi_device *device)
         device->driver_data = battery;
         mutex_init(&battery->lock);
         mutex_init(&battery->sysfs_lock);
-       if (acpi_has_method(battery->device->handle, "_BIX"))
+       if (acpi_evaluate_object(device->handle, "_BIX", NULL, &buffer);)
                 set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
         result = acpi_battery_update(battery);
         if (result)


-- 
Best Regards
Tianyu Lan
