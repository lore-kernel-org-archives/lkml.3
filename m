Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLYGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 01:09:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaLYGJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 01:09:28 -0500
MIME-Version: 1.0
In-Reply-To: <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
	<d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
Date: Thu, 25 Dec 2014 14:09:25 +0800
Message-ID: <CACVXFVOqaBWNa+zR-YsRQfaeCs7oB03mo2Rze4x+_gbOyYj_mA@mail.gmail.com>
Subject: Re: [RFC PATCH 01/17] block: make generic_make_request handle
 arbitrarily sized bios
From: Ming Lei <ming.lei@canonical.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>,
        Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 7:48 PM, Dongsu Park
<dongsu.park@profitbricks.com> wrote:
> From: Kent Overstreet <kmo@daterainc.com>
>
> The way the block layer is currently written, it goes to great lengths
> to avoid having to split bios; upper layer code (such as bio_add_page())
> checks what the underlying device can handle and tries to always create
> bios that don't need to be split.
>
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could
> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.  In the future this will
> let us delete merge_bvec_fn and a bunch of other code.

Looks it is a very good idea to split bio in block.

>
> We do this by adding calls to blk_queue_split() to the various
> make_request functions that need it - a few can already handle arbitrary

I am wondering why the bio isn't splitted just before q->make_request_fn
is called in generic_make_request()?  By this way, drivers won't need
to call blk_queue_split() at all.  Is it because performance reason? or
others?

> size bios. Note that we add the call _after_ any call to
> blk_queue_bounce(); this means that blk_queue_split() and
> blk_recalc_rq_segments() don't need to be concerned with bouncing
> affecting segment merging.
>
> Some make_request_fn() callbacks were simple enough to audit and verify
> they don't need blk_queue_split() calls. The skipped ones are:
>
>  * nfhd_make_request (arch/m68k/emu/nfblock.c)
>  * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
>  * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
>  * brd_make_request (ramdisk - drivers/block/brd.c)
>  * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
>  * loop_make_request
>  * null_queue_bio
>  * bcache's make_request fns

I guess the above drivers haven't max_sectors/max_segment
limit.

Thanks,
Ming Lei
