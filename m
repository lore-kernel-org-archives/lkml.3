Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3A1LRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:17:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:25177 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3A1LRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:17:44 -0500
Message-ID: <510659CD.4090400@huawei.com>
Date: Mon, 28 Jan 2013 18:58:21 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing0307@gmail.com>, <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com>
In-Reply-To: <51064F1A.1020909@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Then use #modprobe pciehp pciehp_force=1 pciehp_debug=1 to load pciehp modules.
>> After above actions, enter /sys/bus/pci_express/devices/ directory and /sys/bus/pci/slots/
>> Some slots and pcie port devices should be there now.
>>
> Sorry, I've tried your suggestion, but the two directories are still empty.
> 
> I verified the test environment as follows:
> 
> [chris:~]$ uname -a
> Linux laptop 3.7.4 #15 SMP PREEMPT Mon Jan 28 09:43:57 GMT 2013 i686 GNU/Linux
> [chris:~]$ grep acpiphp /boot/System.map-3.7.4
> [chris:~]$ modinfo acpiphp
> modinfo: ERROR: Module acpiphp not found.
> [chris:~]$ modinfo pciehp
> filename:       /lib/modules/3.7.4/kernel/drivers/pci/hotplug/pciehp.ko
> license:        GPL
> description:    PCI Express Hot Plug Controller Driver
> author:         Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>
> depends:
> intree:         Y
> vermagic:       3.7.4 SMP preempt mod_unload CORE2
> parm:           pciehp_detect_mode:Slot detection mode: pcie, acpi, auto
>   pcie          - Use PCIe based slot detection
>   acpi          - Use ACPI for slot detection
>   auto(default) - Auto select mode. Use acpi option if duplicate
>                   slot ids are found. Otherwise, use pcie option
>  (charp)
> parm:           pciehp_debug:Debugging mode enabled or not (bool)
> parm:           pciehp_poll_mode:Using polling mechanism for hot-plug events or not (bool)
> parm:           pciehp_poll_time:Polling mechanism frequency, in seconds (int)
> parm:           pciehp_force:Force pciehp, even if OSHP is missing (bool)
> [chris:~]$ cat /proc/cmdline
> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
> [chris:~]$ sudo modprobe pciehp pciehp_force=1 pciehp_debug=1
> [chris:~]$ lsmod
> Module                  Size  Used by
> pciehp                 19907  0
> [...]
> 
> You will notice that the kernel I have used is 3.7.4. I hope that's a suitable kernel for your tests. I've moved away from the 3.8 development kernel onto one that's stable and on which Martin has identified a solution. I see Greg KH released 3.7.5 yesterday and it includes a pciehp change. I'll upgrade to that, run the tests again and report back.
> 
> One question - should I include the (acpi) pci_slot driver in the kernel build or does pciehp populate the directories without pci_slot?

Hi Chris,
   pci_slot driver is not necessary, I think empty directory under /sys/bus/pci_express/devices is the main problem,
Because no pcie port devices found in the system, so pciehp driver can not bind any devices when loading it.
Then no slot will created under /sys/bus/pci/devices/slots.

> 
> Thanks again.
> 
>> /sys/bus/pci_express/devices:
>> total 0
>>
>> /sys/bus/pci_express/drivers:
>> total 0
>> drwxr-xr-x 2 root root 0 Jan 27 13:17 pciehp/
>>
>>
>> On 2013/1/28 6:53, Chris Clayton wrote:
>>> Thanks again, Martin.
>>>
>>> Firstly, maybe we should remove the linux-media list from the copy list. I imagine this hotplug stuff is just noise to them.
>>>
>>> [snip]
>>>> Do you have any other express card around to try if it works at all? Try that always after a cold boot.
>>>>
>>> Not at the moment, but I ordered at USB3 expresscard yesterday, so I will have one soon.
>>>
>>>> Posting a diff result of the below procedure might help:
>>>>
>>>> # lspci -vvvxxx > lspci.before_insertion.txt
>>>>
>>>> [plug your card into the slot]
>>>>
>>>> # lspci -vvvxxx > lspci.after_insertion.txt
>>>>
>>>> [ unplug your card]
>>>>
>>>> # lspci -vvvxxx > lspci.after_1st_removal.txt



-- 
Thanks!
Yijing

