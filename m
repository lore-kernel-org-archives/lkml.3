Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaJPUb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:31:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:54261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJPUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:31:28 -0400
Date: Thu, 16 Oct 2014 22:31:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/fair: Fix race in update_cfs_rq_h_load()
Message-ID: <20141016203119.GM7369@worktop.fdxtended.com>
References: <1413467359.19914.2.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413467359.19914.2.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 05:49:19PM +0400, Kirill Tkhai wrote:
> 
> The original idea of cfs_rq::last_h_load_update was to do not
> update cfs_rq::h_load more than once a jiffies.
> 
> Since task_numa_compare()->task_h_load()->update_cfs_rq_h_load()
> makes unlocked update, this may be a reason of race between two
> parallel updates, or with remote rq->curr changing.
> 
> The patch does not change idea, but it excludes the race. Now we
> update cfs_rq::h_load holding rq's lock. This happens in two
> places: every jiffie in task_tick_fair(), and in set_curr_task_fair()
> when task becomes fair.

But why is this a problem? Most of the load balance code is racy like
hell -- purposely so, added serialization is typically worse.
