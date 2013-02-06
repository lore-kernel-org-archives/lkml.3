Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3BFKEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:04:09 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:33354 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3BFKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <7613336.0C5oRATusX@wuerfel>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
 <51111133.7000105@synopsys.com> <7613336.0C5oRATusX@wuerfel>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Feb 2013 10:03:44 +0000
X-Google-Sender-Auth: xat949EJgzAB8jeCH7BY3UFC0IY
Message-ID: <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 3:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 05 February 2013 18:03:31 Alexey Brodkin wrote:
>> The Xilinx System ACE Compact Flash chip is a true little-endian device
>> and the PLB is a big-endian bus. Therefore the XPS System ACE Interface
>> Controller will do a bit-swap in each byte when connecting the PLB data
>> bus to the System ACE data bus as shown in Table 2.
>>
>> Note however, that the XPS System ACE Interface Controller does not
>> perform the byte swapping necessary to interface to a little-endian
>> device when configured to use 16-bit mode. Therefore, the software
>> drivers provided for this core will perform the necessary byte-swapping
>> to correctly interface to the Xilinx System ACE Compact Flash chip as
>> shown in Table 3.
>
> Ok. In this case, I would recommend making the default for this driver
> little-endian, and adding a quirk for broken hardware bridges like the
> one you cited to have a mixed-endian mode if configured so at compile
> time.
>
> It seems that on all normal platforms, this device should behave as
> little-endian, while the Xilinx bridge can be either big-endian
> or little-endian, depending on whether it is used in 8-bit or 16-bit
> mode, so if we are using this, it cannot be known at compile time.

The driver already handles this. It has three sets of accessors;
8-bit, 16-bit LE and 16-bit BE *and* when doing 16-bit it figures out
on its own which set to use at runtime. There is nothing controversial
here. The only problem is that the driver is currently using in_/out_
IO accessors instead of ioread/iowrite variants.

g.
