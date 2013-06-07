Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3FGIFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:05:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49350 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3FGIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:05:37 -0400
X-AuditID: 9c93016f-b7ba8ae000004f01-17-51b1944ffe14
Date: Fri, 7 Jun 2013 17:05:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 02/10] zram: use zram->lock to protect
 zram_free_page() in swap free notify path
Message-ID: <20130607080534.GB22516@blaptop>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
 <1370534851-26056-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370534851-26056-3-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:07:23AM +0800, Jiang Liu wrote:
> zram_slot_free_notify() is free-running without any protection from
> concurrent operations. So there are race conditions between
> zram_bvec_read()/zram_bvec_write() and zram_slot_free_notify(),
> and possible consequences include:
> 1) Trigger BUG_ON(!handle) on zram_bvec_write() side.
> 2) Access to freed pages on zram_bvec_read() side.
> 3) Break some fields (bad_compress, good_compress, pages_stored)
>    in zram->stats if the swap layer makes concurrently call to
>    zram_slot_free_notify().
> 
> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
> before calling zram_free_page().
> 

If someone try to read/write *active* swap device via opening
block device file(it's not sane but we couldn't prevent it),
the race between zram_slot_free_notify and zram_bvec_[read|write] can happen.
In such case, following problem for example can happen.

1. xxx
2. xxx
3. xxx

So this patch closes the race with zram->lock write-side lock.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Minchan Kim <minchan@kernel.org>

But please rewrite the description.

-- 
Kind regards,
Minchan Kim
