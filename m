Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaBMJGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:06:13 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:43177 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaBMJGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:06:05 -0500
Message-ID: <52FC8AFA.2050209@gmail.com>
Date: Thu, 13 Feb 2014 10:06:02 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gupta Pekon <pekon@ti.com>
Subject: Re: [RFC PATCH v2 0/4] mtd: nand: add per partition ECC config
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com> <CAGVrzcZei92K9Jeue-Yvcev7n08YEEqfRbN2xgqLpW7epMzFVA@mail.gmail.com> <52FBE5B6.2040603@gmail.com> <CAGVrzcY5AUtwtqG+XvxSbcYJQpUbMMP8E1COjGdivqUTY+fxUw@mail.gmail.com>
In-Reply-To: <CAGVrzcY5AUtwtqG+XvxSbcYJQpUbMMP8E1COjGdivqUTY+fxUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 23:43, Florian Fainelli wrote:
> 2014-02-12 13:20 GMT-08:00 Boris BREZILLON <b.brezillon.dev@gmail.com>:
>> Hi Florian,
>>
>>
>> On 12/02/2014 20:49, Florian Fainelli wrote:
>>> Hi Boris,
>>>
>>> 2014-02-11 13:46 GMT-08:00 Boris BREZILLON <b.brezillon.dev@gmail.com>:
>>>> Hello,
>>>>
>>>> This patch series is a proposal to add per partition ECC config.
>>>>
>>>> It defines a new partition type called nand_part which stores a pointer
>>>> to
>>>> a nand_ecc_ctrl struct.
>>>> This specific nand_ecc_ctrl struct is used in place of the base NAND chip
>>>> nand_ecc_ctrl struct when accessing NAND chip from nand_part MTD device.
>>>>
>>>> If the partition does not define any ECC config, the NAND chip ECC config
>>>> is used instead.
>>> Although the idea does look nice on the paper, I wonder if it is
>>> really useful to have that much complexity in the kernel. Most likely
>>> what is happening is that your bootloader partition has a specific ECC
>>> scheme due to the CPU bootrom or whatever early bootagent is running
>>> on the system. When that is the case, this can be solved in user-space
>>> by preparing full pages (main+spare) along with their specific ECC
>>> requirements and use the MTD_FILE_MODE_RAW option on your specific MTD
>>> partition.
>>
>> Okay, that should be possible, althought in the sunxi specific case I
>> haven't
>> figured out how to generate these ECC data yet (even if it's using BCH
>> algorithms).
>>
>>
>>> You do not describe what is the end goal of this patchset, which might
>>> help figuring out the potential other platforms requirements etc...
>>
>> My goal is exactly the one you described above, I just thought this would be
>> much easier to handle this within the kernel, without having to develop
>> extra
>> user space tools.
> Each platform will have different requirements which are imho better
> solved at the user-space level (bad block marker placement, ECC
> scheme, number of times the bootloader must be replicated,
> cryptography, signing, proprietary OOBs and whatnot). The situation is
> probably made even worse with platforms implementing a trusted boot
> scheme where you may have to modify your boot program for whatever
> reason before writing it down again.

On the other hand, most of the time the NAND controller drivers
already support all these specific ECC algorithms and OOB layouts
(I'm not talking about crypto, signing or trusted boot), and would be
able to expose these "weird" partitions to user-space with almost no
extra development cost.

>
> My point is that, an user-space solution already exists, and the
> bootloaders are significantly smaller and not read/written often
> enough to justify leveraging HW ECC for instance, which could be one
> advantage of the per-partition ECC scheme.

AFAICT, there's no such tools for the sunxi platform (but I might be
wrong).


>
>> This implementation is not that complex and should not impact performances
>> (it's just using cur_ecc pointer instead of intern ecc struct).
> How about reading/erasing/writing concurrently (as in having two
> user-space applications), is not that going to incur some sort of "ECC
> context switching" cost?

I can only talk for the sunxi NAND driver, and AFAIK, for this driver,
switching from one ECC config to another shouldn't imply any performance
cost.

I'll do some measurements to validate what I'm saying.

> I am also not sure if all NAND controllers
> will behave (they should) correctly when you switch from one ECC
> scheme to another on the fly like this could be happening.

The decision to use per-partition ECC config is left to the NAND controller
driver, thus, if a driver does not support ECC config switching (or if 
this implies
too much performance cost) it can just use the standard
mtd_device_parse_register or assign part's ecc pointer to NULL.

I can even go further and take the nand_part code out of nand_base.c to make
it optional (I would just need to export some NAND core functions).
The same goes for the NAND partition list and list lock stored in the 
nand_chip
struct: we can make it optional depending on a NAND_PART Kconfig option.

As you can see, I'm not giving up on this feature :-), because this 
would help
me (and hopefully other users too) a lot to have access to these 
specific partition
without any user space converters.

Best Regards,

Boris
>> Most of the extra code introduced by this series come from the new partition
>> type
>> handling, which is quite straightforward BTW.
>>
>> Anyway, I understand your concern. Could MTD maintainers (and NAND driver
>> developpers) give there opinion too ?
>>
>> BTW, I'm also working on a data randomization layer (needed by some MLC/TLC
>> chips)
>> within the NAND core framework and I'm using the same per partition approach
>> (for the exact same reason: boot0 partition uses a randomizer seed that
>> might not fit
>> the NAND chip requirements).
>>
>> Should I reconsider doing this too ?
>>
>> Thanks for you comments.
>>
>> Best Regards,
>>
>> Boris
>>
>>>> This patch series also provides an helper function to parse DT defined
>>>> NAND
>>>> partitions (ofnandpart_parse).
>>>>
>>>> If you want to test it you'll have to replace calls to
>>>> mtd_device_parse_register with ofnandpart_parse within your NAND
>>>> controller
>>>> driver and implement a driver specific parser function that will provide
>>>> the ECC config (see ofnandpart_data struct).
>>>>
>>>> The 4th patch of this series is here as an example on how to move from
>>>> MTD
>>>> partitions to NAND partitions.
>>>>
>>>> Best Regards,
>>>>
>>>> Boris
>>>>
>>>> Changes since v1:
>>>> - almost everything :-)
>>>>
>>>> Boris BREZILLON (4):
>>>>     mtd: nand: take nand_ecc_ctrl initialization out of nand_scan_tail
>>>>     mtd: nand: add support for NAND partitions
>>>>     mtd: nand: add DT NAND partition parser
>>>>     mtd: nand: add NAND partition support to the sunxi driver
>>>>
>>>>    drivers/mtd/nand/Kconfig      |    4 +
>>>>    drivers/mtd/nand/Makefile     |    2 +
>>>>    drivers/mtd/nand/nand_base.c  |  763
>>>> ++++++++++++++++++++++++++++++++---------
>>>>    drivers/mtd/nand/ofnandpart.c |  104 ++++++
>>>>    drivers/mtd/nand/sunxi_nand.c |   69 +++-
>>>>    include/linux/mtd/nand.h      |   54 +++
>>>>    6 files changed, 835 insertions(+), 161 deletions(-)
>>>>    create mode 100644 drivers/mtd/nand/ofnandpart.c
>>>>
>>>> --
>>>> 1.7.9.5
>>>>
>>>>
>>>> ______________________________________________________
>>>> Linux MTD discussion mailing list
>>>> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>>>
>>>
>
>

