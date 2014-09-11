Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaIKOiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:38:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46979 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbaIKOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:38:51 -0400
Date: Thu, 11 Sep 2014 16:38:47 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140911163847.5e2f85c7@bbrezillon>
In-Reply-To: <20140911142511.GA2543@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911120928.GA1585@localhost.localdomain>
	<20140911143616.3ebb025a@bbrezillon>
	<20140911142511.GA2543@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Thu, 11 Sep 2014 22:25:13 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> Hi Boris,
> 
> On Thu, Sep 11, 2014 at 02:36:16PM +0200, Boris BREZILLON wrote:
> > Hi Huang,
> > 
> > On Thu, 11 Sep 2014 20:09:30 +0800
> > Huang Shijie <shijie8@gmail.com> wrote:
> > 
> > > On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> > > > Several MTD users (either in user or kernel space) expect a valid raw
> > > > access support to NAND chip devices.
> > > > This is particularly true for testing tools which are often touching the
> > > > data stored in a NAND chip in raw mode to artificially generate errors.
> > > > 
> > > > The GPMI drivers do not implemenent raw access functions, and thus rely on
> > > > default HW_ECC scheme implementation.
> > > > The default implementation consider the data and OOB area as properly
> > > > separated in their respective NAND section, which is not true for the GPMI
> > > > controller.
> > > > In this driver/controller some OOB data are stored at the beginning of the
> > > > NAND data area (these data are called metadata in the driver), then ECC
> > > > bytes are interleaved with data chunk (which is similar to the
> > > > HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> > > > OOB data.
> > > > 
> > > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > ---
> > > > Hello,
> > > > 
> > > > This patch is providing raw access support to the GPMI driver which is
> > > > particularly useful to run some tests on the NAND (the one coming in
> > > > mind is the mtd_nandbiterrs testsuite).
> > > > 
> > > > I know this rework might break several user space tools which are relying
> > > > on the default raw access implementation (I already experienced an issue
> > > > with the kobs-ng tool provided by freescale), but many other tools will
> > > > now work as expected.
> > > If the kobs-ng can not works, there is no meaning that other tools
> > > works.  So I do not think we need to implement these hooks.
> > 
> > Well, I don't know about freescale specific tools, but at least I have
> > an example with mtd_nandbiterrs module.
> 
> The gpmi uses the hardware ECC for the bitflips.
> I really do not know why the mtd_nandbiterrs is needed.
> IMHO, the mtd_nandbiterrs is useless for the gpmi.

Because some folks would like to test their NAND controller/chip on
their system.

Just because you don't need it, doesn't mean others won't, and actually
the reason I worked on these raw function is becaused I needed to
validate the ECC capabilities of the GPMI ECC controller.

> 
> > This module is assuming it can write only the data part of a NAND page
> > without modifying the OOB area (see [1]), which in GPMI controller case
> > is impossible because raw write function store the data as if there
> > were no specific scheme, while there is one:
> > (metadata + n x (data_chunk + ECC bytes) + remaining_bytes).
> > 
> > Moreover, IMHO, nanddump and nandwrite tools (which can use raw
> > access mode when passing the appropriate option) should always return
> > the same kind of data no matter what NAND controller is in use on the
> > system => (DATA + OOB_DATA), and this is definitely not the case with
> > the GPMI driver.
> > 
> > See how raw access on HW_ECC_SYNDROME scheme is implemented in
> The gpmi uses the NAND_ECC_HW, not the NAND_ECC_HW_SYNDROME.

Yes I know. I pointed out the NAND_ECC_HW_SYNDROME scheme as an example
to show you that NAND controller specific layout should be hidden to
the MTD user.

> Even you really want to support the nanddump, i do not agree to add the
> write hook, it may crash the system.

We can't have an asymetric behaviour here, either we move both read and
write raw functions or none. Moving only one of them would make the MTD
user work even more complicated.

I really don't get your point here. What's really bothering you (BTW, I
fixed kobs-ng to handle this new behaviour) ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
