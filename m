Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3KKTMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:12:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58713 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3KKTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:12:33 -0500
MIME-Version: 1.0
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 11 Nov 2013 14:12:12 -0500
X-Google-Sender-Auth: GeYhB8mRIdJR-4is0al7pIrrcG0
Message-ID: <CALZtONAxsYxLizARV3Aam_n7534g5gh_FFkTz6jb-0Q9gThuBQ@mail.gmail.com>
Subject: mm/zswap: change to writethrough
To: sjennings@variantweb.net
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com,
        k.kozlowski@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth, have you (or anyone else) considered making zswap a writethrough
cache instead of writeback?  I think that it would significantly help
the case where zswap fills up and starts writing back its oldest pages
to disc - all the decompression work would be avoided since zswap
could just evict old pages and forget about them, and it seems likely
that when zswap is full that's probably the worst time to add extra
work/delay, while adding extra disc IO (presumably using dma) before
zswap is full doesn't seem to me like it would have much impact,
except in the case where zswap isn't full but there is so little free
memory that new allocs are waiting on swap-out.

Besides the additional disc IO that obviously comes with making zswap
writethrough (additional only before zswap fills up), are there any
other disadvantages?  Is it a common situation for there to be no
memory left and get_free_page actively waiting on swap-out, but before
zswap fills up?

Making it writethrough also could open up other possible improvements,
like making the compression and storage of new swap-out pages async,
so the compression doesn't delay the write out to disc.
