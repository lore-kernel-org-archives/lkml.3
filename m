Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaDILJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:09:43 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36353 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbaDILJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:09:41 -0400
X-Auth-Info: XRoQK8t8c5wDx7Upqv+q0k8zMq/bijc6HVEKHPNMfBQ=
Date: Wed, 9 Apr 2014 13:09:33 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Marek Vasut <marex@denx.de>
Cc: grmoore@altera.com, ggrahammoore@gmail.com,
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
Subject: Re: [PATCH] Add support for flag status register on Micron chips
Message-ID: <20140409110933.GS11339@book.gsilab.sittig.org>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
 <201404091203.24956.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404091203.24956.marex@denx.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 12:03 +0200, Marek Vasut wrote:
> 
> On Tuesday, April 08, 2014 at 06:12:49 PM, grmoore@altera.com wrote:
> > From: Graham Moore <grmoore@altera.com>
> > 
> > This is a slightly different version of the patch that Insop Song
> > submitted
> > (http://marc.info/?i=201403012022.10111.marex%20()%20denx%20!%20de).
> > 
> > I talked to Insop, and he agreed I should submit this patch as a follow-on
> > to his.
> > 
> > This patch uses a flag in the m25p_ids[] array to determine which chips
> > need to use the FSR (Flag Status Register).
> > 
> > Rationale for using the FSR:
> > 
> > The Micron data sheets say we have to do this, at least for the multi-die
> > 512M and 1G parts (n25q512 and n25q00).  In practice, if we don't check
> > the FSR for program/erase status, and we rely solely on the status
> > register (SR), then we get corrupted data in the flash.
> 
> I talked to Gerhard yesterday and he told me there is something like that on 
> ONFI NAND. I think I now understand why that new register is in-place. 
> Apparently, in the ONFI NAND case, there is a READY and TRUE-READY signal and 
> one of those reflects that _all_ the dies have finished their operation. This is 
> in my opinion seriously misdesigned as it breaks any kind of backward 
> compatibility.

There's a little more to it, I think.

The "ready" and "true ready" are terms from Linux header files.
In Micron datasheets, both of the bits 5 and 6 in the READ_STATUS
response are referred to as "ready/busy", with a few footnotes to
them depending on the mode of operation or the command that is
being executed.

The other thing is that there is the READ_STATUS command, which
_might_ yield responses from different dies upon subsequent
repeated reads.  So you may have to determine how many dies are
in the package, to repeat the STATUS query as many times, and
logically combine these results in the chip's overall status.  Or
use the extended status query where you can address an individual
die, but which is not supported by every chip.  Pick your poison.

The hardware R/B pins are wired-OR, such that any busy die will
pull the summary pin level low.  But this only tells you whether
the operation is still pending, after it's complete you have to
get the status and will face the situation described above.

Can't tell how this NAND approach maps to the NOR subject
described here.  They might have a similar motivation, yet
implement different approaches to the issue.

> > Micron told us (Altera) that for multi-die chips based on the 65nm 256MB
> > die, we need to check the SR first, then check the FSR, which is why the
> > wait_for_fsr_ready function does that.  Future chips based on 45 nm 512MB
> > die will use the FSR only.

This sounds to me similar to polling the NAND's R/B pin until the
operation has completed, to then fetch the STATUS byte to
determine the execution's result.  Does this sound plausible?
For NOR, do you poll for the "busy" condition to deassert, and
check for success then?


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
