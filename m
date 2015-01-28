Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbbA2EQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:16:47 -0500
Received: from numascale.com ([213.162.240.84]:47703 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbbA2EQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:16:46 -0500
Message-ID: <54C8A10B.3070207@numascale.com>
Date: Wed, 28 Jan 2015 16:42:51 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>, "x86@kernel.org" <x86@kernel.org>
Subject: PCIe 32-bit MMIO exhaustion
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
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

With systems with a large number of PCI devices, we're seeing lack of 
32-bit MMIO space, eg one quad-port NetXtreme-2 adapter takes 128MB of 
space [1].

An errata to the PCIe 2.1 spec provides guidance on limitations with 
64-bit non-prefetchable BARs (since bridges have only 32-bit 
non-prefetchable ranges) stating that vendors can enable the 
prefetchable bit in BARs under certain circumstances to allow 64-bit 
allocation [2].

The problem with that, is that vendors can't know apriori what hosts 
their products will be in, so can't just advertise prefetchable 64-bit 
BARs. What can be done, is system firmware can use the 64-bit 
prefetchable BAR in bridges, and assign a 64-bit non-prefetchable device 
BAR into that area, where it is safe to do so (following the guidance).

At present, linux denies such allocations [3] and disables the BARs. It 
seems a practical solution to allow them if the firmware believes it is 
safe.

Is this plausible?

Thanks,
   Daniel

--- [1]

0000:01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II 
BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Dell Device 1f26
	Flags: bus master, fast devsel, latency 0, IRQ 24
	Memory at e6000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Device Serial Number d4-ae-52-ff-fe-ea-5c-e8
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: bnx2

0000:01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II 
BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Dell Device 1f26
	Flags: bus master, fast devsel, latency 0, IRQ 25
	Memory at e8000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=9 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Device Serial Number d4-ae-52-ff-fe-ea-5c-ea
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: bnx2

0000:02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II 
BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Dell Device 1f26
	Flags: bus master, fast devsel, latency 0, IRQ 28
	Memory at ea000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=9 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Device Serial Number d4-ae-52-ff-fe-ea-5c-ec
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: bnx2

0000:02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II 
BCM5709 Gigabit Ethernet (rev 20)
	Subsystem: Dell Device 1f26
	Flags: bus master, fast devsel, latency 0, IRQ 29
	Memory at ec000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=9 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Device Serial Number d4-ae-52-ff-fe-ea-5c-ee
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: bnx2

-- [2] p13

https://www.pcisig.com/specifications/pciexpress/base2/PCIe_Base_r2.1_Errata_08Jun10.pdf

-- [3]

pci 0002:01:00.0: BAR 0: [mem size 0x00002000 64bit] conflicts with PCI 
Bus 0002:00 [mem 0x10020000000-0x10027ffffff pref]
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
