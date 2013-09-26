Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3IZCii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:38:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3IZCig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:38:36 -0400
X-IronPort-AV: E=Sophos;i="4.90,982,1371052800"; 
   d="scan'208";a="8624516"
Message-ID: <52439CFE.4030501@cn.fujitsu.com>
Date: Thu, 26 Sep 2013 10:33:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [Bug report] Warning when hot-add an ACPI0004 device.
References: <52314A89.2060809@cn.fujitsu.com>  <1378998712.12538.18.camel@misato.fc.hp.com>  <5242BB6D.3060504@cn.fujitsu.com> <1380147885.14046.40.camel@misato.fc.hp.com>
In-Reply-To: <1380147885.14046.40.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 10:36:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 10:36:50,
	Serialize complete at 2013/09/26 10:36:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

On 09/26/2013 06:24 AM, Toshi Kani wrote:

> On Wed, 2013-09-25 at 10:31 +0000, Gu Zheng wrote:
>> Hi Toshi,
>>
>> On 09/12/2013 11:11 PM, Toshi Kani wrote:
>>
>>> On Thu, 2013-09-12 at 13:00 +0800, Tang Chen wrote:
>>>> Hi Rafael, Toshi,
>>>>
>>>> When we hot-add an ACPI0004 device, we got the following warning:
>>>>
>>>> 	acpi ACPI0004:01: Attempt to re-insert
>>>>
>>>> The ACPI0004 device is a System Board in Fujitsu server, which has two
>>>> numa nodes (processors and memory).
>>>>
>>>> It seems that we reserved the ACPI_NOTIFY_DEVICE_CHECK event twice in
>>>> acpi_hotplug_notify_cb().
>>>>
>>>>
>>>> According to bisect, this happens after the following commit:
>>>>
>>>>  From 68a67f6c78b80525d9b3c6672e7782de95e56a83 Mon Sep 17 00:00:00 2001
>>>> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>>>> Date: Sun, 3 Mar 2013 23:05:55 +0100
>>>> Subject: [PATCH 1/1] ACPI / container: Use common hotplug code
>>>>
>>>> Switch the ACPI container driver to using common device hotplug code
>>>> introduced previously.  This reduces the driver down to a trivial
>>>> definition and registration of a struct acpi_scan_handler object.
>>>>
>>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>> Acked-by: Toshi Kani <toshi.kani@hp.com>
>>>> Tested-by: Toshi Kani <toshi.kani@hp.com>
>>>> ---
>>>>   drivers/acpi/container.c | 146 
>>>> ++++-------------------------------------------
>>>>   1 file changed, 10 insertions(+), 136 deletions(-)
>>>>
>>>>
>>>> I'm now investigating this problem. If you have any idea about why this
>>>> happens, please let me know.
>>>
>>> With the above change, container devices use the common notify handler,
>>> which logs the warning message in question when it receives device check
>>> twice on a same device.  Before the change, the container-specific
>>> notify handler did not log this message in the same case (but considered
>>> it as an eject request).
>>>
>>> So, I suspect that you are getting device check twice regardless of the
>>> kernel change.  Can you check KERN_DEBUG messages to see if that is the
>>> case?  The notify handler logs all events with KERN_DEBUG.
>>
>> Follow your suggestion, we confirm that it really received ACPI_NOTIFY_
>> DEVICE_CHECK event*twice*, but the original ACPI container driver only
>> received once, does the common device hotplug code introduce another device
>> check? any idea?
>>
>> Container uses common device hotplug code:
>> [  142.937724] IPv6: ADDRCONF(NETDEV_CHANGE): eth8: link becomes ready
>> [  674.975575] ACPI: \_SB_.LSB1: ACPI_NOTIFY_DEVICE_CHECK event          <<<<
> 
> acpi_hotplug_notify_cb() calls acpi_os_hotplug_execute() to schedule to
> run acpi_scan_device_check() asynchronously and returns immediately.
> This leads acpi_ev_asynch_enable_gpe() to run next, which clears this
> GPE (if level triggered) and re-enable GPE.

Thanks for your explanation, it's really the routine you mentioned above.

> 
>> [  674.991604] ACPI: \_SB_.LSB1: ACPI_NOTIFY_DEVICE_CHECK event		 <<<<	
> 
> It appears that re-enabling GPE caused this GPE to show up again as a
> spurious interrupt.

Yes, it is.

> 
>> [  675.613990] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus fd])
>> [  675.684970] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [  675.780957] acpi PNP0A03:01: Unable to request _OSC control (_OSC support mask: 0x08)
>> [  675.874806] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [  675.949005] pci_bus 0000:fd: Allocating resources
>> [  675.960145] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus fc])
>> [  676.031176] acpi PNP0A03:02: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [  676.127129] acpi PNP0A03:02: Unable to request _OSC control (_OSC support mask: 0x08)
>> [  676.220943] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [  676.295019] pci_bus 0000:fc: Allocating resources
>>
>> Original ACPI container driver:
>> [ 1526.122933] Container driver received ACPI_NOTIFY_DEVICE_CHECK event <<<<
> 
> In the original code, container_notify_cb() proceeds the device check
> handling and then calls _OST on the same thread.  It then re-enable GPE.

According to our debug, the whole routine was executed on the same thread.

> This ordering seems to avoid the spurious interrupt on your platform.

It seems that, but it is very strange.

> 
>> [ 1526.800646] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus fd])
>> [ 1526.871682] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [ 1526.967878] acpi PNP0A03:01: Unable to request _OSC control (_OSC support mask: 0x08)
>> [ 1527.061891] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [ 1527.136036] pci_bus 0000:fd: Allocating resources
>> [ 1527.150747] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus fc])
>> [ 1527.221821] acpi PNP0A03:02: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [ 1527.317738] acpi PNP0A03:02: Unable to request _OSC control (_OSC support mask: 0x08)
>> [ 1527.411795] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [ 1527.485917] pci_bus 0000:fc: Allocating resources
> 
> The GPE handler code in ACPICA is the same.  So, the issue could be due
> to either;
>  - The firmware expects _OST before re-enabling GPE, or
>  - The timing of re-enabling GPE was too soon on your platform.

Thanks for your directions.

> 
> Can you check with your firmware team to see if this might be the case?

I'll confirm this.

Best regards,
Gu

> 
> Thanks,
> -Toshi
> 
> 


