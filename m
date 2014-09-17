Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaIQSQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:16:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55332 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755834AbaIQSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:16:49 -0400
Date: Wed, 17 Sep 2014 20:16:44 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie.huang@intel.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Roy Lee <roylee@paypal.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140917201644.43df2cd7@bbrezillon>
In-Reply-To: <20140917152609.GA2111@localhost.localdomain>
References: <20140911120928.GA1585@localhost.localdomain>
	<20140911143616.3ebb025a@bbrezillon>
	<20140911142511.GA2543@localhost.localdomain>
	<20140911163847.5e2f85c7@bbrezillon>
	<20140912004550.GB26904@shldeISGChi005.sh.intel.com>
	<20140912143050.014ad4c3@bbrezillon>
	<20140913153622.GA10132@localhost.localdomain>
	<20140913173841.GA18093@brian-ubuntu>
	<20140915144259.GA1947@localhost.localdomain>
	<20140915221210.5d9871fb@bbrezillon>
	<20140917152609.GA2111@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Wed, 17 Sep 2014 23:26:11 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> On Mon, Sep 15, 2014 at 10:12:10PM +0200, Boris BREZILLON wrote:
> > On Mon, 15 Sep 2014 22:43:02 +0800
> > Huang Shijie <shijie8@gmail.com> wrote:
> > 
> > > On Sat, Sep 13, 2014 at 10:38:41AM -0700, Brian Norris wrote:
> > > > On Sat, Sep 13, 2014 at 11:36:24PM +0800, Huang Shijie wrote:
> > > > > On Fri, Sep 12, 2014 at 02:30:50PM +0200, Boris BREZILLON wrote:
> > > > > > This test validates what's returned by ecc_strength file in sysfs
> > > > > > (which in turn is specified by the NAND controller when initializing
> > > > > > the NAND chip).
> > > > > > 
> > > > > > Doing this should not imply knowing the ECC algorithm in use in the
> > > > > > NAND controller or the layout used to store data on NAND.
> > > > > the difficulty is that the ECC parity area can be not byte aligned.
> > > > 
> > > > Is there a problem with just rounding up to the nearest byte alignment
> > > > and ignoring the few bits that are wasted?
> > > 
> > > I feel a little confused with the two hooks.
> > > 
> > > does the ecc->write_page_raw need to write the ECC parity data?
> > 
> > Depending on the oob_required argument, it might be allowed to
> > overwrite the ECC bytes even if this implies breaking page reliability
> > (which is exactly what's expected).
> > 
> > When using raw write with with oob write option the writer should take
> > care of regenerating ECC bytes (which you said was impossible in GPMI
> > case) or copying them from a previous raw read.
> Thanks for the explanation.
> 
> If we do not write the OOB, should we write the ECC bytes?

No we shouldn't, and if you take a look at my new proposal you'll see
that I always write ECC bytes even when oob_required is not required,
but this is not a problem because in this case the nand_base code has
already set the oob area to 0xff and, if I'm correct, writing 0xff is
just like leaving the area unwritten.

Of course leaving the ECC bytes to 0xff after a page erase will
certainly trigger ECC errors when reading the page back in normal mode,
but this is the MTD user responsibility to know what he's doing.

> The hooks should comment clearly about how to implement them :(

Absolutely, and if we all agree on the expected behavior, I'll be happy
to document it ;-).

> 
> > 
> > Here is a real example of what one could test with raw write + oob:
> > 1) read a page in raw mode
> > 2) flip some bits in the generated ECC bytes (or what you references as
> >    parity data) (this case can actually happen in real life)
> > 3) write the modified page in raw mode
> > 4) read back the same page in normal and check that ECC correction still
> >    works as expected
> the nandbiterr test mode does the test as above.
> But i think the multi-writes to the same page should occur only for the
> SLC nand.

I already have a patch for that :-):

http://code.bulix.org/f69wuu-87021

This patch is erasing the NAND block between each bitflip insertion so
that it can work on MLC nandflashes too.
Anyway, IMHO this nandbiterrs testsuite should be implemented in a
user-space tool (which could be part of mtd-utils) because we already
have all the primitives we need to do it from there (ioctls to access
NAND chips in raw mode).

> 
> I will read your new patch set carefully in this weekend.

Thanks.

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
