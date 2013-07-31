Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab3GaCJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:09:44 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52660 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GaCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:09:41 -0400
Date: Wed, 31 Jul 2013 10:09:28 +0800
From: Shaohua Li <shli@kernel.org>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        seiji.aguchi@hds.com
Subject: Re: [RFC PATCH] cfq-iosched: limit slice_idle when many busy queues
 are in idle window
Message-ID: <20130731020928.GA27570@kernel.org>
References: <20130730193033.27856.58005.stgit@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730193033.27856.58005.stgit@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 03:30:33PM -0400, Tomoki Sekiyama wrote:
> Hi,
> 
> When some application launches several hundreds of processes that issue
> only a few small sync I/O requests, CFQ may cause heavy latencies
> (10+ seconds at the worst case), although the request rate is low enough for
> the disk to handle it without waiting. This is because CFQ waits for
> slice_idle (default:8ms) every time before processing each request, until
> their thinktimes are evaluated.
> 
> This scenario can be reproduced using fio with parameters below:
>   fio -filename=/tmp/test -rw=randread -size=5G -runtime=15 -name=file1 \
>       -bs=4k -numjobs=500 -thinktime=1000000
> In this case, 500 processes issue a random read request every second.

For this workload CFQ should perfectly detect it's a seek queue and disable
idle. I suppose the reason is CFQ hasn't enough data/time to disable idle yet,
since your thinktime is long and runtime is short.

I thought the real problem here is cfq_init_cfqq() shouldn't set idle_window
when initializing a queue. We should enable idle window after we detect the
queue is worthy idle.

Thanks,
Shaohua
