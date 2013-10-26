Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3JZM6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:58:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:20689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3JZM6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="313027647"
Message-ID: <526BBC87.4000301@intel.com>
Date: Sat, 26 Oct 2013 20:58:47 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Matthew Garrett <mjg@redhat.com>, hpa@zytor.com, x86@kernel.org,
        holt@sgi.com, davej@fedoraproject.org, lenb@kernel.org,
        rjw@rjwysocki.net, awilliam@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com> <20131025105352.GA5419@gmail.com>
In-Reply-To: <20131025105352.GA5419@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 06:53 PM, Ingo Molnar wrote:
>
> * tianyu.lan@intel.com <tianyu.lan@intel.com> wrote:
>
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> Sony Vaio Z1 series require "reboot=pci" for reboot and power off.
>> This patch is to add them machines to quirk table and set pci reboot
>> default.
>>
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61721
>> Reported-and-tested-by: Adam Williamson <awilliam@redhat.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>   arch/x86/kernel/reboot.c |    8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>> index 7e920bf..083ade7 100644
>> --- a/arch/x86/kernel/reboot.c
>> +++ b/arch/x86/kernel/reboot.c
>> @@ -382,6 +382,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
>>   			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
>>   		},
>>   	},
>> +	{	/* Handle problems with rebooting on Sony Vaio Z1 series*/
>> +		.callback = set_pci_reboot,
>> +		.ident = "Sony Vaio Z1",
>> +		.matches = {
>> +		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
>> +		DMI_MATCH(DMI_PRODUCT_NAME, "VPCZ1"),
>> +		},
>> +	},
>
> This is becoming somewhat endemic - do we know _why_ the ACPI reboot
> method does not work?
>
> We reworked the x86 reboot sequence 2.5 years agom, in:
>
>   commit 660e34cebf0a11d54f2d5dd8838607452355f321
>   Author: Matthew Garrett <mjg@redhat.com>
>   Date:   Mon Apr 4 13:55:05 2011 -0400
>
>      x86: Reorder reboot method preferences
>
>      We have a never ending stream of 'reboot quirks' for new boxes
>      that will not reboot properly under Linux (they will hang on
>      reboot).
>
>      The reason is widespread 'Windows compatible' assumption of modern
>      x86 hardware, which expects the following reboot sequence:
>
>       - hitting the ACPI reboot vector (if available)
>       - trying the keyboard controller
>       - hitting the ACPI reboot vector again
>       - then giving the keyboard controller one last go
>
>      This sequence expectation gets more and more embedded in modern
>      hardware, which often lacks a keyboard controller and may even
>      lock up if the legacy io ports are hit - and which hardware is
>      often not tested with Linux during development.
>
>      The end result is that reboot works under Windows-alike OSs but not
>      under Linux.
>
>      Rework our reboot process to meet this hardware externality a little
>      better and match this assumption of newer x86 hardware.
>
>      In addition to the ACPI,kbd,ACPI,kbd sequence we'll still fall
>      through to attempting a legacy triple fault if nothing else
>      works - and keep trying that and the kbd reset.
>
>      [...]
>
> Do we know why reboot apparently works quickly enough on Windows on
> this laptop, but not under Linux? Does Windows use the ACPI reboot
> method? If yes, does it use a different pattern?
>
> Is it all perhaps virtualization or IRQ routing related?
>
> I.e. we really need a real analysis here, not just a quirk!

Sorry about this. Will do some analyses.

>
> Thanks,
>
> 	Ingo
>

