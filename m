Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaA2Qz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:55:57 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45423 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaA2Qzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:55:55 -0500
Message-ID: <52E93298.5080502@gmail.com>
Date: Wed, 29 Jan 2014 17:55:52 +0100
From: boris brezillon dev <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Suchanek <hramrach@gmail.com>
CC: linux-sunxi <linux-sunxi@googlegroups.com>,
        =?UTF-8?B?SGVucmlrIE5vcmRz?= =?UTF-8?B?dHLDtm0=?= 
	<henrik@henriknordstrom.net>,
        dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash
 Controller support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost> <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost> <1389474709.22660.4.camel@localhost> <52D3ABB6.9030204@overkiz.com> <CAOMqctSrXow1Wjppzp0Y4+p26KFFggtEphxX2xcs0ZoLvDUx1g@mail.gmail.com> <52E92193.2060200@gmail.com> <CAOMqctSH9UCo6m45QFKFboZPcE2sgAogntoXcw9J1PUv+eUtkw@mail.gmail.com>
In-Reply-To: <CAOMqctSH9UCo6m45QFKFboZPcE2sgAogntoXcw9J1PUv+eUtkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/2014 17:08, Michal Suchanek wrote:
> On 29 January 2014 16:43, boris brezillon dev <b.brezillon.dev@gmail.com> wrote:
>> Hello Michal,
>>
>>
>> On 29/01/2014 16:11, Michal Suchanek wrote:
>>> On 13 January 2014 10:02, boris brezillon <b.brezillon@overkiz.com> wrote:
>>>>
>>>> boot 0 part properties:
>>>> - uses sequential ECC
>>>> - uses 1024 bytes ECC blocks
>>>> - boot0 code is stored only on the first ECC block of each page (1024
>>>> bytes
>>>> + ecc bytes)
>>>> - boot0 code is stored on the first 64 pages of the first block
>>>> - boot0 uses HW randomizer with a specific rnd seed (0x4a80)
>>>>
>>>> It's not that complicated to read/write from/to boot0, but it's a bit
>>>> more
>>>> to mainline this
>>>> implementation:
>>>>    - the nand chip must use the same ECC algorithm and ECC layout on the
>>>> whole
>>>> flash
>>>>      (no partition specific config available)
>>>> - you cannot mark some part of pages as unused => the nand driver will
>>>> write
>>>> the
>>>>     whole page, not just the first ECC block (1024 bytes)
>>>>
>>>> I thought about manually creating an mtd device that fullfils these needs
>>>> (in case we
>>>> encounter the "allwinner,nandn-boot" property on a nand@X node), but I'm
>>>> not
>>>> sure
>>>> this is the right approach.
>>>>
>>>> Any ideas ?
>>> Maybe if varying parameters on one MTD device is not acceptable you
>>> could export parts of the flash as different MTD devices each with its
>>> own parameters. Since the boot0 part is fixed size this should not
>>> really be an issue. Existing MTD drivers that share hardware with
>>> other devices exist - eg. the MTD driver which exports part of RAM as
>>> MDT device.
>>
>> I considered this option (exposing 2 mtd devices which use the
>> same nand chip: one for the boot partition and the other one
>> for the remaining space).
>> I might give it a try.
>>
>> For the moment I'm trying to use standard partitions and then
>> attach one of these partitions as a sunxi-nand-boot-interface.
>> Something similar to what UBI is doing when attaching to an MTD
>> device.
>>
>> This way we can use the NAND as a standard MTD dev and when one
>> partition is attached as a sunxi-nand-boot-interface you can access
>> the boot0 partition using a char dev (/dev/snbi0 ?).
>> The sunxi-nand-boot-interface will provide the appropriate abstraction
>> to hide the specific boot0 layout...
>>
>> What do you think ?
> If it works with MTD, sure.
>
> The problem the two devices avoid is that with uniform parameters
> across MTD device the boot0 partition is invalid.

Using partitions we would still have X char devices (X = number of MTD
partitions). But indeed, we need to provide a way to configure ECC and
randomizer specifically on each partition.

>
>>
>>> I wonder if it would be good idea to make it possible to use the NAND
>>> only for storage without a boot0 area. If this is selected by a DT
>>> parameter as suggested changing the parameter will probably make the
>>> NAND unreadable.
>> Actually the NAND controller supports up to 8 chips. I guess only the
>> first one can be used as a boot device.
>> Reserving space for the boot partition on all of these chips is kind of
>> useless.
> This actually depends on the BROM.
>
> I did not read the BROM code so I don't know what it does.
>
>> Moreover, we can't tell if the user wants to boot from the NAND or
>> from another storage (MMC for example), in this case we don't need
>> to expose the boot0 partition.
> It's possible to use the NAND only for storage, sure.
>
> However, a NAND on which the boo0 area is reserved would be unreadable
> without reserving boot0 area in the driver, right?

Not exactly: the NAND would still be readable but the blocks reserved for
boot0 (boot0 partition) won't be read correctly (ECC layout differs).
If you define a partition boot0 with the appropriate size and never access
it, the other partitions defined on the same NAND chip will work perfectly.

To solve this ECC config issue we might need to provide a way to configure
the ECC engine per partition and not on the whole NAND chip.

Moreover, IRC, BROM only uses 1K on each page of a given block to store
boot0 code and data.

And eventually the randomizer config (random seed) is specific for this
partition too.
Note that the current driver does not support randomization at all.
I'm still working on providing a generic framework to support HW and SW
randomization (in the same way HW and SW ECC are supported).

For all the reasons exposed above we need a specific handling for the boot0
partition. But I'd like to keep the NAND Flash controller driver as 
simple and
as generic as possible.
I'd prefer adding a new driver for the sunxi boot0 partition handling than
adding this code in the sunxi_nand driver.
Atfer all, this boot partition has nothing to do with NAND, this is just 
a specific
format for the sunxi BROM to load code from NAND to RAM, right ?

>
> The best we can tell is if user specified to reserve the area in the
> DT. It might be possible to verify the boot0 area the same way BROM
> does when booting from it. This might be nice option when you don't
> know what you have on the chip and want to read it but most of the
> time you will want to enforce bootable or non-bootable format when
> writing the NAND.
>
> Thanks
>
> Michal

