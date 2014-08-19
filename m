Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaHSCMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:12:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55978 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaHSCMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:12:52 -0400
Date: Mon, 18 Aug 2014 19:12:48 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: pekon@pek-sem.com
Cc: Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140819021248.GR18411@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
 <20140805142324.GA10136@lee--X1>
 <d4ba973a22bd71eaff94be1f479c5334@pek-sem.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4ba973a22bd71eaff94be1f479c5334@pek-sem.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:32:18AM +0530, pekon@pek-sem.com wrote:
> On Tuesday 05 August 2014 07:53 PM, Lee Jones wrote:
> >On Thu, 03 Jul 2014, Gupta, Pekon wrote:
> >>>>+	/* Load last page of block */
> >>>>+	offs = (loff_t)block << chip->phys_erase_shift;
> >>>>+	offs += mtd->erasesize - mtd->writesize;
> >>>>+	if (bch_read_page(nandi, offs, buf) < 0) {
> >>
> >>*Important*: You shouldn't call internal functions directly here..
> >>Instead use chip->_read() OR mtd-read() that will:

I'm not sure exactly what you're saying in the above line (chip->_read()
is not a function, and and mtd-read() is syntactically incorrect),
but...

You most certainly do *not* want to call mtd->_read() directly (or any
of the callbacks prefixed with underscores). That is one of the main
purposes of:

    commit 3c3c10bba1e4ccb75b41442e45c1a072f6cded19
    Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Date:   Mon Jan 30 14:58:32 2012 +0200

        mtd: add leading underscore to all mtd functions

> >>- keep this code independent of ECC modes added in your driver
> >>in future.
> >>- implicitly handle updating mtd->ecc_stat (like ecc_failed,
> >>bits_corrected).
> >>- implicitly take care of address alignments checks and offset
> >>calculations.
> >>
> >><Same applies to other places where you have directly used
> >>bch_read_page())
> >
> >Yourself and Brian seem to disagree on this point.  Which is correct?

I think you've worked out a decent solution in your latest series, but
a few of the guiding principles:

 * BBT code can rely on generic NAND implementation details (e.g.,
   chip->options), but it can also act as an MTD user (i.e., use the
   mtd_*() APIs)

 * It should not rely on details of the particular NAND driver (e.g.,
   calling your ST bch_read_page())

 * Look at similar code and try to follow its pattern where it makes
   sense. So while nand_bbt.c is not a shining example in all regards, I
   think it does OK in terms of some of the key points of layering.

> >>>>+	/* Is block already considered bad? (will also catch
> >>>>invalid offsets) */
> >>>>+	ret = mtd_block_isbad(mtd, offs);
> >>>
> >>>You're violating some of the layering here; the low-level driver
> >>>probably shouldn't be calling the high-level mtd_*() APIs. On
> >>>a similar
> >>>note, I'm not 100% confident that the nand_base/nand_bbt
> >>>separation is
> >>>written cleanly enough for easy maintenance of your nand_base
> >>>+ ST BBT
> >>>code in parallel. I might need a second look at that, and I think
> >>>modularizing your BBT code to a separate file could help ease
> >>>this a
> >>>little.
> >
> >... here is the converse argument.

I think I clarified this one; I misspoke about the mtd_*() APIs.

> I think somewhere in earlier comments, Brian also supported
> to use high-level function like mtd_read(). Also, nand_bbt.c
> itself uses 'mtd_read(), mtd_read_oob() and mtd_write_oob()
> at many places. So I'll let Brain decide here.
> But having low-level function will add redundant code for
> re-checking and aligning the addresses boundaries to block
> and page/sector sizes.

Not all checks are redundant. It's redundant to have the direct
descendant doing the same checks that the parent does, like:

  mtd_read() (checks boundaries)
  |_ mtd->_read() (e.g., nand_read())

So nand_read() and nand_do_read_ops() don't need the checking.

But for a BBT implementation, it can help to make sure that its
page/block/etc. arithmetic fits the right bounds when it ends up
deciding to scan a block.

Now, it still may be easy to prove that the checks are
redundant/unnecessary for correctly-written code, but if the layering
makes sense, then it still may be a better choice to simply use the
high-level, self-checking API than to try to dig deeper. For instance,
I'm pretty sure UBI does some checks to make sure it's not reading off
the end of an MTD, but it still calls mtd_read() because it's The Right
Thing (TM).

Brian
