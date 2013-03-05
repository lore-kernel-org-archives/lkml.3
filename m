Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab3CEA5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:57:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51722 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3CEA5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:57:30 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <513542CF.1010602@jp.fujitsu.com>
Date: Tue, 05 Mar 2013 09:56:47 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: ddutile@redhat.com
CC: trenn@suse.de, yinghai@kernel.org, muneda.takahiro@jp.fujitsu.com,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1593084.QhbTkmoq3N@hammer82.arch.suse.de> <50FC95A8.6060402@jp.fujitsu.com> <1508535.gXZDAVy6sT@hammer82.arch.suse.de> <5133F14D.4060906@jp.fujitsu.com> <5135196C.3020104@redhat.com>
In-Reply-To: <5135196C.3020104@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/05 7:00), Don Dutile wrote:
> On 03/03/2013 07:56 PM, Takao Indoh wrote:
>> (2013/01/23 9:47), Thomas Renninger wrote:
>>> On Monday, January 21, 2013 10:11:04 AM Takao Indoh wrote:
>>>> (2013/01/08 4:09), Thomas Renninger wrote:
>>> ...
>>>>> I tried the provided patches first on 2.6.32, then I verfied with 3.8-rc2
>>>>> and in both cases the disk is not detected anymore in
>>>>> reset_devices (kexec'ed/kdump) case (but things work fine without these
>>>>> patches).
>>>>
>>>> So the problem that the disk is not detected was caused by exactmap
>>>> problem you guys are discussing? Or still not detected even if exactmap
>>>> problem is fixed?
>>> This problem is related to the 5 PCI resetting patches.
>>> Dumping worked with a 2.6.32 and a 3.8-rc2 kernel, adding the PCI resetting
>>> patches broke both. I first tried 2.6.32 and verified with 3.8-rc2 to make sure
>>> I didn't mess up the backport adjustings of the patches to 2.6.32.
>>>
>>> Unfortunately this Dell platform takes really long to boot.
>>> I can give it the one or other test, but please do not bomb me with patches.
>>>
>>> For info:
>>> About the interrupt remapping error interrupt storm in kdump case I tried to
>>> reproduce on this machine, but never could: The guys who saw that also cannot
>>> reproduce this anymore.
>>>
>>> Two ideas I had about this:
>>>     - As said already, (also) try to catch the error case and try to reset the
>>>       the device in AER/Specific iterrupt remapping error interrupt caught.
>>
>> I tried this idea but it did not work on megaraid_sas.
>>
>> I made a experimental patch so that devices are reset when DMAR error is
>> detected on it. What happened is that:
>> 1) megaraid_sas module is loaded.
>> 2) DMAR error is detected during the driver initialization.
> This driver does something bad that IOMMU code isn't designed for,
> or handle correctly -- it starts with one dma-mask, does an IOMMU mapping,
> changes its dma-mask, and that moves it into another domain that's not
> valid for the first mask.... and does occassional access with original mask.
> I have it on my to-do list to dig into the driver more to see if that
> sequence can be changed/fixed.
>
>> 3) Reset device
>> 4) kdump fails because the disk is not found.
>>
>> When I tested patches which reset all devices in early boot time, the
>> disk was recognized correctly, so it seems that device reset during its
>> driver loading does something wrong. I think we need reset device at
> driver rest, or master-enable turned off ?

I have another patch to turn off busmaster bit in early quirk, but after
driver loading DMAR error is still detected as follows. This may be
driver problem as you said above.

Loading mptscsih.koigb: Intel(R) Gigabit Ethernet Network Driver - version 4.1.2-k
  module
Loadingigb: Copyright (c) 2007-2012 Intel Corporation.
  scsi_transport_dmar: DRHD: handling fault status reg 102
dmar: DMAR:[DMA Write] Request device [01:00.0] fault addr ffe16000
DMAR:[fault reason 01] Present bit in root entry is clear
Uhhuh. NMI received for unknown reason 2c on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
fc.ko module
Loigb 0000:01:00.0: irq 76 for MSI/MSI-X
ading dm-log.ko igb 0000:01:00.0: irq 77 for MSI/MSI-X
module
Loading igb 0000:01:00.0: irq 78 for MSI/MSI-X
nf_conntrack_ipv6.ko module
Loading vhost_net.ko module
Loading igb.ko module
igb 0000:01:00.0: DCA enabled
igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x2) c8:0a:a9:9d:fa:52
igb 0000:01:00.0: eth0: PBA No: 323131-030
igb 0000:01:00.0: Using MSI-X interrupts. 1 rx queue(s), 1 tx queue(s)
dmar: DRHD: handling fault status reg 202
dmar: DMAR:[DMA Write] Request device [01:00.1] fault addr ffee9000
DMAR:[fault reason 01] Present bit in root entry is clear
igb 0000:01:00.1: irq 79 for MSI/MSI-X
igb 0000:01:00.1: irq 80 for MSI/MSI-X
igb 0000:01:00.1: irq 81 for MSI/MSI-X
(snip)

Thanks,
Takao Indoh

  
>> least before its driver is loaded.
>>
>> Thanks,
>> Takao Indoh
>>
>>
>>>     - Have a look at coreboot, these guys should know how to initialize the PCI
>>>       subsystem from scratch and might have some well tested PCI resetting
>>>       code in place already (no idea, just a thought).
>>>
>>>       Thomas
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

