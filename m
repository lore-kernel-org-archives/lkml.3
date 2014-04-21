Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaDUQyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:54:21 -0400
Received: from numascale.com ([213.162.240.84]:36794 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaDUQyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:54:19 -0400
Message-ID: <53554D27.1010803@numascale.com>
Date: Tue, 22 Apr 2014 00:53:59 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@gmail.com>
CC: Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, hpa@zytor.com, x86 <x86@kernel.org>,
        sp@numascale.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] PCI: Remove redundant 'quirk_amd_nb_node'
References: <20140419025308.2408.51252.stgit@amt.stowe>	<20140419025345.2408.99229.stgit@amt.stowe>	<20140420105419.GB19676@pd.tnic> <CAL-B5D1_fns=mu7Cw6jeVHO0XPeKYakUrPv-JgO=ma1rjCoQvg@mail.gmail.com>
In-Reply-To: <CAL-B5D1_fns=mu7Cw6jeVHO0XPeKYakUrPv-JgO=ma1rjCoQvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Myron,

On 04/20/2014 09:44 PM, Myron Stowe wrote:
> On Sun, Apr 20, 2014 at 4:54 AM, Borislav Petkov <bp@suse.de> wrote:
>> On Fri, Apr 18, 2014 at 08:53:46PM -0600, Myron Stowe wrote:
>>> With the amd_bus.c updates to support additional AMD processors (11h, 12h,
>>> 14h 15h  and 16h) 'quirk_amd_nb_node' seems to be redundant.  This patch
>>> removes it.
>>>
>>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>>
>> Good idea. Has this been tested, though? There are a bunch of places
>> using dev_to_node() which this quirk corrects, especially 'local_cpus'
>> in a bunch of sysfs nodes in the PCI hierarchy /sys/devices/pci*.
>
> Borislav:
>
> Thanks for the review, suggestions, and comments.
>
> Just and FYI - I'll be gone until late in this coming week on a
> backpacking trip in remote Utah.  I'll work your suggestions when I
> get back.
>
> With respect to this patch and testing.  Yes, I did test and it worked
> for my situation.  I would like to hear from Daniel as I'm not exactly
> sure what his last change was specific to.
>
> Daniel: with the previous patches in this series applied do you still
> need this quirk for your situation?

It's fine enough for us, since we'll always emit a PXM method for any 
PCI host bridges (but roots), which gets correctly preserved with your 
patches [1]. I don't have reason to suspect northbridges at bus 0, 
devices 0x19 and later in each PCI domain having the wrong NUMA node is 
going to cause any issues.

We could improve things by changing probe_pci_hostbridge to iterate all 
PCI bus domains, but it's probably not a big deal to bail with one 
warning, as we currently see multiple (which would become a lot on most 
of our systems):

[    3.155974] AMD-Bus: TOM: 00000000d8000000 aka 3456M
[    3.160003]
[    3.161496] AMD-Bus: WARNING: Failed to find root info for node 0x4, 
link 0x0
[    3.168625]
[    3.170002]
[    3.171492] AMD-Bus: WARNING: Failed to find root info for node 0x4, 
link 0x0
[    3.178614] AMD-Bus: WARNING: Failed to find root info for node 0x4, 
link 0x0
[    3.180003] AMD-Bus: TOM2: 0000001900000000 aka 102400M

Thanks,
   Daniel

-- [1] (two server NumaConnect system)

# lspci
0000:00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 
Northbridge only dual slot (2x16) PCI-e GFX Hydra part (rev 02)
0000:00:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 
PCI to PCI bridge (external gfx1 port B)
0000:00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
0000:00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
0000:00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0 USB OHCI1 Controller
0000:00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB EHCI Controller
0000:00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
0000:00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0 USB OHCI1 Controller
0000:00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB EHCI Controller
0000:00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus 
Controller (rev 3d)
0000:00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 IDE Controller
0000:00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 LPC host controller
0000:00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 
PCI to PCI Bridge
0000:00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
0000:00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0000:00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0000:00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0000:00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0000:00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0000:00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0000:00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0000:00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0000:00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0000:00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0000:00:19.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0000:00:19.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0000:00:1a.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0000:00:1a.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0000:00:1a.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0000:00:1a.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0000:00:1a.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0000:00:1a.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0000:00:1b.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0000:00:1b.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0000:00:1b.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0000:00:1b.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0000:00:1b.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0000:00:1b.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0000:00:1c.0 Host bridge: Numascale AS NumaChip N601 (rev 02)
0000:00:1c.1 Host bridge: Numascale AS NumaChip N602 (rev 02)
0000:01:04.0 VGA compatible controller: Matrox Electronics Systems Ltd. 
MGA G200eW WPCM450 (rev 0a)
0000:02:00.0 Ethernet controller: Intel Corporation 82576 Gigabit 
Network Connection (rev 01)
0000:02:00.1 Ethernet controller: Intel Corporation 82576 Gigabit 
Network Connection (rev 01)
0001:00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 
Northbridge only dual slot (2x16) PCI-e GFX Hydra part (rev 02)
0001:00:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 
PCI to PCI bridge (external gfx1 port B)
0001:00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
0001:00:14.0 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 
SMBus Controller (rev 3d)
0001:00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 
PCI to PCI Bridge
0001:00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0001:00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0001:00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0001:00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0001:00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0001:00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0001:00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0001:00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0001:00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0001:00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0001:00:19.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0001:00:19.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0001:00:1a.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0001:00:1a.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0001:00:1a.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0001:00:1a.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0001:00:1a.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0001:00:1a.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0001:00:1b.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 0
0001:00:1b.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 1
0001:00:1b.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 2
0001:00:1b.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 3
0001:00:1b.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 4
0001:00:1b.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h 
Processor Function 5
0001:00:1c.0 Host bridge: Numascale AS NumaChip N601 (rev 02)
0001:00:1c.1 Host bridge: Numascale AS NumaChip N602 (rev 02)
0001:02:00.0 Ethernet controller: Intel Corporation 82576 Gigabit 
Network Connection (rev 01)
0001:02:00.1 Ethernet controller: Intel Corporation 82576 Gigabit 
Network Connection (rev 01)

# find /sys/devices/pci* -name numa_node -print -exec cat {} \;
/sys/devices/pci0000:00/0000:00:00.0/numa_node
0
/sys/devices/pci0000:00/0000:00:11.0/numa_node
0
/sys/devices/pci0000:00/0000:00:12.0/numa_node
0
/sys/devices/pci0000:00/0000:00:12.1/numa_node
0
/sys/devices/pci0000:00/0000:00:12.2/numa_node
0
/sys/devices/pci0000:00/0000:00:13.0/numa_node
0
/sys/devices/pci0000:00/0000:00:13.1/numa_node
0
/sys/devices/pci0000:00/0000:00:13.2/numa_node
0
/sys/devices/pci0000:00/0000:00:14.0/numa_node
0
/sys/devices/pci0000:00/0000:00:14.1/numa_node
0
/sys/devices/pci0000:00/0000:00:14.3/numa_node
0
/sys/devices/pci0000:00/0000:00:14.4/0000:01:04.0/numa_node
0
/sys/devices/pci0000:00/0000:00:14.4/numa_node
0
/sys/devices/pci0000:00/0000:00:14.5/numa_node
0
/sys/devices/pci0000:00/0000:00:18.0/numa_node
0
/sys/devices/pci0000:00/0000:00:18.1/numa_node
0
/sys/devices/pci0000:00/0000:00:18.2/numa_node
0
/sys/devices/pci0000:00/0000:00:18.3/numa_node
0
/sys/devices/pci0000:00/0000:00:18.4/numa_node
0
/sys/devices/pci0000:00/0000:00:18.5/numa_node
0
/sys/devices/pci0000:00/0000:00:19.0/numa_node
0
/sys/devices/pci0000:00/0000:00:19.1/numa_node
0
/sys/devices/pci0000:00/0000:00:19.2/numa_node
0
/sys/devices/pci0000:00/0000:00:19.3/numa_node
0
/sys/devices/pci0000:00/0000:00:19.4/numa_node
0
/sys/devices/pci0000:00/0000:00:19.5/numa_node
0
/sys/devices/pci0000:00/0000:00:0d.0/0000:02:00.0/numa_node
0
/sys/devices/pci0000:00/0000:00:0d.0/0000:02:00.1/numa_node
0
/sys/devices/pci0000:00/0000:00:0d.0/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.0/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.1/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.2/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.3/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.4/numa_node
0
/sys/devices/pci0000:00/0000:00:1a.5/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.0/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.1/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.2/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.3/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.4/numa_node
0
/sys/devices/pci0000:00/0000:00:1b.5/numa_node
0
/sys/devices/pci0000:00/0000:00:1c.0/numa_node
0
/sys/devices/pci0000:00/0000:00:1c.1/numa_node
0
/sys/devices/pci0001:00/0001:00:00.0/numa_node
4
/sys/devices/pci0001:00/0001:00:11.0/numa_node
4
/sys/devices/pci0001:00/0001:00:14.0/numa_node
4
/sys/devices/pci0001:00/0001:00:14.4/numa_node
4
/sys/devices/pci0001:00/0001:00:18.0/numa_node
4
/sys/devices/pci0001:00/0001:00:18.1/numa_node
4
/sys/devices/pci0001:00/0001:00:18.2/numa_node
4
/sys/devices/pci0001:00/0001:00:18.3/numa_node
4
/sys/devices/pci0001:00/0001:00:18.4/numa_node
4
/sys/devices/pci0001:00/0001:00:18.5/numa_node
4
/sys/devices/pci0001:00/0001:00:19.0/numa_node
4
/sys/devices/pci0001:00/0001:00:19.1/numa_node
4
/sys/devices/pci0001:00/0001:00:19.2/numa_node
4
/sys/devices/pci0001:00/0001:00:19.3/numa_node
4
/sys/devices/pci0001:00/0001:00:19.4/numa_node
4
/sys/devices/pci0001:00/0001:00:19.5/numa_node
4
/sys/devices/pci0001:00/0001:00:0d.0/0001:02:00.0/numa_node
4
/sys/devices/pci0001:00/0001:00:0d.0/0001:02:00.1/numa_node
4
/sys/devices/pci0001:00/0001:00:0d.0/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.0/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.1/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.2/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.3/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.4/numa_node
4
/sys/devices/pci0001:00/0001:00:1a.5/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.0/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.1/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.2/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.3/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.4/numa_node
4
/sys/devices/pci0001:00/0001:00:1b.5/numa_node
4
/sys/devices/pci0001:00/0001:00:1c.0/numa_node
4
/sys/devices/pci0001:00/0001:00:1c.1/numa_node
4
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
