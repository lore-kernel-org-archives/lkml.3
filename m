Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3BGQ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:56:42 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:63176 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab3BGQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:56:41 -0500
Message-ID: <5113DCC1.7040902@synopsys.com>
Date: Thu, 7 Feb 2013 20:56:33 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com> <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop> <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com> <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop> <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop> <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com> <1360186550.2650.4.camel@pasglop> <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com> <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com> <5113C459.8000602@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com> <5113C818.9050307@synopsys.com> <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
In-Reply-To: <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 08:44 PM, Grant Likely wrote:
>
> Then that data needs to be stored into memory. This is where things
> are different with native 16 bit stores:
>    On a BE memory system. MSB in byte address 0 and LSB in byte address 1.
>    On a LE memory system. MSB in byte address 1 and LSB in byte address 0.
>
> The block subsystem deals with byte oriented buffers; so given the way
> data is arranged in the data port we want to always make sure the LSB
> goes into address 0. The cause of problems isn't the BE vs LE bus
> attachment. It is the different memory system orientation. Using
> ioread16/iowrite16 has the right behaviour, but it's kind of a
> backwards way to go about it.... It isn't that we want a be16_to_cpu()
> or le16_to_cpu() on the data port read, but rather a cpu_to_le16() on
> the store to memory regardless of the endianess of the platform.
>
> So, if I'm correct that means that for the data port (specifically
> copying between RAM and the data port) using ioread16/iowrite16 on the
> data port results in the correct behaviour. It also means that LE
> support in the current driver is broken.

That matches my earlier note when I wrote that for correct work on LE 
(note I'm on ARC, not PPC/MB) I needed to use "io{read|write}16" in 
"ace_data{in|out}_le16".

With original "io{read|write}16be" instead data was corrupted.

-Alexey
