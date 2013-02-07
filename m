Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab3BGVQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:16:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:58361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab3BGVQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:16:23 -0500
Message-ID: <1360271743.2650.38.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Date: Fri, 08 Feb 2013 08:15:43 +1100
In-Reply-To: <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
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
	 <1360186550.2650.4.camel@pasglop>
	 <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com>
	 <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com>
	 <5113C459.8000602@synopsys.com>
	 <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
	 <5113C818.9050307@synopsys.com>
	 <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 16:44 +0000, Grant Likely wrote:
> 
> I've just spent some quality time with a piece of paper, and I think
> I've figured it out...

http://linuxplumbers.ubicast.tv/videos/big-and-little-endian-inside-out/

Watch the last part on IO busses....

This all has to do which which byte of the bus is the lowest byte
*address* regardless of significance. That's how the wiring should be
consistent between CPU and device, in order for a data port to work
properly.

The data port then requires no swapping (which also means it works
nicely with dumb DMA engines etc...)

Whether the registers need swapping or not depends on which half is the
MSB, which is somewhat a semantically higher level than the bus
transport, and depends on whether the device exposes them as BE or LE
registers. But data ports are just "windows" to a byte stream and
shouldn't be affected by endianess (again, unless you get a moron doing
the HW which seems to be still too common).

There is only one right way to connect devices to CPUs basically, which
is called byte address invariance, and preserves the order of bytes in
term of byte addresses.

(Note that for busses that also carry addresses such as PCI, this can
get tricky as you might need to have the lanes routed in a different
order for address vs. data cycles).

Cheers,
Ben.


