Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaE0OYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:24:50 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:39967 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaE0OYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:24:48 -0400
Date: Tue, 27 May 2014 10:24:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: always pass cascading responsibility to
 the next flusher
Message-ID: <20140527142443.GC22767@htj.dyndns.org>
References: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Mon, May 26, 2014 at 07:58:12PM +0800, Lai Jiangshan wrote:
> This optimization saves one mutex_lock(&wq->mutex) due to the current
> first-flusher already held it.
> 
> This optimization reduces the cascading-latency, because the next flusher
> is not running currently, it will delay a little when we keep the next's
> responsibility for cascading.
> 
> This optimization may also have other benefits. However, it is slow-path
> and low-probability-hit case, and it is not good at these aspects:
>     1) it adds a special case and makes the code complex, bad for review.
>     2) it adds a special state for the first-flusher which is allowed to
>        be deprived. It causes a race and we have to check wq->first_flusher
>        again with mutex held: 4ce48b37bfed ("workqueue: fix race condition
>        in flush_workqueue()").

The original goal was replicating the wake up behavior of the existing
implementation.  It doesn't matter whether we have a couple more
lockings or somewhat more complex logic there but it *does* make
noticeable difference when it starts involving scheduling latencies.
They are multiple orders of magnitude longer after all.  Not quite the
same but synchronize_rcu() is similar and we've had several cases
where blind synchronize_rcu() invocations in userland visible paths
causing crippling latencies (e.g. SCSI scanning through non-existent
LUNs ending up taking tens of seconds in pathological cases).

So, I think hiding latencies which can easily in millisecs range is
important.  It isn't a performance optimization.  It almost becomes a
correctness issue when the problem is severely hit and the amount of
code simplification that we get from dropping this doesn't seem like
much.  As such, I'm not quite convinced I wanna apply this one.

Thanks.

-- 
tejun
