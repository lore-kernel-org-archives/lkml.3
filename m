Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLESSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:18:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:59985 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaLESSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:18:44 -0500
Date: Fri, 5 Dec 2014 10:18:32 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/3] f2fs: fix missing kmem_cache_free
Message-ID: <20141205181832.GB6641@jaegeuk-mac02>
References: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
 <548127D9.4030007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548127D9.4030007@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

On Fri, Dec 05, 2014 at 11:34:49AM +0800, Gu Zheng wrote:
> Hi Jaegeuk, 
> On 12/05/2014 08:49 AM, Jaegeuk Kim wrote:
> 
> > This patch fixes missing kmem_cache_free when handling errors.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/node.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index b1466cf..c59341d 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -158,7 +158,7 @@ retry:
> >  		head->entry_cnt = 0;
> >  
> >  		if (radix_tree_insert(&nm_i->nat_set_root, set, head)) {
> > -			cond_resched();
> > +			kmem_cache_free(nat_entry_set_slab, head);
> 
> Why not reuse the allocated entry?
> This routine is under nat_tree_lock, so the free_old->research->alloc_new
> is needless, because no other ones can race with us.

IMO, this issue is quite different one that you're mentioning.
This patch just fixes a missing kfree.

> 
> >  			goto retry;
> 
> And radix_tree_insert can only fail -ENOMEM here, IMO, the in-time retry step
> makes very little sense here. How about retaining the "cond_resched()" and retry
> insert later?

I think the following patches related to radix_tree_preload that I submitted
would address that.
But, still it seems that I need to review the retrial paths again.

Thanks,

> 
> If I misread something, please correct me.:)
> 
> Thanks,
> Gu
> 
> >  		}
> >  	}
