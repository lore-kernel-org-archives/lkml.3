Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaILAqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:46:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:29312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbaILAqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:46:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="572051688"
Date: Fri, 12 Sep 2014 08:45:50 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Huang Shijie <shijie8@gmail.com>, Mike Voytovich <mvoytovich@paypal.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140912004550.GB26904@shldeISGChi005.sh.intel.com>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911120928.GA1585@localhost.localdomain>
 <20140911143616.3ebb025a@bbrezillon>
 <20140911142511.GA2543@localhost.localdomain>
 <20140911163847.5e2f85c7@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911163847.5e2f85c7@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:38:47PM +0200, Boris BREZILLON wrote:
> Hi Huang,
> 
> On Thu, 11 Sep 2014 22:25:13 +0800
> Huang Shijie <shijie8@gmail.com> wrote:
> 
> > Hi Boris,
> > 
> > On Thu, Sep 11, 2014 at 02:36:16PM +0200, Boris BREZILLON wrote:
> > > Hi Huang,
> > > 
> > > On Thu, 11 Sep 2014 20:09:30 +0800
> > > Huang Shijie <shijie8@gmail.com> wrote:
> > > 
> > > > On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> > > > > Several MTD users (either in user or kernel space) expect a valid raw
> > > > > access support to NAND chip devices.
> > > > > This is particularly true for testing tools which are often touching the
> > > > > data stored in a NAND chip in raw mode to artificially generate errors.
> > > > > 
> > > > > The GPMI drivers do not implemenent raw access functions, and thus rely on
> > > > > default HW_ECC scheme implementation.
> > > > > The default implementation consider the data and OOB area as properly
> > > > > separated in their respective NAND section, which is not true for the GPMI
> > > > > controller.
> > > > > In this driver/controller some OOB data are stored at the beginning of the
> > > > > NAND data area (these data are called metadata in the driver), then ECC
> > > > > bytes are interleaved with data chunk (which is similar to the
> > > > > HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> > > > > OOB data.
> > > > > 
> > > > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > > ---
> > > > > Hello,
> > > > > 
> > > > > This patch is providing raw access support to the GPMI driver which is
> > > > > particularly useful to run some tests on the NAND (the one coming in
> > > > > mind is the mtd_nandbiterrs testsuite).
> > > > > 
> > > > > I know this rework might break several user space tools which are relying
> > > > > on the default raw access implementation (I already experienced an issue
> > > > > with the kobs-ng tool provided by freescale), but many other tools will
> > > > > now work as expected.
> > > > If the kobs-ng can not works, there is no meaning that other tools
> > > > works.  So I do not think we need to implement these hooks.
> > > 
> > > Well, I don't know about freescale specific tools, but at least I have
> > > an example with mtd_nandbiterrs module.
> > 
> > The gpmi uses the hardware ECC for the bitflips.
> > I really do not know why the mtd_nandbiterrs is needed.
> > IMHO, the mtd_nandbiterrs is useless for the gpmi.
> 
> Because some folks would like to test their NAND controller/chip on
> their system.
> 
> Just because you don't need it, doesn't mean others won't, and actually
> the reason I worked on these raw function is becaused I needed to
> validate the ECC capabilities of the GPMI ECC controller.
The BCH's algorithm is confidential to Freescale. 
How can you validate the ECC capabilities?
So You can not emulate the BCH to create the ECC data, even you can fake
some bitflips in the data chunk. 

> 
> > 
> > > This module is assuming it can write only the data part of a NAND page
> > > without modifying the OOB area (see [1]), which in GPMI controller case
> > > is impossible because raw write function store the data as if there
> > > were no specific scheme, while there is one:
> > > (metadata + n x (data_chunk + ECC bytes) + remaining_bytes).
> > > 
> > > Moreover, IMHO, nanddump and nandwrite tools (which can use raw
> > > access mode when passing the appropriate option) should always return
> > > the same kind of data no matter what NAND controller is in use on the
> > > system => (DATA + OOB_DATA), and this is definitely not the case with
> > > the GPMI driver.
> > > 
> > > See how raw access on HW_ECC_SYNDROME scheme is implemented in
> > The gpmi uses the NAND_ECC_HW, not the NAND_ECC_HW_SYNDROME.
> 
> Yes I know. I pointed out the NAND_ECC_HW_SYNDROME scheme as an example
> to show you that NAND controller specific layout should be hidden to
> the MTD user.
> 
> > Even you really want to support the nanddump, i do not agree to add the
> > write hook, it may crash the system.
> 
> We can't have an asymetric behaviour here, either we move both read and
> write raw functions or none. Moving only one of them would make the MTD
> user work even more complicated.
> 
> I really don't get your point here. What's really bothering you (BTW, I
> fixed kobs-ng to handle this new behaviour) ?
see the comment above.

thanks
Huang Shijie
