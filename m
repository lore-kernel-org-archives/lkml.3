Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaHFIbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:31:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58773 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbaHFIbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:31:38 -0400
Message-ID: <53E1E7C6.10602@ti.com>
Date: Wed, 6 Aug 2014 11:31:02 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <pekon@pek-sem.com>, Grazvydas Ignotas <notasas@gmail.com>
CC: <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <artem.bityutskiy@linux.intel.com>, <jg1.han@samsung.com>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        <linux-mtd@lists.infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>, <dwmw2@infradead.org>
Subject: Re: [PATCH 1/3] mtd: nand: omap: Revert to using software ECC by
 default
References: <1407233482-11642-1-git-send-email-rogerq@ti.com> <1407233482-11642-2-git-send-email-rogerq@ti.com> <CANOLnOM-Q4b8N5T522Vc_gXTSj2C-mxV6GV0hRTDPscpPgXO6A@mail.gmail.com> <099046e951bd70b9bfb638d2ac9d539a@pek-sem.com>
In-Reply-To: <099046e951bd70b9bfb638d2ac9d539a@pek-sem.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekon,

On 08/05/2014 11:30 PM, pekon@pek-sem.com wrote:
> Hi Roger,
> 
> On Tuesday 05 August 2014 09:45 PM, Grazvydas Ignotas wrote:
>> On Tue, Aug 5, 2014 at 1:11 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> For v3.12 and prior, 1-bit Hamming code ECC via software was the
>>> default choice. Commit c66d039197e4 in v3.13 changed the behavior
>>> to use 1-bit Hamming code via Hardware using a different ECC layout
>>> i.e. (ROM code layout) than what is used by software ECC.
>>>
> As per OMAP3 TRM [1], the NAND ECC layout required for
> NAND boot is same as that of OMAP_ECC_HAM1_CODE_HW. So

No. The layout is different. What I mean by OMAP_ECC_HAM1_CODE_SW is what earlier was OMAP_ECC_HAMMING_CODE_DEFAULT.
It sets nand.ecc.mode to NAND_ECC_SOFT and doesn't use OMAP ROM code layout.

> above mentioned 'commit c66d039197e4' does not break
> backward compatibility as far as NAND boot is concerned.

It does. Grazvydas has reported it and I have observed it on omap3beagle with legacy boot when switching from v3.12 to v3.13 and later.

> 
> AFAIK, all users on OMAP3 used HAM1_HW which is same
> as HAM1 today. So unless we have a real OMAP3 user who
> (1) had created file-system using HAM1_SW &&
> (2) now wants to migrate to new kernel, I don't think
> its wise to re-introduce HAM1_SW4 ECC schemes.

many boards using legacy boot don't explicitly set ecc_opt parameter of nand_platform_data. So that is set to 0.
commit c66d039197e4 changed the meaning from default ECC layout to OMAP ROM code layout and hence the regressions.

> 
> Instead we are trying to push OMAP3 users to migrate to
> BCH4_SW (supported by ROM) or BCH8_SW ECC schemes.
> 
> Please understand
> commit c66d039197e42af8867e5d0d9b904daf0fb9e6bc
> was part of larger series to clean-up NAND driver and
> remove obsolete or redundant code. So this was
> intentional change.
> 
> 
> 
>>> This ECC layout change causes NAND filesystems created in v3.12
>>> and prior to be unusable in v3.13 and later. So revert back to
>>> using software ECC by default if an ECC scheme is not explicitely
>>> specified.
>>>
>>> This defect can be observed on the following boards during legacy boot
>>>
>>> -omap3beagle
>>> -omap3touchbook
>>> -overo
>>> -am3517crane
>>> -devkit8000
>>> -ldp
>>> -3430sdp
>>
>> omap3pandora is also using sw ecc, with ubifs. Some time ago I tried
>> booting mainline (I think it was 3.14) with rootfs on NAND, and while
>> it did boot and reached a shell, there were lots of ubifs errors, fs
>> got corrupted and I lost all my data. I used to be able to boot
>> mainline this way fine sometime ~3.8 release. It's interesting that
>> 3.14 was able to read the data, even with wrong ecc setup.
>>
>> Do you think it's safe again to boot ubifs created on 3.2 after
>> applying this series?
>>
> Are you sure you are using "sw" ECC scheme ?
> Can you please share the ecc-layout of the NAND page, because

ecc-layout for software scheme depends on oob size.
http://lxr.free-electrons.com/source/drivers/mtd/nand/nand_base.c#L53

> as per [1] you should not be able to Boot from NAND then.

Bootpartition and filesystem partition are different. Boot partition needs to be compatible with OMAP ROM code layout but root filesystem doesn't need to be. I agree that it is best to use the same for but if boards have been using a different layout for filesystem then we need to maintain backward compatibility.

> 
> IIRC..
> - ECC layout of HAM1_SW has ECC bytes towards end of OOB-section.
> - ECC layout of HAM1_HW has ECC bytes towards staring of OOB section.

The main difference between sw layout and ROM code layout is
- sw layout always starts at offset 0
- rom layout starts at 1 for x8 device and 2 for x16 device.

cheers,
-roger
