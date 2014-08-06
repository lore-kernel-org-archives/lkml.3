Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaHFWzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:55:10 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46806 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaHFWzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <53E1E122.4050308@ti.com>
References: <1407233482-11642-1-git-send-email-rogerq@ti.com>
	<1407233482-11642-2-git-send-email-rogerq@ti.com>
	<CANOLnOM-Q4b8N5T522Vc_gXTSj2C-mxV6GV0hRTDPscpPgXO6A@mail.gmail.com>
	<53E1E122.4050308@ti.com>
Date: Thu, 7 Aug 2014 01:55:06 +0300
Message-ID: <CANOLnOOA5c-B9rn5LR2HGyfUW+D1UzjRE7EAL-cYsZ4NYuCaXg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mtd: nand: omap: Revert to using software ECC by default
From: Grazvydas Ignotas <notasas@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        pekon.gupta@gmail.com, artem.bityutskiy@linux.intel.com,
        dwmw2@infradead.org, jg1.han@samsung.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 11:02 AM, Roger Quadros <rogerq@ti.com> wrote:
> Hi Gražvydas,
>
> On 08/05/2014 07:15 PM, Grazvydas Ignotas wrote:
>> On Tue, Aug 5, 2014 at 1:11 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> For v3.12 and prior, 1-bit Hamming code ECC via software was the
>>> default choice. Commit c66d039197e4 in v3.13 changed the behaviour
>>> to use 1-bit Hamming code via Hardware using a different ECC layout
>>> i.e. (ROM code layout) than what is used by software ECC.
>>>
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
>
> This is due to another bug introduced in 3.7 by commit 65b97cf6b8deca3ad7a3e00e8316bb89617190fb.
> Because of that bug (i.e. inverted CS_MASK in omap_calculate_ecc), omap_calculate_ecc() always fails with -EINVAL and calculated ECC bytes are always 0. I'll be sending a patch to fix that as well. But that will only affect the cases where OMAP_ECC_HAM1_CODE_HW is used which happened for pandora from 3.13 onwards.
>
>>
>> Do you think it's safe again to boot ubifs created on 3.2 after
>> applying this series?
>>
>
> Yes. If you boot pandora using legacy boot (non DT method), it passes 0 for .ecc_opt in pandora_nand_data. This used to mean OMAP_ECC_HAMMING_CODE_DEFAULT which is software ecc. i.e. NAND_ECC_SOFT with default ECC layout. Until the above mentioned commits changed the meaning. We now call that option OMAP_ECC_HAM1_CODE_SW.
>
> Please let me know if it works for you. Thanks.

Yes it does, thank you.
Tested-by: Grazvydas Ignotas <notasas@gmail.com>

Found something new in dmesg though:
[    1.542755] nand: device found, Manufacturer ID: 0x2c, Chip ID: 0xbc
[    1.549621] nand: Micron MT29F4G16ABBDA3W
[    1.553894] nand: 512MiB, SLC, page size: 2048, OOB size: 64
[    1.560058] nand: WARNING: omap2-nand.0: the ECC used on your
system is too weak compared to the one required by the NAND chip

Do you think it's best to migrate to different ECC scheme? It would be
better to avoid that so that users can freely change kernels and the
bootloader wouldn't have to be changed..

-- 
Gražvydas
