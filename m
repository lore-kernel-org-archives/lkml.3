Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab3BGVS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:18:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:52991 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412Ab3BGVS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:18:57 -0500
Message-ID: <1360271904.2650.40.camel@pasglop>
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
Date: Fri, 08 Feb 2013 08:18:24 +1100
In-Reply-To: <5113DCC1.7040902@synopsys.com>
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
	 <5113DCC1.7040902@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 20:56 +0400, Alexey Brodkin wrote:
> > So, if I'm correct that means that for the data port (specifically
> > copying between RAM and the data port) using ioread16/iowrite16 on the
> > data port results in the correct behaviour. It also means that LE
> > support in the current driver is broken.
> 
> That matches my earlier note when I wrote that for correct work on LE 
> (note I'm on ARC, not PPC/MB) I needed to use "io{read|write}16" in 
> "ace_data{in|out}_le16".
> 
> With original "io{read|write}16be" instead data was corrupted.

For the "backward wiring case" your data port will always be the opposite
endian as your host. For the "correct wiring" case, the data port will always
be the same endian as your host.

So the correct wiring case (the one using ioread16/iowrite16 for registers),
the data port should just use ioread16_rep.

For the other case, you need some ifdef'ery or raw variants with home made
barriers, or a bounce buffer.

Ben.


