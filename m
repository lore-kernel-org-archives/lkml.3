Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaJMPYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:24:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:32881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaJMPYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="617784327"
Message-ID: <1413213803.7906.45.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 18:23:23 +0300
In-Reply-To: <543BE21F.5020504@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
			 <1412029248-22454-4-git-send-email-richard@nod.at>
		 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
	 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 16:30 +0200, Richard Weinberger wrote:
> Am 13.10.2014 um 15:17 schrieb Artem Bityutskiy:
> > On Fri, 2014-10-03 at 21:06 +0200, Richard Weinberger wrote:
> >> Fastmap needs basically access to all internal state of UBI, which
> >> lives mostly
> >> within wl.c
> > 
> > Sounds like a very strong assertion, smells a bit fishy, need the
> > details.
> 
> Fastmap need to know the exact state of each PEB.
> I.e. is it free, used, scheduled for erase, etc...
> 
> >> It needs to iterate over the used, free, erase, scrub RB-trees, the
> >> protection queue, etc. to
> >> collect the exact state of all PEBs.
> > 
> > When? In 'ubi_write_fastmap()' when forming the FM pool data structures?
> 
> Yes.
> 
> > I think you can just add a function like this to wl.c:
> > 
> > int ubi_wl_get_peb_info(int pnum, struct ubi_wl_peb_info *pebinfo)
> > 
> > Yoy will give it the PEB number you are interested in, it will return
> > you the information you need in 'pebinfo'. The information will contain
> > the EC, the state (used, free, etc).
> > 
> > If you need just the EC, then you do not even need the ubi_wl_peb_info
> > data structure.
> > 
> > Then you just iterate over all PEBs and fill the FM pool data
> > structures.
> > 
> > Would something like this work?
> 
> The interface would work but some work in wl.c is needed.
> For example if I want to find out in which state PEB 1 is wl.c would have to
> look int free free, used free, protection queue, etc.. to tell me the state. This is slow.

Well, used and free are RB-trees, looking them up is slow.

If what you need is to go through all used and free PEBs, then you can
introduce some kind of

struct ubi_wl_entry *ubi_wl_get_next_used(struct ubi_wl_entry *prev)

function, and similar functions for the free.

I would return you the next entry (or NULL would indicate the end), and
it would take the previous entry as the input, or NULL for the first
call.

We'd need to take the locks before calling this function. This is
cleaner than what we do now, right?

> But we could add the state information to struct ubi_wl_entry by adding a single integer attribute called "state" or "flags".

But there is a price - memory consumption. We do not want to pay it just
for making the inter-subsystems boundaries better, there ought to be a
better reason.

Say, for an (imaginary) 8GiB NAND chip with 128KiB PEB size this would
cost 256KiB of RAM.

Squeezing the state into the last 2 bits a memory reference would be
another possibility, BTW. Not elegant, though...

> Would this make you happy? :)

Not very, I'd save this for the last resort solution.

