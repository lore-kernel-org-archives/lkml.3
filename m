Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3A0NiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:38:01 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:64527 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3A0Nh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:37:59 -0500
Message-ID: <51052DB2.4090702@googlemail.com>
Date: Sun, 27 Jan 2013 13:37:54 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yijing Wang <wangyijing0307@gmail.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com>
In-Reply-To: <51051B1B.3080105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/27/13 12:18, Yijing Wang wrote:
> 于 2013-01-27 19:19, Chris Clayton 写道:
>> Hi Yijing
>>
>> On 01/27/13 02:45, Yijing Wang wrote:
>>> 于 2013-01-27 4:54, Chris Clayton 写道:
>>>> Hi Martin,
>>>>
>>>> On 01/24/13 19:21, Martin Mokrejs wrote:
>>>>> Hi Chris,
>>>>>      try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
>>>>> them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.
>>>>>
>>>>
>>>> Thanks for the tip. I had the pciehp driver installed, but it was a module and not loaded. I didn't have acpiphp enabled at all. Building them both in statically, appears to have papered over the cracks of the oops :-)
>>>
>>> Not loaded pciehp driver? Remove the device from this slot without poweroff ?
>>>
>>
>> That's correct. When I first encountered the oops, I did not have the pciehp driver loaded and removing the device from the slot whilst the laptop was powered on resulted in the oops.
>
> Hmm, that's unsafe and dangerous, because device now may be running.
> There are two ways to trigger pci hot-add or hot-remove in linux, after loaded pciehp or acpiphp module
> (the two modules only one can loaded into system at the same time). You can trigger hot-add/hot-remove by
> sysfs interface under /sys/bus/pci/slots/[slot-name]/power or attention button on hardware (if your laptop supports that).
>

OK, thanks for the advice.

>>>>
>>>>>      The best would if you subscribe to linux-pci, and read my recent threads
>>>>> about similar issues I had with express cards with Dell Vostro 3550. Further, there is
>>>>> a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
>>>>> archives of linux-pci and see the pacthes and the discussion.
>>>>
>>>> Those discussions are way above my level of knowledge. I guess all this work will be merged into mainline in due course, so I'll watch for them in 3.9 or later. Unless, of course, there is a tree I could clone and help test the changes with my laptop and expresscard.
>>>>
>>>> Hotplug isn't working at all on my Fujitsu laptop, so I can only get the card recognised by rebooting with the card inserted (or by writing 1 to/sys/bus/pci/rescan). There seem to be a few reports on this in the kernel bugzilla, so I'll look through them and see what's being done.
>>>
>>> Hi Chris,
>>>      What about use #modprobe pciehp pciehp_debug=1 pciehp_poll_mode=1 pciehp_poll_time=1 ?
>>>
>>> Can you resend the dmesg log and "lspci -vvv" info after hotplug device from your Fujitsu laptop with above module parameters?
>>>
>>
>> I wasn't sure whether or not the pciehp driver should be loaded on its own or with the acpiphp driver also loaded. So I built them both as modules and planned to try both, pciehp only and acpiphp only. However, I've found that acpiphp will not load (regardless of whether or not pciehp is already loaded). What I get is:
>>
>> [chris:~]$ sudo modprobe acpiphp debug=1
>> modprobe: ERROR: could not insert 'acpiphp': No such device
>>
>
> Currently, If your hardware support pciehp native hotplug, acpiphp driver will be rejected when loading it in system
> (you can force loading it by add boot parameter pcie_aspm=off as Martin said).
>

OK, thanks again for the advice. I've disabled the acpiphp driver.

>> and at the end of the dmesg output I see:
>>
>> [   68.199789] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [   68.199970] acpiphp_glue: Total 0 slots
>>
>> The pciehp driver loads OK. I've attached pciehp-only which shows the dmesg and lscpi output that you asked for.
>>
>> As I said before, the only way that I can get the card detected with rebooting the laptop is to write 1 to /sys/bus/pci/rescan. In the hope that it might help (e.g. it shows details of the expresscard I'm using), I've also attached the output from dmesg and lspci after a rescan.
>
> In this case, i guess your slot maybe always power on, once you insert your pcie card, and use rescan intercace, you can find them.
>
> I checked the WinTV-HVR-1400 expressed card device's parent port device, as bellow.
> I found the powerctrl in slot cap is clear. So I doubt the hardware support pci hotplug.

Mmm, that's odd because I dual-boot Windows 7 on this laptop and when I 
plug it in under Windows 7, it appears in Device Manager and works 
perfectly.

>
> Chris, Can you try to add and remove device by /sys/bus/pci/slots/3/power? (use #modprobe pciehp pciehp_debug=1)
>
/sys/bus/pci/slots is empty:

[chris:~]$ ls -l /sys/bus/pci/slots/
total 0

Using Google, I find that the acpi slot detection driver should populate 
that directory. It is configured in and built into the kernel 
statically, so I don't know what's happening there.

By the way, there is also /sys/bus/pci_express directory:

[chris:~]$ ls -Rl /sys/bus/pci_express/
/sys/bus/pci_express/:
total 0
drwxr-xr-x 2 root root    0 Jan 27 12:52 devices/
drwxr-xr-x 3 root root    0 Jan 27 13:07 drivers/
-rw-r--r-- 1 root root 4096 Jan 27 13:07 drivers_autoprobe
--w------- 1 root root 4096 Jan 27 13:07 drivers_probe
--w------- 1 root root 4096 Jan 27 13:07 uevent

/sys/bus/pci_express/devices:
total 0

/sys/bus/pci_express/drivers:
total 0
drwxr-xr-x 2 root root 0 Jan 27 13:17 pciehp/

/sys/bus/pci_express/drivers/pciehp:
total 0
--w------- 1 root root 4096 Jan 27 13:36 bind
--w------- 1 root root 4096 Jan 27 13:17 uevent
--w------- 1 root root 4096 Jan 27 13:36 unbind

[chris:~]$ cat /sys/bus/pci_express/drivers_autoprobe
1

>
> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
>
> 	Bus: primary=00, secondary=02, subordinate=06, sec-latency=0
>
> 	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> 			ExtTag- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
> 			ClockPM- Surprise- LLActRep+ BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
> 			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
>
>>
>> Please let me know if I can provide any additional diagnostics.
>>
>
>
>
