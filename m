Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaEAVbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:31:51 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38486 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaEAVbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:31:50 -0400
Date: Thu, 1 May 2014 15:31:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] mtd: nand: add randomizer support
Message-ID: <20140501213148.GA1563@obsidianresearch.com>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
 <20140501163407.GB3296@obsidianresearch.com>
 <536284E1.50001@free-electrons.com>
 <20140501175946.GA14539@obsidianresearch.com>
 <5362B4E6.7010009@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5362B4E6.7010009@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:56:06PM +0200, Boris BREZILLON wrote:

> > However, with a synchronous scrambler the security concern boils down
> > to how robust and unpredictable is the PRBS.
> 
> I'm not sure security is the main concern here.
> AFAICT, NAND scramblers (note that I stopped using the name "randomizer"
> :-)) is mainly used to avoid large island of identical data, because
> some NAND chips are sensible to such patterns (see [1] page 14).

Right, if you send to the flash 'the wrong data' then some combination of:
1) Retention time till ECC failure is reduced
2) The flash block is permanently damaged early
3) A 'nearby', unrelated flash block has ECC failure due to interference

So, if someone deliberately and maliciously defeats the scrambler and
deliberately sends in wrong data what happens?
 1/3) Delibrate, predictable file system corruption
 2) Create device damage and significantly early replacement of the device.
All could lead to a DOS attack of some sort, at a minimum.

FWIW, there was a similar attack against a certain communication
system. The line scrambler was statistically predictable, and if an
attacker sent enough packets that were the predictable anti-scramble
then enough would align with the scamble pattern and the
communication channel would fail and retrain creating a DOS vector.

For this reason these days com systems tend to use a 58 bit
self-synchronous LFSR for scrambling purposes.

> And this is exactly what's done in the sunxi HW  scrambler
> implementation, or at least you can do it based on what you're
> specifying in your DT (see the "nand-randomizer-seeds" in the 3rd
> patch): you can define a seed table and the seed is selected based on
> the page number you're reading or writing.

Well, re-using fixed (and public) seeds:

 state = rnd->seeds[page % rnd->nseeds];

Just changes the probabilities. For instance, some filesystems can be
asked to create extents with a large alignment (like 2M) to speed IOs,
and a small seeds table means the seeds within such a file will be
fully predictable.

If you are already stuck with this, then fine, it can be a driver
specific binding - but if this is a new green-field design, intended
to be broadly used as a core MTD feature:

I'd suggest just seeding with the block number xor some value, and
using a LFSR with a state space larger than the number of blocks in
the device, and don't specify a seeds array in DT.

Regards,
Jason
