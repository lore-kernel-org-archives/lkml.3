Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaAVJ67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbaAVJ6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:58:53 -0500
Subject: Re: [PATCH 17/24] GFS2: Use RCU/hlist_bl based hash for quotas
From: Steven Whitehouse <swhiteho@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Abhijith Das <adas@redhat.com>, sasha.levin@oracle.com
In-Reply-To: <20140122053248.GX10038@linux.vnet.ibm.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
	 <1390220627-1571-18-git-send-email-swhiteho@redhat.com>
	 <20140122053248.GX10038@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 22 Jan 2014 09:58:07 +0000
Message-ID: <1390384687.2742.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2014-01-21 at 21:32 -0800, Paul E. McKenney wrote:
> On Mon, Jan 20, 2014 at 12:23:40PM +0000, Steven Whitehouse wrote:
> > Prior to this patch, GFS2 kept all the quotas for each
> > super block in a single linked list. This is rather slow
> > when there are large numbers of quotas.
> > 
> > This patch introduces a hlist_bl based hash table, similar
> > to the one used for glocks. The initial look up of the quota
> > is now lockless in the case where it is already cached,
> > although we still have to take the per quota spinlock in
> > order to bump the ref count. Either way though, this is a
> > big improvement on what was there before.
> > 
> > The qd_lock and the per super block list is preserved, for
> > the time being. However it is intended that since this is no
> > longer used for its original role, it should be possible to
> > shrink the number of items on that list in due course and
> > remove the requirement to take qd_lock in qd_get.
> > 
> > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > Cc: Abhijith Das <adas@redhat.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Interesting!  I thought that Sasha Levin had a hash table in the works,
> but I don't see it, so CCing him.
> 
> A few questions and comments below.
> 
> 							Thanx, Paul
> 
Thanks for the review.

[snip]
> > +#define GFS2_QD_HASH_SHIFT      12

> Should this be a function of the number of CPUs?  (Might not be an issue
> if the really big systems don't use GFS.)

I'm not sure... really it depends on how many quotas are in use, so
number of users, and even on relatively small systems, there might be a
lot of them. So I'm guessing a bit, and we'll bump it up a bit if its a
problem. There is a lot of extra complexity in changing hash table sizes
on the fly, which would be another possible solution. Either way it is a
vast improvement on what was there before :-)

[snip] 
> > +             if (!qid_eq(qd->qd_id, qid))
> > +                     continue;
> > +             if (qd->qd_sbd != sdp)
> > +                     continue;
> > +             if (lockref_get_not_dead(&qd->qd_lockref)) {
> > +                     list_lru_del(&gfs2_qd_lru, &qd->qd_lru);

> list_lru_del() acquires a lock, but it is from an array whose size
> depends on the NODES_SHIFT Kconfig variable.  The array size seems to
> vary from 8 to 16 to 64 to 1024, depending on other configuration info,
> so should be OK.

Yes, we've tried to make use of the generic lru code here, and I'd like
to do that same for the glocks, however thats more complicated, so we've
not got that far just yet, even though we have made some steps in that
direction. Dave Chinner has pointed out to us that the lru code was
designed such that the lru lock should always be the inner most lock, so
thats the ordering that we've used here.

[snip]
> > @@ -1335,11 +1394,16 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
> >  		spin_unlock(&qd->qd_lockref.lock);
> > 
> >  		list_del(&qd->qd_list);
> > +
> >  		/* Also remove if this qd exists in the reclaim list */
> >  		list_lru_del(&gfs2_qd_lru, &qd->qd_lru);
> >  		atomic_dec(&sdp->sd_quota_count);
> >  		spin_unlock(&qd_lock);
> > 
> > +		spin_lock_bucket(qd->qd_hash);
> > +		hlist_bl_del_rcu(&qd->qd_hlist);
> 
> Might just be my unfamiliarity with this code, but it took me a bit
> to see the difference between ->qd_hlist and ->qd_list.  Of course, until
> I spotted the difference, I was wondering why you were removing the
> item twice.  ;-)
> 
Well I hope that eventually qd_list might be able to go away. I'm still
working on a plan to deal with improving the quota data writeback which
should help to make that happen,

Steve.


