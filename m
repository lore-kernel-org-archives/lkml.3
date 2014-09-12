Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaILMbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:31:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54392 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953AbaILMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:31:04 -0400
Date: Fri, 12 Sep 2014 14:30:50 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie.huang@intel.com>
Cc: Huang Shijie <shijie8@gmail.com>, Mike Voytovich <mvoytovich@paypal.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140912143050.014ad4c3@bbrezillon>
In-Reply-To: <20140912004550.GB26904@shldeISGChi005.sh.intel.com>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911120928.GA1585@localhost.localdomain>
	<20140911143616.3ebb025a@bbrezillon>
	<20140911142511.GA2543@localhost.localdomain>
	<20140911163847.5e2f85c7@bbrezillon>
	<20140912004550.GB26904@shldeISGChi005.sh.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 08:45:50 +0800
Huang Shijie <shijie.huang@intel.com> wrote:

> On Thu, Sep 11, 2014 at 04:38:47PM +0200, Boris BREZILLON wrote:
> > Hi Huang,
> > 
> > On Thu, 11 Sep 2014 22:25:13 +0800
> > Huang Shijie <shijie8@gmail.com> wrote:
> > 
> > > Hi Boris,
> > > 
> > > On Thu, Sep 11, 2014 at 02:36:16PM +0200, Boris BREZILLON wrote:
> > > > Hi Huang,
> > > > 
> > > > On Thu, 11 Sep 2014 20:09:30 +0800
> > > > Huang Shijie <shijie8@gmail.com> wrote:
> > > > 
> > > > > On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> > > > > > Several MTD users (either in user or kernel space) expect a valid raw
> > > > > > access support to NAND chip devices.
> > > > > > This is particularly true for testing tools which are often touching the
> > > > > > data stored in a NAND chip in raw mode to artificially generate errors.
> > > > > > 
> > > > > > The GPMI drivers do not implemenent raw access functions, and thus rely on
> > > > > > default HW_ECC scheme implementation.
> > > > > > The default implementation consider the data and OOB area as properly
> > > > > > separated in their respective NAND section, which is not true for the GPMI
> > > > > > controller.
> > > > > > In this driver/controller some OOB data are stored at the beginning of the
> > > > > > NAND data area (these data are called metadata in the driver), then ECC
> > > > > > bytes are interleaved with data chunk (which is similar to the
> > > > > > HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> > > > > > OOB data.
> > > > > > 
> > > > > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > > > ---
> > > > > > Hello,
> > > > > > 
> > > > > > This patch is providing raw access support to the GPMI driver which is
> > > > > > particularly useful to run some tests on the NAND (the one coming in
> > > > > > mind is the mtd_nandbiterrs testsuite).
> > > > > > 
> > > > > > I know this rework might break several user space tools which are relying
> > > > > > on the default raw access implementation (I already experienced an issue
> > > > > > with the kobs-ng tool provided by freescale), but many other tools will
> > > > > > now work as expected.
> > > > > If the kobs-ng can not works, there is no meaning that other tools
> > > > > works.  So I do not think we need to implement these hooks.
> > > > 
> > > > Well, I don't know about freescale specific tools, but at least I have
> > > > an example with mtd_nandbiterrs module.
> > > 
> > > The gpmi uses the hardware ECC for the bitflips.
> > > I really do not know why the mtd_nandbiterrs is needed.
> > > IMHO, the mtd_nandbiterrs is useless for the gpmi.
> > 
> > Because some folks would like to test their NAND controller/chip on
> > their system.
> > 
> > Just because you don't need it, doesn't mean others won't, and actually
> > the reason I worked on these raw function is becaused I needed to
> > validate the ECC capabilities of the GPMI ECC controller.
> The BCH's algorithm is confidential to Freescale. 
> How can you validate the ECC capabilities?

My bad, capabilities might not be the appropriate word in this context.
I meant ECC algorithm strength, and that's exactly the purpose of
nandbiterrs testsuite: insert bitflips in in-band data until the MTD
layer complains about uncorrectable errors.
This test validates what's returned by ecc_strength file in sysfs
(which in turn is specified by the NAND controller when initializing
the NAND chip).

Doing this should not imply knowing the ECC algorithm in use in the
NAND controller or the layout used to store data on NAND.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
