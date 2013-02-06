Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3BFKOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:14:52 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50147 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3BFKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:14:50 -0500
MIME-Version: 1.0
In-Reply-To: <1360105635.2707.7.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
 <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Feb 2013 10:14:30 +0000
X-Google-Sender-Auth: WBTp5K9hMwPPRpzDUbVFib2GpXU
Message-ID: <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:07 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2013-02-06 at 01:25 +0400, Alexey Brodkin wrote:
>> Sounds good but how should one tell which approach is correct? For
>> example here - is the one implemented by Xilinx is golden reference or
>> not?
>
> So I'm reading that PDF you pointed to. So far what I can see is:
>
>  - In 8-bit mode you only do 8-bit accesses, so endianness should be
> totally irrelevant (at least the pdf says so)
>
>  - In 16-bit mode, that's where things become interesting... the doc
> says:
>
>   PLB Data Bus          | System ACE Data Bus
>   ----------------------+--------------------
>   PLB_DBus[8 : 15]      | SysACE_MPD[15 : 8]
>   PLB_DBus[0 : 7]       | SysACE_MPD[7 : 0]
>
> Now, I'm not 100% of the bit numbering used by Xilinx here but it smells
> like PLB used ppc numbering and SystemACE use the classic numbering, in
> which case the above would mean that the MSB of the PLB is connected to
> the LSB of the SystemACE and vice-versa.
>
> If that is the case then this is the *correct* wiring and means that the
> data port (if any) doesn't need any byteswapping. It also means that the
> registers need byteswap on BE, as expected for a LE device. IE. Just
> always use ioread32 (or _rep variants for the data port if there's such
> a thing on it).
>
> So that looks good... unless I misunderstood the Xilinx spec, this looks
> like the right way to do and the only one we should support.

Huh? That makes no sense. This device out in the wild with both big
and little endian bus attachments. You can argue all day that one of
them is wrong, but it doesn't matter. It exists, is used, and must be
supported. In fact, the driver already knows about this and figures
out at runtime how the device is wired up to the bus. This is not the
problem.

BTW, that document describes only one of the systemace bus
attachments. There is a different on used on Microblaze little-endian,
and some boards have the SystemACE directly wired to the SoC external
bus (no adapter IP).

The only problem that I see is that the ARM and Microblaze
ioread16be/iowrite16be helpers are missing barriers which smells like
a bug and should be fixed.

Michal, have you tested Alexey's patch? If it works for you then I'm
comfortable with acking it. It looks correct to me.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
