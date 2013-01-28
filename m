Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3A1VCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:02:46 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:46262 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753243Ab3A1VCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:02:44 -0500
Message-ID: <5106E770.9070602@fold.natur.cuni.cz>
Date: Mon, 28 Jan 2013 22:02:40 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com>
In-Reply-To: <5106CD6C.4070009@googlemail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Clayton wrote:
> Hi Martin,
> 
> On 01/28/13 12:12, Martin Mokrejs wrote:
>> Chris Clayton wrote:
>>>
>>> [snip]
>>>
>>>> [chris:~]$ cat /proc/cmdline
>>>> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
>>>                       ^^
>>>                    **typo**
>>> I've run the test again with pcie_ports=native and the directories now get populated. Even better though, is that when I plug in the card, hotplug **works** and the card's drivers are loaded.
>>
>> BTW, I have with acpiphp on 3.7.4:
>>
>> ls -la /sys/bus/pci_express/devices
>> total 0
>> drwxr-xr-x 2 root root 0 Jan 28 13:07 .
>> drwxr-xr-x 4 root root 0 Jan 28 13:07 ..
>> $ ls -la /sys/bus/pci/devices/slots
>                        ^^^^^^^^
>                         **typo**
> It should be /sys/bus/pci/slots.
> 
>> ls: cannot access /sys/bus/pci/devices/slots: No such file or directory
>> $
>>
> With acpiphp, I get /sys/bus/pci_express/devices populated but /sys/bus/pci/slots is empty.

OK, I haven't realized the typo, but I have here with acpiphp:

# ls -laR /sys/bus/pci/slots
/sys/bus/pci/slots:
total 0
drwxr-xr-x 3 root root 0 Jan 27 17:14 .
drwxr-xr-x 5 root root 0 Jan 25 15:56 ..
drwxr-xr-x 2 root root 0 Jan 27 17:14 1

/sys/bus/pci/slots/1:
total 0
drwxr-xr-x 2 root root    0 Jan 27 17:14 .
drwxr-xr-x 3 root root    0 Jan 27 17:14 ..
-r--r--r-- 1 root root 4096 Jan 28 21:31 adapter
-r--r--r-- 1 root root 4096 Jan 27 17:14 address
-rw-r--r-- 1 root root 4096 Jan 28 21:31 attention
-r--r--r-- 1 root root 4096 Jan 28 21:31 cur_bus_speed
-r--r--r-- 1 root root 4096 Jan 28 21:31 latch
-r--r--r-- 1 root root 4096 Jan 28 21:31 max_bus_speed
lrwxrwxrwx 1 root root    0 Jan 28 21:31 module -> ../../../../module/acpiphp
-rw-r--r-- 1 root root 4096 Jan 28 21:31 power
#

> 
>> And for me hotplug also works (as far as I can tell). ;-)
>>
>>>
>>> Excellent! Thank you so much for your help (and patience) Martin and Yijing.
>>>
>>> Now to solving why running scandvb doesn't find any TV channels.
>>
>> Would be fine if you could re-do the PresDet checks and confirm whether it is also broken
>> for you under pciehp.
>
> I've struggled with this a little. For some reason, the expresscard
> doesn't always stay properly inserted in the slot when I insert it.
> Now that hotplug is working, the modules are being loaded and when
> the card pops out again, I get an oops because, of course, the driver
> is running and the card disappears. Perhaps the driver can be made a
> bit more robust to sudden disappearance of the card. I'll report the

Yes, I had or maybe still have same issues here. I used to get an Oops
for sata_sil24 card weird behavior for USB3.0 NEC-based card. It was
fine always for a VIA-based firewire card and serial PL2303-based one.
I found out it is better if a usb device is connected to the USB card
because if that slips out then the libata layer quickly realizes that.
If there was no device connected, the usb waits too long before it removes
the usb hub from the system. And if you plugin the card meanwhile
back into the slot, weird thing happen.


> oops later. Anyway, to run these tests I built a kernel without the
> dvb card's drivers, effectively simulating the situation I had before
> Yijing got hotplug working for me. The card popping out may also have
> affected these diffs a bit because, for example, the first one has
> the CorrErr flag changed, possibly because I had to have two or more
> goes at getting the card to lock in the slot. Yesterday that diff
> showed no changes. Anyway, here are the diffs:
> 
> diff lspci.after_insertion.txt lspci.after_1st_re-insertion.txt
> 262c262
> <               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> ---
>>               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 295c295
> < 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
> ---
>> 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 04
> 
> ============================================================
> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
> 
> <no difference>

BTW, with the NEC-based card only after every second removal of the card I got
into PresDet- state. So, on every other diff attempt you won't see a difference!
But we are talking about acpiphp here (unlike pciehp) and with that I also 
have no problems.

> 
> =============================================================
> diff lspci.before_insertion.txt lspci.after_1st_removal.txt
> 112c112
> < 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 08 c0
> ---
>> 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 00 c0
> 262,263c262,263
> <               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> <               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
> ---
>>               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
> 265c265
> <               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
> ---
>>               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 267c267
> <               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> ---
>>               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
> 273c273
> <                       Changed: MRL- PresDet- LinkState-
> ---
>>                       Changed: MRL- PresDet- LinkState+
> 295,296c295,296
> < 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
> < 50: 03 00 01 10 60 b2 1c 00 28 00 00 00 00 00 00 00
> ---
>> 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 04
>> 50: 40 00 11 50 60 b2 1c 00 28 00 00 01 00 00 00 00


I think this is what I also reported earlier that on the "Changed:" line the LinkState is not updated
always, contrary to the PresDet. That is present since kernel 3.4 times at least.


> 
> ===========================================================
> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
> 
> <no difference>

Yeah, try pciehp and see that the PresDet+ won't be flipped to PresDet-.
;-) You will have to plugin the card once more in and then pull out
to get to PresDet- state.


I deleted the rest, I think acpiphp just works for you, if statically compiled into the
kernel. ;-) Trying to proof that there are untested combinations and orders of module loadings
leading sometime to a broken setup does not seem at the very moment to be useful. Seems pci devs
know about that and rather decided to disable building of modules altogether.

The pciehp behavior is still another story and I would be really curious if it works for you.
For me, the PresDet did not work, I think ever, on this SandyBridge hardware.

Martin
