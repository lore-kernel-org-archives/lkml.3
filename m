Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3A1KMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:12:53 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62823 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3A1KMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:12:49 -0500
Message-ID: <51064F1A.1020909@googlemail.com>
Date: Mon, 28 Jan 2013 10:12:42 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing0307@gmail.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com>
In-Reply-To: <5105E51D.2020606@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing,

On 01/28/13 02:40, Yijing Wang wrote:
> Hi Chris,
>     Sorry for the delay reply. It seems like my reply last night was missed.
>
>  From the sysinfo you provide, there are no pcie port devices under /sys/bus/pci_express/devices.
> Maybe because there are some problems with _OSC in your laptop, so pcie port driver won't create pcie port device
> for hotplug, aer and so on.
>
> Maybe you can add boot parameter "pcie_ports=native" and reboot your laptop.
> Then use #modprobe pciehp pciehp_force=1 pciehp_debug=1 to load pciehp modules.
> After above actions, enter /sys/bus/pci_express/devices/ directory and /sys/bus/pci/slots/
> Some slots and pcie port devices should be there now.
>
Sorry, I've tried your suggestion, but the two directories are still empty.

I verified the test environment as follows:

[chris:~]$ uname -a
Linux laptop 3.7.4 #15 SMP PREEMPT Mon Jan 28 09:43:57 GMT 2013 i686 
GNU/Linux
[chris:~]$ grep acpiphp /boot/System.map-3.7.4
[chris:~]$ modinfo acpiphp
modinfo: ERROR: Module acpiphp not found.
[chris:~]$ modinfo pciehp
filename:       /lib/modules/3.7.4/kernel/drivers/pci/hotplug/pciehp.ko
license:        GPL
description:    PCI Express Hot Plug Controller Driver
author:         Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman 
<greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>
depends:
intree:         Y
vermagic:       3.7.4 SMP preempt mod_unload CORE2
parm:           pciehp_detect_mode:Slot detection mode: pcie, acpi, auto
   pcie          - Use PCIe based slot detection
   acpi          - Use ACPI for slot detection
   auto(default) - Auto select mode. Use acpi option if duplicate
                   slot ids are found. Otherwise, use pcie option
  (charp)
parm:           pciehp_debug:Debugging mode enabled or not (bool)
parm:           pciehp_poll_mode:Using polling mechanism for hot-plug 
events or not (bool)
parm:           pciehp_poll_time:Polling mechanism frequency, in seconds 
(int)
parm:           pciehp_force:Force pciehp, even if OSHP is missing (bool)
[chris:~]$ cat /proc/cmdline
root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
[chris:~]$ sudo modprobe pciehp pciehp_force=1 pciehp_debug=1
[chris:~]$ lsmod
Module                  Size  Used by
pciehp                 19907  0
[...]

You will notice that the kernel I have used is 3.7.4. I hope that's a 
suitable kernel for your tests. I've moved away from the 3.8 development 
kernel onto one that's stable and on which Martin has identified a 
solution. I see Greg KH released 3.7.5 yesterday and it includes a 
pciehp change. I'll upgrade to that, run the tests again and report back.

One question - should I include the (acpi) pci_slot driver in the kernel 
build or does pciehp populate the directories without pci_slot?

Thanks again.

> /sys/bus/pci_express/devices:
> total 0
>
> /sys/bus/pci_express/drivers:
> total 0
> drwxr-xr-x 2 root root 0 Jan 27 13:17 pciehp/
>
>
> On 2013/1/28 6:53, Chris Clayton wrote:
>> Thanks again, Martin.
>>
>> Firstly, maybe we should remove the linux-media list from the copy list. I imagine this hotplug stuff is just noise to them.
>>
>> [snip]
>>> Do you have any other express card around to try if it works at all? Try that always after a cold boot.
>>>
>> Not at the moment, but I ordered at USB3 expresscard yesterday, so I will have one soon.
>>
>>> Posting a diff result of the below procedure might help:
>>>
>>> # lspci -vvvxxx > lspci.before_insertion.txt
>>>
>>> [plug your card into the slot]
>>>
>>> # lspci -vvvxxx > lspci.after_insertion.txt
>>>
>>> [ unplug your card]
>>>
>>> # lspci -vvvxxx > lspci.after_1st_removal.txt
>>>
>>> [re-plug your card into the slot]
>>>
>>> # lspci -vvvxxx > lspci.after_1st_re-insertion.txt
>>>
>>> [ unplug your card]
>>>
>>> # lspci -vvvxxx > lspci.after_2nd_removal.txt
>>>
>>
>> OK, I've been using kernel 3.8.0-rc kernels so far, but given that is still under development, I've switched to 3.7.4, mainly because you are having success with 3.7.x, acpiphp and pcie_aspm=off. I verified the environment as follows:
>>
>> [chris:~]$ cat /proc/cmdline
>> root=/dev/sda5 pcie_aspm=off ro resume=/dev/sda6
>> [chris:~]$ dmesg | grep ASPM
>> [    0.000000] PCIe ASPM is disabled
>> [    0.348959]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [chris:~]$ dmesg | grep acpiphp
>> [    0.400846] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [chris:~]$ dmesg | grep pciehp
>> [chris:~]$ uname -a
>> Linux laptop 3.7.4 #13 SMP PREEMPT Sun Jan 27 18:39:39 GMT 2013 i686 GNU/Linux
>>
>>
>>> Then compare them using diff. These should have no difference:
>>>
>>> diff lspci.after_insertion.txt lspci.after_1st_re-insertion.txt
>>> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
>>>
>> Correct, there were no differences.
>>
>>>
>>> These may have only little difference, or none:
>>>
>>> diff lspci.before_insertion.txt lspci.after_1st_removal.txt
>>
>> 263c263
>> <               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
>> ---
>>   >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>> 265c265
>> <               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
>> ---
>>   >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>> 267c267
>> <               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>> ---
>>   >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
>> 273c273
>> <                       Changed: MRL- PresDet- LinkState-
>> ---
>>   >                       Changed: MRL- PresDet- LinkState+
>> 295,296c295,296
>> < 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
>> < 50: 03 00 01 10 60 b2 1c 00 08 00 00 00 00 00 00 00
>> ---
>>   > 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
>>   > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
>>
>>> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
>>>
>> No difference.
>>>
>>>
>>> Finally, these should confirm whether the PresDet works for you (for me NOT with pciehp but does work with acpiphp).
>>> You should see PresDet- to PresDet+ changes in:
>>>
>> Yes, I do see the PresDet- to PresDet+ changes
>>
>>> diff lspci.before_insertion.txt lspci.after_insertion.txt
>>
>> 263c263
>> <               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
>> ---
>>   >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>> 265c265
>> <               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
>> ---
>>   >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>> 267c267
>> <               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>> ---
>>   >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>> 272,273c272,273
>> <               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>> <                       Changed: MRL- PresDet- LinkState-
>> ---
>>   >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>   >                       Changed: MRL- PresDet- LinkState+
>> 295,296c295,296
>> < 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
>> < 50: 03 00 01 10 60 b2 1c 00 08 00 00 00 00 00 00 00
>> ---
>>   > 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
>>   > 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
>>
>>> diff lspci.after_1st_removal.txt lspci.after_1st_re-insertion.txt
>> 267c267
>> <               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
>> ---
>>   >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>> 272c272
>> <               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>> ---
>>   >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>> 296c296
>> < 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
>> ---
>>   > 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
>>
>>>
>>> You should see PresDet+ to PresDet- changes in:
>> Yes, I see those changes too.
>>> diff lspci.after_insertion.txt lspci.after_1st_removal.txt
>> 267c267
>> <               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>> ---
>>   >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
>> 272c272
>> <               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>> ---
>>   >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>> 296c296
>> < 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
>> ---
>>   > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
>>
>>> diff lspci.after_1st_re-insertion.txt lspci.after_2nd_removal.txt
>> 267c267
>> <               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>> ---
>>   >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
>> 272c272
>> <               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>> ---
>>   >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>> 296c296
>> < 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
>> ---
>>   > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
>>>
>>> I did plenty of these with my laptop using 3.3.x and 3.7.1 and the conclusion was
>>> that pciehp got broken since some 3.6? (commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a)
>>> but I can live on 3.7.x with acpiphp and pcie_aspm=off.
>>
>> I could live with that too, but despite my findings being in line with your predictions, hotplug does not work for me.
>>
>>> The above test could tell you what
>>> works in your case. Of course, you can try separately pciehp and acpiphp. With 3.4
>>> series I lived with pciehp and pcie_aspm=force.
>> Need sleep now, but tomorrow, I'll build a 3.4 kernel and try pciehp and pcie_aspm=force.
>>>
>>> Martin
>>> BTW: Re-post your dmesg output so that we can see if you those OSC errors
>>> (for details see "Re: Dell Vostro 3550: pci_hotplug+acpiphp require 'pcie_aspm=force' on kernel command-line for hotplug to work" thread).
>>>
>> I've attached a file containing the output from dmesg. I does contain errors related to OSC.
>>
>
>
