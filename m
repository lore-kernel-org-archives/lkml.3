Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaCZTBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbaCZTBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:01:04 -0400
Message-ID: <1395860454.24733.15.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 1/1] Avoid having to provide a fake/invalid fd and path
From: Eric Paris <eparis@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: xypron.glpk@gmx.de, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Mar 2014 15:00:54 -0400
In-Reply-To: <20140326184731.GA18118@quack.suse.cz>
References: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de>
	 <20140326184731.GA18118@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 19:47 +0100, Jan Kara wrote:
> On Wed 26-03-14 16:30:05, xypron.glpk@gmx.de wrote:
> > From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > 
> > https://lkml.org/lkml/2011/1/12/112
> > holds a patch by Tvrtko Ursulin
> > 
> >   Avoid having to provide a fake/invalid fd and path when flushing marks
> > 
> >   Currently for a group to flush marks it has set it needs to
> >   provide a fake or invalid (but resolvable) file descriptor
> >   and path when calling fanotify_mark. This patch pulls the
> >   flush handling a bit up so file descriptor and path are
> >   completely ignored when flushing.
> > 
> > Eric wrote it was applied.
> > https://lkml.org/lkml/2011/1/19/321
> > 
> > Unfortunately it is still not in the main stream code and the problem remains.
> > 
> > I reworked the patch to be applicable again (the signature of fanotify_mark
> > has changed since Tvrtko's work).
> > 
> > Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>   The patch looks good to me. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>   Andrew, can you please add the patch to the fanotify patches you already
> carry? Thanks!

Acked-by: Eric Paris <eparis@redhat.com>

that would be great Andrew!

> 
> 								Honza
> 
> > ---
> >  fs/notify/fanotify/fanotify_user.c |   17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> > index 287a22c..05bb38a 100644
> > --- a/fs/notify/fanotify/fanotify_user.c
> > +++ b/fs/notify/fanotify/fanotify_user.c
> > @@ -856,6 +856,15 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
> >  	    group->priority == FS_PRIO_0)
> >  		goto fput_and_out;
> >  
> > +	if (flags & FAN_MARK_FLUSH) {
> > +		ret = 0;
> > +		if (flags & FAN_MARK_MOUNT)
> > +			fsnotify_clear_vfsmount_marks_by_group(group);
> > +		else
> > +			fsnotify_clear_inode_marks_by_group(group);
> > +		goto fput_and_out;
> > +	}
> > +
> >  	ret = fanotify_find_path(dfd, pathname, &path, flags);
> >  	if (ret)
> >  		goto fput_and_out;
> > @@ -867,7 +876,7 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
> >  		mnt = path.mnt;
> >  
> >  	/* create/update an inode mark */
> > -	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
> > +	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)) {
> >  	case FAN_MARK_ADD:
> >  		if (flags & FAN_MARK_MOUNT)
> >  			ret = fanotify_add_vfsmount_mark(group, mnt, mask, flags);
> > @@ -880,12 +889,6 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
> >  		else
> >  			ret = fanotify_remove_inode_mark(group, inode, mask, flags);
> >  		break;
> > -	case FAN_MARK_FLUSH:
> > -		if (flags & FAN_MARK_MOUNT)
> > -			fsnotify_clear_vfsmount_marks_by_group(group);
> > -		else
> > -			fsnotify_clear_inode_marks_by_group(group);
> > -		break;
> >  	default:
> >  		ret = -EINVAL;
> >  	}
> > -- 
> > 1.7.10.4
> > 


