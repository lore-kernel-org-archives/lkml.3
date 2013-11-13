Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab3KMPkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:40:43 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48298 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3KMPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:40:40 -0500
Date: Wed, 13 Nov 2013 09:40:22 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Dan Streetman <ddstreet@ieee.org>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: mm/zswap: change to writethrough
Message-ID: <20131113154022.GA6277@cerebellum.variantweb.net>
References: <CALZtONAxsYxLizARV3Aam_n7534g5gh_FFkTz6jb-0Q9gThuBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZtONAxsYxLizARV3Aam_n7534g5gh_FFkTz6jb-0Q9gThuBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:12:12PM -0500, Dan Streetman wrote:
> Seth, have you (or anyone else) considered making zswap a writethrough
> cache instead of writeback?  I think that it would significantly help
> the case where zswap fills up and starts writing back its oldest pages
> to disc - all the decompression work would be avoided since zswap
> could just evict old pages and forget about them, and it seems likely
> that when zswap is full that's probably the worst time to add extra
> work/delay, while adding extra disc IO (presumably using dma) before
> zswap is full doesn't seem to me like it would have much impact,
> except in the case where zswap isn't full but there is so little free
> memory that new allocs are waiting on swap-out.

There are two main benefits to zswap:
1) avoid write to swap space while the compressed pool is not full and
2) reduce application delay on anonymous page faults

Doing a writethough approach eliminates benefit 1 as there would
be just as much swap out activity with or without zswap.  However, you
still retain benefit 2.

The reclaim from zswap also becomes much simplier if the the compressed
page can be treated as clean.  It doesn't need to be written back and
can just be freed and the bit in the frontswap_map unset.

I'm not opposed to this.  The obstacle of writeback has influenced the
design a lot more than I would have liked.  You do lose the benefit of
decreased swap out traffic, but the real performance killer, application
latency on an anonymous page fault, is still greatly improved.

Seth
