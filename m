Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaKYASm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:18:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:44575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaKYASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:18:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,451,1413270000"; 
   d="scan'208";a="642900749"
Message-ID: <5473CADA.6040307@linux.intel.com>
Date: Tue, 25 Nov 2014 08:18:34 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, shigorin@gmail.com,
        adamw@happyassassin.net, jan.brummer@tabos.org,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [PATCH V3] ACPI: Add _DEP(Operation Region Dependencies) support
 to fix battery issue on the Asus T100TA
References: <1416748974-24124-1-git-send-email-tianyu.lan@intel.com> <54729A7B.4050007@linux.intel.com> <1720074.U59stZW2tQ@vostro.rjw.lan>
In-Reply-To: <1720074.U59stZW2tQ@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 23:27, Rafael J. Wysocki wrote:
> On Monday, November 24, 2014 10:39:55 AM Li, Aubrey wrote:
>> On 2014/11/23 21:22, Lan Tianyu wrote:
>>> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
>>> assign a higher priority in start ordering due to future operation region
>>> accesses.
>>>
>>> On Asus T100TA, ACPI battery info are read from a I2C slave device via
>>> I2C operation region. Before I2C operation region handler is installed,
>>> battery _STA always returns 0. There is a _DEP method of designating
>>> start order under battery device node.
>>>
>>> This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
>>> Introducing acpi_dep_list and adding dep_unmet count in the struct
>>> acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
>>> valid pair of master (device pointed to by _DEP)/slave(device with _DEP), record
>>> master's and slave's ACPI handle in it and put it into acpi_dep_list. The dep_unmet
>>> count will increase by one if there is a device under its _DEP. Driver's probe() should
>>> return EPROBE_DEFER when find dep_unmet is larger than 0. When I2C operation
>>> region handler is installed, remove all struct acpi_dep_data on the acpi_dep_list
>>> whose master is pointed to I2C host controller and decrease slave's dep_unmet.
>>> When dep_unmet decreases to 0, all _DEP conditions are met and then do acpi_bus_attach()
>>> for the device in order to resolve battery _STA issue on the Asus T100TA.
>>
>> Well, Can we explicitly tied this up with ASUS T100TA in the code?
>> If I understand correctly, the assumption in the patch is that the
>> battery device only depends on I2C device, which is true on ASUS T100TA,
>> but may not on the other platforms.
>>
>> This patch does not work on a box I have, on it _DEP contains I2C and GPIO.
> 
> Does the patch break anything for you?

Not I'm aware so far.

> 
>> Device (BATC)
>>         {
>>             Name (_HID, EisaId ("PNP0C0A"))  // _HID: Hardware ID
>> --------snip--------
>>             Name (_DEP, Package (0x03)  // _DEP: Dependencies
>>             {
>>                 I2C1,
>>                 GPO2,
>>                 GPO0
>>             })
>>
> 

