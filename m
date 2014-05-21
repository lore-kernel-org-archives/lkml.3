Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaEUXdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:33:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51498 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaEUXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:33:41 -0400
Message-ID: <537D37AA.5030303@ti.com>
Date: Wed, 21 May 2014 19:32:58 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel> <5374FD24.8000806@ti.com> <22200719.Jb5jnJylJH@wuerfel> <20140515183919.GC11650@obsidianresearch.com> <53751DDF.40304@ti.com> <20140515205210.GB14722@obsidianresearch.com> <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com> <20140520170221.GA5130@obsidianresearch.com>
In-Reply-To: <20140520170221.GA5130@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2014 1:02 PM, Jason Gunthorpe wrote:
> On Fri, May 16, 2014 at 08:29:56PM +0000, Karicheri, Muralidharan wrote:
>
>> But pcie_bus_configure_settings just make sure the mrrs for a device
>> is not greater than the max payload size.
> Not quite, it first scans the network checking the Maximum Payload Size
> Supported (MPSS) for each device, and chooses the highest supported by
> all as the MPS for all.
Why highest? It should be lowest so that all on the bus can handle it??
>
> PCI-E requires that an end point support all packets up to the MPS, so
> if your bridge can't generate a 512 byte read response packet, then it
> must not advertise a MPSS greater than 256 bytes.
What is MPSS? Is it the payload size in a message TLP? I read the PCIe 
spec and find
MRSS is the maxumum read request size. So memory reads completion data 
size is limited
to this size, right? So for DMA from EP to RC can't be greater than what 
RC publishes.
Not sure how they are related?

I have checked that root port is advertising 256 bytes for mrrs and 128 
bytes for mps
in the config space. So keystone pcie bridge is doing as expected.

In Keystone case, what I see is after  adding 
pcie_bus_configure_settings() with pci=pcie_bus_safe,
I get following log.

[    1.988851] pcie_bus_configure_settings, config 1
[    1.988860] pcie_bus_configure_set
[    1.988879] pcieport 0000:00:00.0: Max Payload Size set to  256/ 256 
(was  128), Max Read Rq  512
[    1.988887] pcie_bus_configure_set
[    1.988921] pci 0000:01:00.0: Max Payload Size set to  256/ 256 (was  
128), Max Read Rq  512
[    1.988928] pcie_bus_configure_set
[    1.988961] pci 0000:01:00.1: Max Payload Size set to  256/ 256 (was  
128), Max Read Rq  512

So it is not limiting MRRS to 256 bytes.

With pci=pcie_bus_perf

[    1.985777] pcie_bus_configure_settings, config 2
[    1.985783] pcie_bus_configure_set
[    1.985810] pcieport 0000:00:00.0: Max Payload Size set to  256/ 256 
(was  128), Max Read Rq  256
[    1.985818] pcie_bus_configure_set
[    1.985875] pci 0000:01:00.0: Max Payload Size set to  256/ 256 (was  
128), Max Read Rq  256
[    1.985882] pcie_bus_configure_set
[    1.985939] pci 0000:01:00.1: Max Payload Size set to  256/ 256 (was  
128), Max Read Rq  256

Is this log what you expect?

>
> Setting your MPSS to 128, 256, then using the
> pcie_bus_configure_settings to run the standard algorithm should
> properly limit the readrq to 256 and be able to properly support all
> the fun edge cases like hot plug.

> If the config space in your root port bridge is correct and already
> declares a MPSS of 256 then you have nothing else to do but make sure
> pcie_bus_configure_settings gets calls.
>
> If it is broken and claims a higher MPSS than it can support then you
> need to use a quirk only for the root port bridge or edit the config
> reply in the driver only to fix the MPSS
If MRSS is clamped to lowest, then this would work with out a quirk, and 
has to
be unconditional (all cases, safe, performance etc).

I would like to go with the quirk approach until this discussion 
concludes the next
step to fix this issue. May be someone can take owner ship of this 
change at PCI
core level?

My quirk can be removed once the fix is accepted into the tree. Is that 
an acceptable path forward?

Murali
>
> Jason

