Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3BGObZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:31:25 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:51552 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3BGObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:31:21 -0500
MIME-Version: 1.0
In-Reply-To: <51139974.2040601@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<1781360.cmQWHCW5SC@wuerfel>
	<CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	<201302041724.47331.arnd@arndb.de>
	<1360031367.14701.47.camel@pasglop>
	<CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	<1360066756.4529.6.camel@pasglop>
	<CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	<51111133.7000105@synopsys.com>
	<1360098004.4529.13.camel@pasglop>
	<511178AC.7080304@synopsys.com>
	<1360105635.2707.7.camel@pasglop>
	<CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
	<1360186550.2650.4.camel@pasglop>
	<51139974.2040601@synopsys.com>
Date: Thu, 7 Feb 2013 15:31:16 +0100
Message-ID: <CAHTX3dL27B_zt+m9YL665+Un47aSZq59UspW0To=jydBixe_SQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net, gsmecher@threespeedlogic.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
> On 02/07/2013 01:35 AM, Benjamin Herrenschmidt wrote:
>>
>> On Wed, 2013-02-06 at 10:14 +0000, Grant Likely wrote:
>>>
>>>
>>> Huh? That makes no sense. This device out in the wild with both big
>>> and little endian bus attachments. You can argue all day that one of
>>> them is wrong, but it doesn't matter. It exists, is used, and must be
>>> supported.
>>
>>
>> No. That's where you are VERY wrong. We don't have to support crap and
>> arguably shouldn't if that can give an incentive to vendors to fix their
>> stuff. If you don't believe me, ask Linus :-)
>>
>>>   In fact, the driver already knows about this and figures
>>> out at runtime how the device is wired up to the bus. This is not the
>>> problem.
>>
>>
>> Except that this is very gross, especially when you observe that in the
>> busted "big endian" case, it has to byteswap the bloody data port.
>>
>> So you end up having to do that gross hack with separate accessors for
>> registers vs. data and not able to use the _rep variants, which also
>> means that on platforms like ppc, you end up with a memory barrier on
>> every access (or more), which is going to slow things down enormously.
>
>
> BTW I've just realized that in case if there's no bridge between CPU and
> CF-controller or if this bridge is "transparent" (does no swapping
> neither bytes nor bits) our data accessors here should be changed.
>
> Isn't it strange in "ace_datain_le16" use "ioread16be" or the one it was
> here initially "in_be16"?
> With BE ones I'd say similar changes should be done.
>
> So finally I see them implemented this way:
> ===============
> /* BE part */
>
> static void ace_datain_be16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *dst = ace->data_ptr;
>         while (i--)
>                 *dst++ = ioread16be(ace->baseaddr + 0x40);
>         ace->data_ptr = dst;
> }
>
> static void ace_dataout_be16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *src = ace->data_ptr;
>         while (i--)
>                 iowrite16be(*src++, ace->baseaddr + 0x40);
>         ace->data_ptr = src;
> }
>
> /* LE part*/
>
> static void ace_datain_le16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *dst = ace->data_ptr;
>         while (i--)
>                 *dst++ = ioread16(ace->baseaddr + 0x40);
>         ace->data_ptr = dst;
> }
>
> static void ace_dataout_le16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *src = ace->data_ptr;
>         while (i--)
>                 iowrite16(*src++, ace->baseaddr + 0x40);
>         ace->data_ptr = src;
> }
> ===============
>
> Correct me if I'm wrong here.
>
> And at least these accessors for LE got xsysace perfectly working on our
> FPGA platform (little-endian ARC700 on Xilinx ml-509 with our own
> BVCI-to-MPU bridge that does no swapping).
>
> I have to confess that I didn't properly tested initial patch on real HW -
> it was only sort of cosmetic clean-up.

The origin patch (after some microblaze ioread/iowrite fixes) works ok,
These additional changes is breaking sysace on microblaze big endian
ml505 16bit mode.
8bit mode just works

Also I have looked at our tree and I see that the mainline kernel misses
one patch which was sent by Graeme Smecher and it was also Acked-by Grant.
It is called "Fix device name assignment for SystemACE (from "xs`" to "xsa")."
Let me resend it too.

Alexey: Can you please confirm that on your arc platform you see broken CF
partitions name?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
