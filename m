Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaDISPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:15:15 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59826 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933910AbaDISOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140409110933.GS11339@book.gsilab.sittig.org>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
	<201404091203.24956.marex@denx.de>
	<20140409110933.GS11339@book.gsilab.sittig.org>
Date: Wed, 9 Apr 2014 13:14:49 -0500
Message-ID: <CA+iBjpSRftzK+eQEqtxEr+t7YNgZneB=WyJHhOkVA8Rd4SPiPg@mail.gmail.com>
Subject: Re: [PATCH] Add support for flag status register on Micron chips
From: Graham Moore <ggrahammoore@gmail.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: Marek Vasut <marex@denx.de>, "grmoore@altera.com" <grmoore@altera.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 6:09 AM, Gerhard Sittig <gsi@denx.de> wrote:
> On Wed, 2014-04-09 at 12:03 +0200, Marek Vasut wrote:
>>
>> On Tuesday, April 08, 2014 at 06:12:49 PM, grmoore@altera.com wrote:
>> > From: Graham Moore <grmoore@altera.com>
>> >
>> > This is a slightly different version of the patch that Insop Song
>> > submitted
>> > (http://marc.info/?i=201403012022.10111.marex%20()%20denx%20!%20de).
>> >
>> > I talked to Insop, and he agreed I should submit this patch as a follow-on
>> > to his.
>> >
>> > This patch uses a flag in the m25p_ids[] array to determine which chips
>> > need to use the FSR (Flag Status Register).
>> >
>> > Rationale for using the FSR:
>> >
>> > The Micron data sheets say we have to do this, at least for the multi-die
>> > 512M and 1G parts (n25q512 and n25q00).  In practice, if we don't check
>> > the FSR for program/erase status, and we rely solely on the status
>> > register (SR), then we get corrupted data in the flash.
[...]
>> > Micron told us (Altera) that for multi-die chips based on the 65nm 256MB
>> > die, we need to check the SR first, then check the FSR, which is why the
>> > wait_for_fsr_ready function does that.  Future chips based on 45 nm 512MB
>> > die will use the FSR only.
>
> This sounds to me similar to polling the NAND's R/B pin until the
> operation has completed, to then fetch the STATUS byte to
> determine the execution's result.  Does this sound plausible?
> For NOR, do you poll for the "busy" condition to deassert, and
> check for success then?

Sounds plausible to me.  We poll the SR until not busy, then poll the
FSR until it's not busy.  Success is when FSR busy is deasserted
within the timeout.

Micron said we have to read the FSR "at least once", so we don't
read it once for every die or anything like that.  I ran a quick
test, and for both the 2-die and 4-die parts, the FSR shows not busy
on the first read after SR not busy.

-Graham
