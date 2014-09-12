Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaILQUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:20:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaILQUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:20:10 -0400
Date: Fri, 12 Sep 2014 18:20:07 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, john@johnmccutchan.com,
        rlove@rlove.org, eparis@parisplace.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fsnotify: don't put user context if it was never assigned
Message-ID: <20140912162007.GD5958@quack.suse.cz>
References: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
 <5411E149.5090305@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411E149.5090305@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-09-14 19:52:09, Heinrich Schuchardt wrote:
> Hello Sasha,
> 
> I have CCed Jan, because he has been the only one working on this
> file in the last 18 months.
> 
> A failure path in which group->inotify_data.user is not yet assigned
> starts here:
> 
> static struct fsnotify_group *inotify_new_group(unsigned int max_events)
> {
> ...
> 	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
> 	if (unlikely(!oevent)) {
> 		fsnotify_destroy_group(group);
> 		return ERR_PTR(-ENOMEM);
> 	}
> 
> So your check
>   if (group->inotify_data.user)
> is reasonable.
> 
> 3.17.0-rc3 compiles with the patch applied.
> 
> Reviewed-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> @Andrew
> Please, add the patch to the mm-tree.
  Yeah, the patch looks good. Thanks for CC. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> On 29.07.2014 15:25, Sasha Levin wrote:
> >On some failure paths we may attempt to free user context even
> >if it wasn't assigned yet. This will cause a NULL ptr deref
> >and a kernel BUG.
> >
> >Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >---
> >  fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
> >index 43ab1e1..9c8187e 100644
> >--- a/fs/notify/inotify/inotify_fsnotify.c
> >+++ b/fs/notify/inotify/inotify_fsnotify.c
> >@@ -165,8 +165,10 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
> >  	/* ideally the idr is empty and we won't hit the BUG in the callback */
> >  	idr_for_each(&group->inotify_data.idr, idr_callback, group);
> >  	idr_destroy(&group->inotify_data.idr);
> >-	atomic_dec(&group->inotify_data.user->inotify_devs);
> >-	free_uid(group->inotify_data.user);
> >+	if (group->inotify_data.user) {
> >+		atomic_dec(&group->inotify_data.user->inotify_devs);
> >+		free_uid(group->inotify_data.user);
> >+	}
> >  }
> >
> >  static void inotify_free_event(struct fsnotify_event *fsn_event)
> >
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
