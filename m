Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaIDU7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:59:24 -0400
Received: from kanga.kvack.org ([205.233.56.17]:59184 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbaIDU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:58:45 -0400
Date: Thu, 4 Sep 2014 16:58:44 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: block exit_aio() until all context requests are completed
Message-ID: <20140904205844.GG13422@kvack.org>
References: <1409737544-9392-1-git-send-email-guz.fnst@cn.fujitsu.com> <20140903144332.GU20066@kvack.org> <5407B697.9090501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407B697.9090501@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 08:47:19AM +0800, Gu Zheng wrote:
> That's good, but I did not find it, have you sent it to the open list?

Sorry, the aio list wasn't cc'd on that one -- it was on one of the other 
development lists.

> IMO, there's no need to check the return value of kill_ioctx(), because
> context can be marked as DEAD only by io_destroy(), and io_destroy() is
> on the block mode. So if we run into the calling of kill_ioctx() in
> exit_aio, the context is surely valid.

Fair point.  I applied your version.  A pull request has been sent.

		-ben

> Thanks,
> Gu
> 
> > 
> > 		-ben
> > 
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >> ---
> >>  fs/aio.c |    7 ++++++-
> >>  1 files changed, 6 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/aio.c b/fs/aio.c
> >> index 97bc62c..3e35b12 100644
> >> --- a/fs/aio.c
> >> +++ b/fs/aio.c
> >> @@ -793,6 +793,8 @@ void exit_aio(struct mm_struct *mm)
> >>  
> >>  	for (i = 0; i < table->nr; ++i) {
> >>  		struct kioctx *ctx = table->table[i];
> >> +		struct completion requests_done =
> >> +			COMPLETION_INITIALIZER_ONSTACK(requests_done);
> >>  
> >>  		if (!ctx)
> >>  			continue;
> >> @@ -804,7 +806,10 @@ void exit_aio(struct mm_struct *mm)
> >>  		 * that it needs to unmap the area, just set it to 0.
> >>  		 */
> >>  		ctx->mmap_size = 0;
> >> -		kill_ioctx(mm, ctx, NULL);
> >> +		kill_ioctx(mm, ctx, &requests_done);
> >> +
> >> +		/* Wait until all IO for the context are done. */
> >> +		wait_for_completion(&requests_done);
> >>  	}
> >>  
> >>  	RCU_INIT_POINTER(mm->ioctx_table, NULL);
> >> -- 
> >> 1.7.7
> > 
> 

-- 
"Thought is the essence of where you are now."
