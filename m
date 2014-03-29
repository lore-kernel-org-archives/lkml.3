Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaC2HLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 03:11:51 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:62919 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaC2HLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 03:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
	<CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
	<CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
Date: Sat, 29 Mar 2014 00:11:48 -0700
X-Google-Sender-Auth: MEM6g4zf149lZ_hwo4zgugEU4IU
Message-ID: <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
From: Yinghai Lu <yinghai@kernel.org>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 6:55 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>> Can you send out whole boot log (include init booting and from resume) and
>> lspci -tv and lspci -vvxxxx ?
>
> lspci -tv
> -----------
> ~# lspci -tv
> -[0000:00]-+-00.0  Intel Corporation Xeon E3-1200 v3 Processor DRAM Controller
>            +-02.0  Intel Corporation Xeon E3-1200 v3 Processor
> Integrated Graphics Controller
>            +-03.0  Intel Corporation Xeon E3-1200 v3/4th Gen Core
> Processor HD Audio Controller
>            +-14.0  Intel Corporation 8 Series/C220 Series Chipset
> Family USB xHCI
>            +-16.0  Intel Corporation 8 Series/C220 Series Chipset
> Family MEI Controller #1
>            +-16.3  Intel Corporation 8 Series/C220 Series Chipset
> Family KT Controller
>            +-19.0  Intel Corporation Ethernet Connection I217-LM
>            +-1a.0  Intel Corporation 8 Series/C220 Series Chipset
> Family USB EHCI #2
>            +-1b.0  Intel Corporation 8 Series/C220 Series Chipset High
> Definition Audio Controller
>            +-1c.0-[01]--
>            +-1c.3-[02-03]----00.0-[03]--
>            +-1c.4-[04-3c]--
>            +-1d.0  Intel Corporation 8 Series/C220 Series Chipset
> Family USB EHCI #1
>            +-1f.0  Intel Corporation C226 Series Chipset Family Server
> Advanced SKU LPC Controller
>            +-1f.2  Intel Corporation 8 Series/C220 Series Chipset
> Family 6-port SATA Controller 1 [AHCI mode]
>            \-1f.3  Intel Corporation 8 Series/C220 Series Chipset
> Family SMBus Controller
>
> lspci -vvxxxx and dmesg output are kind of big, so attached.

Hi, Parag,

For the boot path, kernel is right.
BIOS does not assign resource for
00:1c.0, (io, mmio, mmio pref), 00:1c.3(io, mmio, mmio pref), 00:1c.4 (io).

but 00:1c.0 00:1c.4 support hotplug either in acpiphp or pcie slot cap.

[    0.263398] acpiphp: Slot [1] registered
[    0.263405] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.263884] acpiphp: Slot [1-1] registered
[    0.263891] pci 0000:00:1c.4: PCI bridge to [bus 04-3c]

so kernel assign new resource to them.

[    0.281764] pci 0000:00:1c.0: BAR 14: assigned [mem 0x9f200000-0x9f3fffff]
[    0.281768] pci 0000:00:1c.0: BAR 15: assigned [mem
0x9f400000-0x9f5fffff 64bit pref]
[    0.281770] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.281771] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]

but 00:1c.3 ==> 02:00.0 (bus 03) does not support hotplug.
so kernel does not assign resource 00:1c.3.

Later during resuming, kernel try to assign resource 02:00.0 but it will fail
as parent bridge 00:1c.3 has no resource.
(Not sure how pci_configure_slot get called with this resume path).

so you will have

[11548.934659] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[11548.934661] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
[11548.934662] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
[11548.934664] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[11548.934666] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
[11548.934667] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
