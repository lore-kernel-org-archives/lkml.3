Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3FJHQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:16:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48740 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3FJHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:16:02 -0400
Date: Mon, 10 Jun 2013 09:15:57 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Joel A Fernandes <agnel.joel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "Fernandes, Joel A" <joelagnel@ti.com>
Subject: Re: Block layer / MMC: Order of segments in SG-list
Message-ID: <20130610071557.GJ26541@kernel.dk>
References: <CAD=GYpbFF_F+5xdf3PirbNkfjym+iZtHBVPuney=7fvi_yYDSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=GYpbFF_F+5xdf3PirbNkfjym+iZtHBVPuney=7fvi_yYDSA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09 2013, Joel A Fernandes wrote:
> Hi,
> So I tried dumping addresses of an SG list in omap_hsmmc driver before
> it is passed to DMA.
> 
> I found some interesting traces occasionally such as the below SG list
> of length 4.
> 
> [    6.758716] (0) length=4096, sg virt addr=c1318000, sg phy addr=81318000
> [    6.765863] (1) length=4096, sg virt addr=c1317000, sg phy addr=81317000
> [    6.773011] (2) length=4096, sg virt addr=c1316000, sg phy addr=81316000
> [    6.780087] (3) length=4096, sg virt addr=c1315000, sg phy addr=81315000
> 
> What is interesting is these chunks are really physically contiguous
> but in reverse order in the list. I think a smarter ordering can
> actually improve through put considerably and save precious DMA
> resources by not having to allocate slots for parts of contiguous
> chunk of physical memory.
> 
> Is there any particular reason why this might be the case? I traced to
> find that the SG list is actually prepared by mmc_queue_map_sg ->
> blk_rq_map_sg

mmc or the block layer can't do much about the memory it is handed. The
sg mappings just reflect the fact that they happened to be in reverse,
so to speak. You are right in that having those pages in the right order
and being able to merge the segments is a win. Unless you are heavily SG
entry starved or your DMA controller has a high per-sg-entry overhead,
it's usually not a big deal.

That said, you should investigate WHY they are in that order :-)

-- 
Jens Axboe

