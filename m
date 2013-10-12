Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3JLAtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:49:16 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48101 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3JLAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:49:15 -0400
Date: Sat, 12 Oct 2013 08:49:05 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com
Subject: Re: [patch 4/4] blk-mq: switch to percpu-ida for tag menagement
Message-ID: <20131012004905.GA17666@kernel.org>
References: <20131011071802.148101321@kernel.org>
 <20131011072404.749268620@kernel.org>
 <52580B26.2090508@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52580B26.2090508@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 08:28:54AM -0600, Jens Axboe wrote:
> On 10/11/2013 01:18 AM, Shaohua Li wrote:
> > Using percpu-ida to manage blk-mq tags. the percpu-ida has similar algorithm
> > like the blk-mq-tag. The difference is when a cpu can't allocate tags
> > blk-mq-tag uses ipi to purge remote cpu cache and percpu-ida directly purges
> > remote cpu cache. In practice (testing null_blk), the percpu-ida approach is
> > much faster when total tags aren't enough.
> 
> I'm not surprised it's a lot faster the the pathological case of needing
> to prune tags, the IPI isn't near ideal for that. I'm assuming the
> general performance is the same for the non-full case?

Yep. My test is done in a 2 sockets machine, 12 process cross the 2 sockets. So
if there is lock contention or ipi, should be stressed heavily. Testing is done
for null-blk.

hw_queue_depth	nopatch iops	patch iops
64		~800k/s		~1470k/s
2048		~4470k/s	~4340k/s

In the 2048 case, perf doesn't should any percpu-ida function is hot (no one
use > 1% cpu time), so the small difference should be drift. So yes, the
general performance is the same.

Thanks,
Shaohua
