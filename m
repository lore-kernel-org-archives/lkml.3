Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbaISPEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:04:39 -0400
Received: from services.gouders.net ([141.101.32.176]:36098 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaISPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:04:37 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 12 Sep 2014 18:59:23 -0700")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
	<CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 19 Sep 2014 17:03:26 +0200
Message-ID: <ghwq8zzm81.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Sep 12, 2014 at 5:11 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>> Yes, I skip them in pci_scan_device() to get the unused bus number space
>> that 0a.0 and 0b.0 then can use when reconfiguration is triggered.
>
> That is not right. Can not let two bridges use same bus num.
>
>>
>>> Proper simulation could be:
>>> 1. remove 07:00.0
>>>     echo 1 > /sys/bus/pci/devices/0000:07:00.0/remove
>>> 2. change bus range in 00:0a.0 bus
>>>     setpci -s 00:0a.0 0x1c.l=0x00101000
>>> 3. remove 00:0a.0
>>>     echo 1 > /sys/bus/pci/devices/0000:00:0a.0/remove
>>> 4. rescan pci
>>>     echo 1 > /sys/bus/pci/rescan
>>> 5. reset pcie link from 00:0a.0
>>>     setpci -s 00:0a.0 0xc0.b=0x18
>>>     sleep 1s
>>>     setpci -s 00:0a.0 0xc0.b=0x08
>>> 6. rescan pci bus
>>>     echo 1 > /sys/bus/pci/rescan
>>
>> OK, I did that (with 3.16) but the reconfiguration code doesn't
>> get triggered.  Here is what dmesg and lspci -tv say:
>
> 2 should be
>    setpci -s 00:0a.0 0x18.l=0x00101000

I'm very sorry for the late test result, Yinghai, I totally overlooked
this correction.

I'm not sure if it is still of interest but
I now tried these corrected commands on the test machine with a vanilla
3.16 kernel.  The FC adapter disappears but I cannot see the 

"bridge configuration invalid ..., reconfiguring" message,

so I assume that the test situation is still not exactly matching that
on the vx50 or am I missing something?

lspci before and lspci + dmesg after above commands attached.

Dirk

- lspci before ---------------------------------------------------------
-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-08.0-[05]--
           +-09.0-[06]--
           +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
           +-0b.0-[08]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control

- lspci after ----------------------------------------------------------
-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-08.0-[05]--
           +-09.0-[06]--
           +-0a.0-[10]--
           +-0b.0-[08]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control

- dmesg after ----------------------------------------------------------
[  214.234819] pci_bus 0000:07: busn_res: [bus 07] is released
[  214.234981] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  214.235037] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[  214.235128] pci 0000:00:0a.0: System wakeup disabled by ACPI
[  214.235221] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  214.235227] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  214.235258] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  214.235262] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  214.235295] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  214.235301] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  214.235306] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  214.235312] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  214.235316] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  214.235343] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  214.235348] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  214.235352] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  214.235376] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  214.235381] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  214.235386] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  214.235390] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  214.235394] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  214.235398] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  214.235402] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  214.235407] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  214.235411] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  214.235415] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  214.235420] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 10-10] behind bridge, pass 0
[  214.235457] pci_scan_child_bus: pci_bus 0000:10: scanning bus
[  214.235461] pci_scan_child_bus: pci_bus 0000:10: fixups for bus
[  214.235464] pci 0000:00:0a.0: PCI bridge to [bus 10]
[  214.235470] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[  214.235475] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[  214.235480] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[  214.235483] pci_scan_child_bus: pci_bus 0000:10: bus scan returning with max=10
[  214.235487] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  214.235493] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  214.235498] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  214.235503] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  214.235508] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  214.235513] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  214.235518] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 10-10] behind bridge, pass 1
[  214.235522] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=10
[  214.235567] pci 0000:00:0a.0: BAR 8: assigned [mem 0x80000000-0x802fffff]
[  214.235574] pci 0000:00:0a.0: BAR 9: assigned [mem 0x280000000-0x2800fffff 64bit pref]
[  214.235579] pci 0000:00:0a.0: BAR 7: assigned [io  0x1000-0x3fff]
[  214.235583] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  214.235592] pci 0000:00:06.0: PCI bridge to [bus 03]
[  214.235599] pci 0000:00:0a.0: PCI bridge to [bus 10]
[  214.235603] pci 0000:00:0a.0:   bridge window [io  0x1000-0x3fff]
[  214.235607] pci 0000:00:0a.0:   bridge window [mem 0x80000000-0x802fffff]
[  214.235610] pci 0000:00:0a.0:   bridge window [mem 0x280000000-0x2800fffff 64bit pref]
[  214.235622] fixup_debug_start: pci 0000:00:0a.0: calling quirk_msi_ht_cap+0x0/0x50
[  214.235627] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[  215.257656] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  215.257713] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  215.257720] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  215.257750] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  215.257755] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  215.257788] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  215.257793] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  215.257798] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  215.257803] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  215.257807] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  215.257834] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  215.257839] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  215.257843] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  215.257867] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  215.257872] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  215.257876] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  215.257880] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  215.257884] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  215.257889] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  215.257893] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  215.257897] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  215.257901] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  215.257905] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  215.257910] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 10-10] behind bridge, pass 0
[  215.257914] pci_scan_child_bus: pci_bus 0000:10: scanning bus
[  215.257918] pci_scan_child_bus: pci_bus 0000:10: bus scan returning with max=10
[  215.257922] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  215.257928] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  215.257933] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  215.257938] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  215.257942] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  215.257947] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  215.257952] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 10-10] behind bridge, pass 1
[  215.257956] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=10
[  215.257994] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  215.258033] pci 0000:00:06.0: PCI bridge to [bus 03]
