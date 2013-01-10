Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3AJU6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:58:22 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:58791 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3AJU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:58:20 -0500
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Eric Wong <normalperson@yhbt.net>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20130110194212.GJ13304@suse.de>
References: <20121228014503.GA5017@dcvr.yhbt.net>
	 <20130102200848.GA4500@dcvr.yhbt.net> <20130104160148.GB3885@suse.de>
	 <20130106120700.GA24671@dcvr.yhbt.net> <20130107122516.GC3885@suse.de>
	 <20130107223850.GA21311@dcvr.yhbt.net> <20130108224313.GA13304@suse.de>
	 <20130108232325.GA5948@dcvr.yhbt.net> <20130109133746.GD13304@suse.de>
	 <20130110092511.GA32333@dcvr.yhbt.net>  <20130110194212.GJ13304@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jan 2013 12:58:16 -0800
Message-ID: <1357851496.27446.2619.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 19:42 +0000, Mel Gorman wrote:

> Thanks Eric, it's much appreciated. However, I'm still very much in favour
> of a partial revert as in retrospect the implementation of capture took the
> wrong approach. Could you confirm the following patch works for you?
> It's should functionally have the same effect as the first revert and
> there are only minor changes from the last revert prototype I sent you
> but there is no harm in being sure.
> 
> ---8<---
> mm: compaction: Partially revert capture of suitable high-order page
> 
> Eric Wong reported on 3.7 and 3.8-rc2 that ppoll() got stuck when waiting
> for POLLIN on a local TCP socket. It was easier to trigger if there was disk
> IO and dirty pages at the same time and he bisected it to commit 1fb3f8ca
> "mm: compaction: capture a suitable high-order page immediately when it
> is made available".
> 
> The intention of that patch was to improve high-order allocations under
> memory pressure after changes made to reclaim in 3.6 drastically hurt
> THP allocations but the approach was flawed. For Eric, the problem was
> that page->pfmemalloc was not being cleared for captured pages leading to
> a poor interaction with swap-over-NFS support causing the packets to be
> dropped. However, I identified a few more problems with the patch including
> the fact that it can increase contention on zone->lock in some cases which
> could result in async direct compaction being aborted early.
> 
> In retrospect the capture patch took the wrong approach. What it should
> have done is mark the pageblock being migrated as MIGRATE_ISOLATE if it
> was allocating for THP and avoided races that way. While the patch was
> showing to improve allocation success rates at the time, the benefit is
> marginal given the relative complexity and it should be revisited from
> scratch in the context of the other reclaim-related changes that have taken
> place since the patch was first written and tested. This patch partially
> reverts commit 1fb3f8ca "mm: compaction: capture a suitable high-order
> page immediately when it is made available".
> 
> Reported-by: Eric Wong <normalperson@yhbt.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---

It seems to solve the problem on my kvm testbed

(512 MB of ram, 2 vcpus)

Tested-by: Eric Dumazet <edumazet@google.com>


