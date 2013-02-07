Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3BGMVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:21:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:48498 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345Ab3BGMVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:21:37 -0500
Message-ID: <1360239636.2650.26.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Date: Thu, 07 Feb 2013 23:20:36 +1100
In-Reply-To: <51139974.2040601@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
	 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	 <1360066756.4529.6.camel@pasglop>
	 <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
	 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
	 <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
	 <1360186550.2650.4.camel@pasglop> <51139974.2040601@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 16:09 +0400, Alexey Brodkin wrote:
> 
> BTW I've just realized that in case if there's no bridge between CPU and 
> CF-controller or if this bridge is "transparent" (does no swapping
> neither bytes nor bits) our data accessors here should be changed.
> 
> Isn't it strange in "ace_datain_le16" use "ioread16be" or the one it was 
> here initially "in_be16"?
> With BE ones I'd say similar changes should be done.

This is part of the problem with those bloody attempts at dealing with
broken shit, they get the "right" case wrong :-)

So yes, if the bridge is wired up properly:

 - Register access is LE

 - Data port access is native endian (always) because what matters here
is not endianness but byte ordering (ie, which byte is 0) and if things
are wired properly, this is preserved.

So the correct things is in that case is to use ioread16_rep which will
do the right thing (and avoid the extra barriers and C loop) for the
data in/out code, and ioread16/iowrite16 for the registers.

For the "swapped" case, I would suggest using ioread16be for the registers
for the data port, use ioread16_rep followed by a pass of byteswap. I assume
that this incorrect wiring case only happens on BE platforms right ?

Cheers,
Ben.


