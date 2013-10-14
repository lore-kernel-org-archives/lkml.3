Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3JNCgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:36:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:59689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab3JNCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,488,1378882800"; 
   d="scan'208";a="410383846"
Message-ID: <525B58BE.5050009@intel.com>
Date: Mon, 14 Oct 2013 10:36:46 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
 detect blacklist
References: <20131014005505.GA30503@tango.0pointer.de> <525B44C0.3010204@intel.com> <20131014022325.GA2248@tango.0pointer.de>
In-Reply-To: <20131014022325.GA2248@tango.0pointer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 10:23 AM, Lennart Poettering wrote:
> On Mon, 14.10.13 09:11, Aaron Lu (aaron.lu@intel.com) wrote:
> 
>>> Note that this appears unrelated to the Windows 8 backlight issues tracked
>>> here:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=51231
>>> https://bugzilla.kernel.org/show_bug.cgi?id=60682
>>>
>>> The Yoga's ACPI backlight controls work neither with nor without
>>> acpi_osi="!Windows 2012" on the kernel command line. It appears that
>>> backlight control via the EC simply is not available at all, regardless
>>> whether done via ACPI or via the vendor driver.
>>
>> Just a side note, if the firmware of Yoga 13 has a _OSI("Windows 2012")
>> query, then it should be solved with the patch proposed here:
>> https://lkml.org/lkml/2013/10/11/409, Fix Win8 backlight issue.
>>
>> We are still discussing a proper default behaviour in that patchset.
> 
> No. 
> 
> Did you actually read the commit message of the patch? Please do!

Yes I've read the commit message...

> 
> The backlight for the Yoga 13 doesn't work, regardless what the _OSI
> value is. In fact, it doesn't even work by directly accessing the EC via
> the ideapad-laptop driver. 
> 
> So, again:
> 
> - Backlight control doesn't work via ACPI without acpi_osi="!Windows 2012"
> - Backlight control doesn't work via ACPI with acpi_osi="!Windows 2012"
> - Backlight control doesn't work via EC commands from ideapad-laptop.c
> 
> The only way backlight handling is supported on the Yoga 13 is via the
> intel video driver.

Since I don't have access to the acpidump of this system, my only
question is, does the firmware has a _OSI("Windows 2012") query in DSDT
table?

> 
> Or in other words: the situation for the Yoga 13 is *unrelated* to the
> Windows 8 issues, and your patch.

I think they are related...
If the firmware is compatible to Windows 8, then my patch will disable
ACPI video backlight interface to prefer GPU's interface.

> 
> Hence this patch I posted, which blacklists the backlight control
> entirely in the ACPI driver, since the Windows 2012 setting is
> irrelevant to it.

Yes, the Windows 2012 setting is irrelevant to ACPI's interface(with or
without it, it doesn't work), but it's relevant to my patch as that is
the condition we are using to decide if we should skip registering ACPI
video's backlight interface.

> 
> I'll soon send another patch which also blacklists the thing in the
> ideapad driver, so that only the intel backlight driver is enabled on
> Yoga 13 systems, at which point everything will work fine.

Right, that is needed. And if going with my patch, the ideapad driver
will need to be patched similarly like thinkpad_acpi to add a check of
acpi_video_backlight_support before it decides to register its own
backlight interface.

-Aaron
