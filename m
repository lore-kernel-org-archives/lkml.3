Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAOLUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:20:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:43524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbbAOLUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,403,1418112000"; 
   d="scan'208";a="670344541"
Message-ID: <54B7A265.6000403@linux.intel.com>
Date: Thu, 15 Jan 2015 19:20:05 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: 3.19-rc4: Xen pci-passthrough regression, bisected to commit
 cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC
 pin reference count"
References: <74756708.20150114151521@eikelenboom.it> <54B68419.9010503@citrix.com> <99660311.20150114171736@eikelenboom.it>
In-Reply-To: <99660311.20150114171736@eikelenboom.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sander,
	It really cost me some time to understand HVM, PVH, Dom0, PV and
read Xen interrupt related code:( Now I have basic understanding of
related staffs. The patch for previous issue is actually wrong and
I'm working on another fixes for it. I will handle this issue once
getting done with the previous issue.
	Sorry for the delay.
Regards!
Gerry

On 2015/1/15 0:17, Sander Eikelenboom wrote:
> 
> Wednesday, January 14, 2015, 3:58:33 PM, you wrote:
> 
>> On 14/01/15 14:15, Sander Eikelenboom wrote:
>>> Hi Gerry / David / Konrad,
>>>
>>> Some more testing uncovered another issue under Xen, this time with PCI-passthrough.
> 
>> What device?  In particular what interrupts is it using?
> 
> Hi David,
> 
> Here is a more complete set of debug logs, for both with and without the revert.
> - dmesg
> - xl-dmesg with output of debug keys 'i, M, z'
> - lspci part of the two devices from the guest
> - /proc/interrupts
> 
> The wifi NIC (dom0: 02:00.0 guest: 00:05.0) uses legacy interrupts and gives troubles:
> It's using:
>         Interrupt: pin A routed to IRQ 36
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>         36:      14413  xen-pirq-ioapic-level  ath9k
> 
> The other NIC (dom0: 00:19.0 guest: 00:06.0) uses MSI interrupts and that works fine:
>         Interrupt: pin A routed to IRQ 57
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         57:        182  xen-pirq-msi       eth0
> --
> Sander  
> 
>>> I have bisected it to the following commit: 
>>> cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC pin reference count"
>>>
>>> It causes these symptoms:
>>>
>>> - On Intel
>>>   - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
>>>   - Running a HVM guest with PCI passthrough of two devices (NIC + wireless NIC)
>>>   - While the driver loads fine, the device isn't working properly, looking in /proc/interrupts in the guest
>>>     shows that it doesn't receive any interrupts.
>>>   - Reverting this particular commit (in the dom0 kernel only) makes the device receive interrupts and work properly again.
>>>
>>> - On AMD (more subtle symptom) 
>>>   - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
>>>   - Running a HVM guest with PCI passthrough of one devices (videograbber)
>>>   - While the driver loads fine and the device looks like it's working, the videostream isn't stable and it skips or repeats frames.
>>>   - Reverting this particular commit (in the dom0 kernel only) makes the device work properly again with a stable videostream.
>>>
>>> --
>>> Sander
>>>
> 
