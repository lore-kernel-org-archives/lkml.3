Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318AbaE3PrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:47:04 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:58928 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965295AbaE3Pq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:58 -0400
Date: Fri, 30 May 2014 11:46:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 11/12] block, bfq: boost the throughput
 on NCQ-capable flash-based devices
Message-ID: <20140530154654.GE24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:05:42AM +0200, Paolo Valente wrote:
> This patch boosts the throughput on NCQ-capable flash-based devices,
> while still preserving latency guarantees for interactive and soft
> real-time applications. The throughput is boosted by just not idling
> the device when the in-service queue remains empty, even if the queue
> is sync and has a non-null idle window. This helps to keep the drive's
> internal queue full, which is necessary to achieve maximum
> performance. This solution to boost the throughput is a port of
> commits a68bbdd and f7d7b7a for CFQ.
> 
> As already highlighted in patch 10, allowing the device to prefetch
> and internally reorder requests trivially causes loss of control on
> the request service order, and hence on service guarantees.
> Fortunately, as discussed in detail in the comments to the function
> bfq_bfqq_must_not_expire(), if every process has to receive the same
> fraction of the throughput, then the service order enforced by the
> internal scheduler of a flash-based device is relatively close to that
> enforced by BFQ. In particular, it is close enough to let service
> guarantees be substantially preserved.
> 
> Things change in an asymmetric scenario, i.e., if not every process
> has to receive the same fraction of the throughput. In this case, to
> guarantee the desired throughput distribution, the device must be
> prevented from prefetching requests. This is exactly what this patch
> does in asymmetric scenarios.

Does it even make sense to use this type of heavy iosched on ssds?
It's highly likely that ssds will soon be served through blk-mq
bypassing all these.  I don't feel too enthused about adding code to
support ssds to ioscheds.  A lot better approach would be just default
to deadline for them anyway.

Thanks.

-- 
tejun
