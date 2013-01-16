Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3APWsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:48:37 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55918 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab3APWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:48:35 -0500
Message-ID: <50F72E40.5040903@suse.cz>
Date: Wed, 16 Jan 2013 23:48:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: -next: no resume from suspend
References: <50F3D9E8.6040802@suse.cz> <16191961.j5ydKsJ3d3@vostro.rjw.lan> <50F68443.3040900@suse.cz> <1383787.8I6fLLmNxl@vostro.rjw.lan>
In-Reply-To: <1383787.8I6fLLmNxl@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 03:00 PM, Rafael J. Wysocki wrote:
> On Wednesday, January 16, 2013 11:43:15 AM Jiri Slaby wrote:
>> On 01/14/2013 01:56 PM, Rafael J. Wysocki wrote:
>>> On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
>>>> Hi,
>>>>
>>>> since friday's -next (the last known to be working is the last monday's)
>>>> I cannot resume from suspend. The last thing I see with
>>>> no_console_suspend is:
>>>> i915: No ACPI video bus found
>>>>
>>>> But I used to see the message always, so this is no difference. Any idea
>>>> before I start bisecting?
>>>
>>> Well, what's the next message you normally see with no_console_suspend?
>>
>> As I wrote in the other message, the kernel is spinning in
>> acpi_rs_get_aml_length. There are weird resources in the list. For
>> serial 00:05 there is resource with type and length equal to 0 and for
>> parport_pc 00:06 there is resource type 58196295 with length of
>> 134284152. See:
>> acpi_rs_get_aml_length: ffff8801b9f7b380 type=3 len=16
>> acpi_rs_get_aml_length: ffff8801b9f7b390 type=0 len=0
>> acpi_rs_get_aml_length: BAD ffff8801b9f7b390 type=0 len=0
>> serial 00:05: activation failed
>> dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
>> PM: Device 00:05 failed to resume: error -5
>> acpi_rs_get_aml_length: ffff8801b9f7b680 type=3 len=24
>> acpi_rs_get_aml_length: ffff8801b9f7b698 type=58196295 len=134284152
>> parport_pc 00:06: activation failed
>> dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
>> PM: Device 00:06 failed to resume: error -5
>>
>> if (!length)
>>   return error;
>>
>> makes it resume again with the errors above...
>>
>> This was 3.8.0-rc3-next-20130114. 
> 
> There are two things you can try.  First, revert all of the ACPICA patches
> and see if that helps.  Second, if that doesn't help, try to revert things in
> the PCI tree (alternatively, you can try the PCI tree alone).
> 
> I have tested suspend/resume with the ACPI (including ACPICA) patches applied,
> but I haven't tested the PCI tree.

I bisected that. It is caused by the following commit:
commit 2a3ab82714043580505634ff5b9a743ff4237376
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri Jan 4 22:38:10 2013 +0000

    PNPACPI: Use _CRS buffer directly as _SRS template

Acpidump is here if you are interested:
http://www.fi.muni.cz/~xslaby/sklad/adump

thanks,
-- 
js
suse labs
