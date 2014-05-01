Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaEAR7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:59:50 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:53775 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaEAR7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:59:48 -0400
Date: Thu, 1 May 2014 11:59:46 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] mtd: nand: add randomizer support
Message-ID: <20140501175946.GA14539@obsidianresearch.com>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
 <20140501163407.GB3296@obsidianresearch.com>
 <536284E1.50001@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536284E1.50001@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 07:31:13PM +0200, Boris BREZILLON wrote:

> I totally agree with you, this is not a randomizer but rather a scrambler.
> The reason I chose the "randomizer" word is that all the documents I
> read are talking about randomizers.
> But, other than I don't have any concern about changing all references
> to "randomizer" into "scrambler" ;-).

If nobody else says anything, Scrambler is at least consistent with
Wikipedia..

and 'descrambler' sounds better than 'unrandomizer' :)
 
> > BTW, there are security concerns here. The scrambler PRBS must not be
> > predictable by the user, otherwise they can write data that undoes the
> > scramble and defeat it, ie deliberately writing the last 2k of a 4k
> > write block as all 0's after scrambling could cause the first 2k to be
> > lost. That feels like something that could be scary ..
> 
> AFAICT, the scramblers/randomizers used in NAND applications are all
> predictable, which means the scrambler state does not depend on the last
> data being scrambled.

Right, I'm not surprised storage would use a synchronous scrambler,
self-synchronizing scramblers make the most sense for communication..

However, with a synchronous scrambler the security concern boils down
to how robust and unpredictable is the PRBS.

For instance, re-using the same PRBS seed and staring point for every
block is probably a bad idea.

At the very least I would think the block number should be included in
the per-block seed of the PRBS.

And also a per-parition/device global seed..

I suspect even a properly seeded LFSR is sufficent, but by no means
have I studied this :)

> For example, the sunxi HW scrambler is using a Fibonacci LFSR [1].
> Do you have any example of non predictable scrambler that are used to
> scramble NAND data ?

The benifit here is that the scrambled data is completely private to
the driver and flash chip. So any attack on the scrambler would have
to use the driver as some kind of oracle to search for
synchornization. Eg running through the full keyspace of an N-Bit LFSR
by writing an anti-scrambled block, reading it back and checking if it
is corrupted.

This is why per-block randomization of the PRBS is very important - if
the attacker has only filesytems access then they don't know the block
number and now have to attack the filesystem block allocator as well
as the LFSR block-independent seed to generate an anti-scrambler data
pattern.

But that is just an off the cuff feeling. It would be smart to study
it further :)

Regards,
Jason
