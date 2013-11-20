Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3KTSzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:55:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab3KTSzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:55:45 -0500
Date: Wed, 20 Nov 2013 13:57:45 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "Frank Filz" <ffilzlnx@mindspring.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>
Subject: Re: [RFC PATCH v2 5/5] locks: report l_pid as -1 for
 FL_FILP_PRIVATE locks
Message-ID: <20131120135745.026f468e@corrin.poochiereds.net>
In-Reply-To: <0d1101cee619$ad866500$08932f00$@mindspring.com>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
	<1384965906-27327-6-git-send-email-jlayton@redhat.com>
	<0d1101cee619$ad866500$08932f00$@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 09:55:18 -0800
"Frank Filz" <ffilzlnx@mindspring.com> wrote:

> > FL_FILP_PRIVATE locks are no longer tied to a particular PID, and are
> instead
> > inheritable by child processes. Report a l_pid of '-1' for these sorts of
> locks
> > since the pid is somewhat meaningless for them.
> 
> Hmm, I suppose in the case of a process that acquires a private lock, forks
> (passing the lock to the child process) and then exits, pid would be
> meaningless, but I wonder how common that case is compared to a
> multi-threaded process (especially a file server) that will hold many
> private locks, and not pass them to child processes (and exit)?
> 
> I.e. as a future user of this feature, I wonder if I'm going to want to know
> that THESE private locks are owned by Ganesha and THOSE are owned by Samba?
> 
> Frank
> 

A fair point.

FWIW, I took the idea of reporting '-1' from BSD, where POSIX and flock
locks can apparently conflict. If a flock lock is held on a file and
you do a F_GETLK request, then it will report '-1' for the l_pid. [1]

I sort of expect that we may need to eventually add an F_GETLK variant
that gives more info. The main reason to do this here is that we need
to put something semi-meaningful in that field for "classic" F_GETLK
users.

[1]: hmm...probably should put that in the commit log message. I'll do
     that for the next respin...

> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/locks.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index d5fb853..8a4d4e4 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -1889,7 +1889,7 @@ EXPORT_SYMBOL_GPL(vfs_test_lock);
> > 
> >  static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
> {
> > -	flock->l_pid = fl->fl_pid;
> > +	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
> >  #if BITS_PER_LONG == 32
> >  	/*
> >  	 * Make sure we can represent the posix lock via @@ -1911,7 +1911,7
> > @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock
> *fl)  #if
> > BITS_PER_LONG == 32  static void posix_lock_to_flock64(struct flock64
> > *flock, struct file_lock *fl)  {
> > -	flock->l_pid = fl->fl_pid;
> > +	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
> >  	flock->l_start = fl->fl_start;
> >  	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
> >  		fl->fl_end - fl->fl_start + 1;
> > --
> > 1.8.3.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> in the
> > body of a message to majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> 


-- 
Jeff Layton <jlayton@redhat.com>
