Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3A1LU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:20:26 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:24478 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1LUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:20:23 -0500
Message-ID: <51065DC0.5080609@huawei.com>
Date: Mon, 28 Jan 2013 19:15:12 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065965.9010806@fold.natur.cuni.cz> <51065AA4.6000700@googlemail.com>
In-Reply-To: <51065AA4.6000700@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/28 19:01, Chris Clayton wrote:
> [no one screamed, so linux-media ml dropped]
> 
> Hi Martin,
> 
> On 01/28/13 10:56, Martin Mokrejs wrote:
>>
>>
>> Chris Clayton wrote:
>>> Hi Yijing,
>>>
>>> On 01/28/13 02:40, Yijing Wang wrote:
>>>> Hi Chris,
>>>>      Sorry for the delay reply. It seems like my reply last night was missed.
>>>>
>>>>   From the sysinfo you provide, there are no pcie port devices under /sys/bus/pci_express/devices.
>>>> Maybe because there are some problems with _OSC in your laptop, so pcie port driver won't create pcie port device
>>>> for hotplug, aer and so on.
>>>>
>>>> Maybe you can add boot parameter "pcie_ports=native" and reboot your laptop.
>>>> Then use #modprobe pciehp pciehp_force=1 pciehp_debug=1 to load pciehp modules.
>>>> After above actions, enter /sys/bus/pci_express/devices/ directory and /sys/bus/pci/slots/
>>>> Some slots and pcie port devices should be there now.
>>>>
>>> Sorry, I've tried your suggestion, but the two directories are still empty.
>>>
>>> I verified the test environment as follows:
>>>
>>> [chris:~]$ uname -a
>>> Linux laptop 3.7.4 #15 SMP PREEMPT Mon Jan 28 09:43:57 GMT 2013 i686 GNU/Linux
>>> [chris:~]$ grep acpiphp /boot/System.map-3.7.4
>>> [chris:~]$ modinfo acpiphp
>>> modinfo: ERROR: Module acpiphp not found.
>>> [chris:~]$ modinfo pciehp
>>> filename:       /lib/modules/3.7.4/kernel/drivers/pci/hotplug/pciehp.ko
>>> license:        GPL
>>> description:    PCI Express Hot Plug Controller Driver
>>> author:         Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>
>>> depends:
>>> intree:         Y
>>> vermagic:       3.7.4 SMP preempt mod_unload CORE2
>>> parm:           pciehp_detect_mode:Slot detection mode: pcie, acpi, auto
>>>    pcie          - Use PCIe based slot detection
>>>    acpi          - Use ACPI for slot detection
>>>    auto(default) - Auto select mode. Use acpi option if duplicate
>>>                    slot ids are found. Otherwise, use pcie option
>>>   (charp)
>>> parm:           pciehp_debug:Debugging mode enabled or not (bool)
>>> parm:           pciehp_poll_mode:Using polling mechanism for hot-plug events or not (bool)
>>> parm:           pciehp_poll_time:Polling mechanism frequency, in seconds (int)
>>> parm:           pciehp_force:Force pciehp, even if OSHP is missing (bool)
>>> [chris:~]$ cat /proc/cmdline
>>> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6

Oh, should "pcie_ports=native" not "pciehp_ports=native".


>>> [chris:~]$ sudo modprobe pciehp pciehp_force=1 pciehp_debug=1
>>> [chris:~]$ lsmod
>>> Module                  Size  Used by
>>> pciehp                 19907  0
>>> [...]
>>>
>>> You will notice that the kernel I have used is 3.7.4. I hope that's a suitable kernel for your tests. I've moved away from the 3.8 development kernel onto one that's stable and on which Martin has identified a solution. I see Greg KH released 3.7.5 yesterday and it includes a pciehp change. I'll upgrade to that, run the tests again and report back.
>>>
>>> One question - should I include the (acpi) pci_slot driver in the kernel build or does pciehp populate the directories without pci_slot?
>>
>> Hi Chris,
>>    I am not a kernel developer but from the other threads at linux-pci I gathered there are in some
>> scenarios problems with improper loading of the hotplug modules. Therefore, the patches floating
>> now around are to disable hotplug module availability. Therefore, I suggested you to try only
>> only static kernel support for hotplug. That way you don't hit the issue. That is for sure not
>> addressed in 3.7.5, seems that it is probably in -next.
>> Martin
>>
> In a few minutes I'll be sending out another reply to Yijing's suggestions because I noticed a typo in the parameter I added to the kernel command line. I'm now going back through email to remember why we were trying to get those /sys/bus/pci... directories populated.
> 
> Watch this space! :-)
> Chris
> 
> 
> .
> 


-- 
Thanks!
Yijing

