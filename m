Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3ENNvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:51:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55548 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab3ENNvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:51:35 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
Date: Tue, 14 May 2013 15:51:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <201305111330.05046.heiko@sntech.de> <201305111331.25405.heiko@sntech.de> <CACRpkda-wQyo8aYxbW9RJNcR3Kwe2w5AhaAuUHfaxBksa_Pm2A@mail.gmail.com>
In-Reply-To: <CACRpkda-wQyo8aYxbW9RJNcR3Kwe2w5AhaAuUHfaxBksa_Pm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201305141551.24375.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Mai 2013, 14:47:19 schrieb Linus Walleij:
> On Sat, May 11, 2013 at 1:31 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > with numerous virtual channels being mapped to a lot less physical ones.
> > The driver therefore borrows a lot from the amba-pl08x driver in this
> > regard. Functionality-wise the driver gains a memcpy ability in addition
> > to the slave_sg one.
> > 
> > The driver currently only supports the "newer" SoCs which can use any
> > physical channel for any dma slave. Support for the older SoCs where
> > each channel only supports a subset of possible dma slaves will have to
> > be added later.
> > 
> > Tested on a s3c2416-based board, memcpy using the dmatest module and
> > slave_sg partially using the spi-s3c64xx driver.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> So have I understood correctly if I assume that *some* S3C
> variants, i.e. this: arch/arm/mach-s3c64xx/dma.c
> have a vanilla, unmodified, or just slightly modified
> PL08x block, while this DMAC is something probably based on
> the PL08x where some ASIC engineer has had a good time hacking
> around in the VHDL code to meet some feature requirements.
> Correct? Or plausible guess?

You're guess is at good as mine :-) . The public s3c64xx (ARM11 based) 
documentation says that it is using s PL080 as dma controller while the 
s3c24xx (ARM9 based) SoCs have this one, which doesn't come with any label in 
the manuals.
Similar to the s3c64xx using a vic, while the s3c24xx uses something 
homegrown.

The relationship description was more based on the concepts used, i.e. the 
virtual channel concept and general handling of dma transfers feel somehow 
similar - as I said these are my first steps into this, so I still need to 
understand a lot.


> Exactly *how* far away from the pl08x hardware is it?
> 
> I guess you have already come to the conclusion that the
> amba-pl08x.c driver cannot be augmented to handle this hardware
> after some educated reading of that code?
> 
> But are really no parts reusable?
> 
> For example, if the LLIs have the same layout, could we split
> out the LLI handling from amba-pl08x into a separate file and reuse
> that?

The s3c24xx-dma doesn't have these. You simply put source and destination 
addresses on the bus, tell it the number of transfers and start it, while the 
pl080 seems to split these then into the LLIs, which seems to be some kind of 
hardware feature.

For the rest, the register-layout of the controller is completely different (I 
checked the PL080 manual), each channel has its own interrupt and the above 
mentioned missing LLIs.

Both drivers share somehow how they handle end of transfers, i.e. how they 
reuse the physical channel for a possible waiting virtual channel. But it 
didn't look like anything worth factoring out.


> The more you share with amba-pl08x the better for everyone,
> I am positively sure. And please include Russell on the review
> chain, he wrote the virtual channel abstraction.

I think the best feature is already factored out - the virtual channel 
handling, which was very nice to have.

I used the list from get_maintainer.pl, so sorry for forgetting Russel.


> If I was given the option amongst S3C work I would definatley
> have augmented the amba-pl08x.c to handle the stuff in
> arch/arm/mach-s3c64xx/dma.c *first* then started to work on
> this driver, but I guess you might not be working on s3c64xx?

correct, my pet-project is s3c2416-based [0], so I haven't seen any other 
Samsung stuff at all.


Heiko


[0] http://www.youtube.com/user/mmind81
