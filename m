Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaA2PnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:43:20 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45139 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaA2PnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:43:19 -0500
Message-ID: <52E92193.2060200@gmail.com>
Date: Wed, 29 Jan 2014 16:43:15 +0100
From: boris brezillon dev <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com
CC: =?UTF-8?B?SGVucmlrIE5vcmRzdHLDtm0=?= <henrik@henriknordstrom.net>,
        dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Suchanek <hramrach@gmail.com>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash
 Controller support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost> <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost> <1389474709.22660.4.camel@localhost> <52D3ABB6.9030204@overkiz.com> <CAOMqctSrXow1Wjppzp0Y4+p26KFFggtEphxX2xcs0ZoLvDUx1g@mail.gmail.com>
In-Reply-To: <CAOMqctSrXow1Wjppzp0Y4+p26KFFggtEphxX2xcs0ZoLvDUx1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

On 29/01/2014 16:11, Michal Suchanek wrote:
> On 13 January 2014 10:02, boris brezillon <b.brezillon@overkiz.com> wrote:
>> Hi Henrik,
>>
>>
>> On 11/01/2014 22:11, Henrik Nordström wrote:
>>> <bbrezillon> thanks for pointing out your documents
>>> <bbrezillon> I'm trying to get the NAND driver with HW ECC (and HW RND)
>>> without using DMA at all
>>>
>>> I tried many things but did not quite get the ECC reading command to
>>> return meaningful resuts. But should work somehow.
>>>
>>> <bbrezillon> do you have any other information I could use to do this ?
>>>
>>> Not really. There is no known code to look at using the nand controller
>>> without DMA. All allwinner code uses DMA even the boot ROM (BROM).
>>>
>>> <bbrezillon> For example, I wonder why there are 2 RAM sectors (the
>>> driver I found only make use of RAM0)
>>>
>>> I think it's used during DMA to fetch next sector while the previous one
>>> is transferred by DMA. But not sure.
>>
>> Some feedback on my tests:
>>
>> - I managed to get HW ECC working without any DMA transfer (using CMD = 01):
>>    * I only tested the sequential ECC => ECC are stored between 2 data blocks
>> (1024 byte)
>>    * Non sequential ECC should work if I store ECC bytes in the OOB area too
>> (I'll just have
>>       to send RANDOM_OUT commands to move to the OOB area before sending the
>> ECC
>>       cmd and another RANDOM_OUT to go back to the DATA area)
>>
>> - The HW RND (randomizer) works too, I'll just have to figure out how this
>> could be
>>    mainlined:
>>     * using a simple dt property to tell the controller it should enable the
>> randomizer
>>     * provide an interface (like the nand_ecc_ctrl struct ) for other to add
>> their own
>>        randomizer implementation (this was requested:
>> https://lkml.org/lkml/2013/12/13/154)
>>
>>
>> The most complicated part is the boot0 partition.
>>
>> Tell me if I'm wrong, but here's what I understood from your work (and yuq's
>> work too):
>>
>> boot 0 part properties:
>> - uses sequential ECC
>> - uses 1024 bytes ECC blocks
>> - boot0 code is stored only on the first ECC block of each page (1024 bytes
>> + ecc bytes)
>> - boot0 code is stored on the first 64 pages of the first block
>> - boot0 uses HW randomizer with a specific rnd seed (0x4a80)
>>
>> It's not that complicated to read/write from/to boot0, but it's a bit more
>> to mainline this
>> implementation:
>>   - the nand chip must use the same ECC algorithm and ECC layout on the whole
>> flash
>>     (no partition specific config available)
>> - you cannot mark some part of pages as unused => the nand driver will write
>> the
>>    whole page, not just the first ECC block (1024 bytes)
>>
>> I thought about manually creating an mtd device that fullfils these needs
>> (in case we
>> encounter the "allwinner,nandn-boot" property on a nand@X node), but I'm not
>> sure
>> this is the right approach.
>>
>> Any ideas ?
> Maybe if varying parameters on one MTD device is not acceptable you
> could export parts of the flash as different MTD devices each with its
> own parameters. Since the boot0 part is fixed size this should not
> really be an issue. Existing MTD drivers that share hardware with
> other devices exist - eg. the MTD driver which exports part of RAM as
> MDT device.

I considered this option (exposing 2 mtd devices which use the
same nand chip: one for the boot partition and the other one
for the remaining space).
I might give it a try.

For the moment I'm trying to use standard partitions and then
attach one of these partitions as a sunxi-nand-boot-interface.
Something similar to what UBI is doing when attaching to an MTD
device.

This way we can use the NAND as a standard MTD dev and when one
partition is attached as a sunxi-nand-boot-interface you can access
the boot0 partition using a char dev (/dev/snbi0 ?).
The sunxi-nand-boot-interface will provide the appropriate abstraction
to hide the specific boot0 layout...

What do you think ?

>
> I wonder if it would be good idea to make it possible to use the NAND
> only for storage without a boot0 area. If this is selected by a DT
> parameter as suggested changing the parameter will probably make the
> NAND unreadable.
Actually the NAND controller supports up to 8 chips. I guess only the
first one can be used as a boot device.
Reserving space for the boot partition on all of these chips is kind of
useless.
Moreover, we can't tell if the user wants to boot from the NAND or
from another storage (MMC for example), in this case we don't need
to expose the boot0 partition.


Best Regards,

Boris
>
> Thanks
>
> Michal
>
>>
>> Best Regards,
>>
>> Boris
>>
>>> Regards
>>> Henrik
>>>
>> --
>> You received this message because you are subscribed to the Google Groups
>> "linux-sunxi" group.
>> To unsubscribe from this group and stop receiving emails from it, send an
>> email to linux-sunxi+unsubscribe@googlegroups.com.
>> For more options, visit https://groups.google.com/groups/opt_out.

