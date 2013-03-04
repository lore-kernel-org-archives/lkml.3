Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3CDWCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:02:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab3CDWCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:02:03 -0500
Message-ID: <5135196C.3020104@redhat.com>
Date: Mon, 04 Mar 2013 17:00:12 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: trenn@suse.de, yinghai@kernel.org, muneda.takahiro@jp.fujitsu.com,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1593084.QhbTkmoq3N@hammer82.arch.suse.de> <50FC95A8.6060402@jp.fujitsu.com> <1508535.gXZDAVy6sT@hammer82.arch.suse.de> <5133F14D.4060906@jp.fujitsu.com>
In-Reply-To: <5133F14D.4060906@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2013 07:56 PM, Takao Indoh wrote:
> (2013/01/23 9:47), Thomas Renninger wrote:
>> On Monday, January 21, 2013 10:11:04 AM Takao Indoh wrote:
>>> (2013/01/08 4:09), Thomas Renninger wrote:
>> ...
>>>> I tried the provided patches first on 2.6.32, then I verfied with 3.8-rc2
>>>> and in both cases the disk is not detected anymore in
>>>> reset_devices (kexec'ed/kdump) case (but things work fine without these
>>>> patches).
>>>
>>> So the problem that the disk is not detected was caused by exactmap
>>> problem you guys are discussing? Or still not detected even if exactmap
>>> problem is fixed?
>> This problem is related to the 5 PCI resetting patches.
>> Dumping worked with a 2.6.32 and a 3.8-rc2 kernel, adding the PCI resetting
>> patches broke both. I first tried 2.6.32 and verified with 3.8-rc2 to make sure
>> I didn't mess up the backport adjustings of the patches to 2.6.32.
>>
>> Unfortunately this Dell platform takes really long to boot.
>> I can give it the one or other test, but please do not bomb me with patches.
>>
>> For info:
>> About the interrupt remapping error interrupt storm in kdump case I tried to
>> reproduce on this machine, but never could: The guys who saw that also cannot
>> reproduce this anymore.
>>
>> Two ideas I had about this:
>>     - As said already, (also) try to catch the error case and try to reset the
>>       the device in AER/Specific iterrupt remapping error interrupt caught.
>
> I tried this idea but it did not work on megaraid_sas.
>
> I made a experimental patch so that devices are reset when DMAR error is
> detected on it. What happened is that:
> 1) megaraid_sas module is loaded.
> 2) DMAR error is detected during the driver initialization.
This driver does something bad that IOMMU code isn't designed for,
or handle correctly -- it starts with one dma-mask, does an IOMMU mapping,
changes its dma-mask, and that moves it into another domain that's not
valid for the first mask.... and does occassional access with original mask.
I have it on my to-do list to dig into the driver more to see if that
sequence can be changed/fixed.

> 3) Reset device
> 4) kdump fails because the disk is not found.
>
> When I tested patches which reset all devices in early boot time, the
> disk was recognized correctly, so it seems that device reset during its
> driver loading does something wrong. I think we need reset device at
driver rest, or master-enable turned off ?

> least before its driver is loaded.
>
> Thanks,
> Takao Indoh
>
>
>>     - Have a look at coreboot, these guys should know how to initialize the PCI
>>       subsystem from scratch and might have some well tested PCI resetting
>>       code in place already (no idea, just a thought).
>>
>>       Thomas
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

