Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3LJUfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:35:18 -0500
Received: from fieldses.org ([174.143.236.118]:58648 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3LJUfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:35:13 -0500
Date: Tue, 10 Dec 2013 15:35:03 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [Nfs-ganesha-devel] [RFC PATCH v2 3/5] locks: add new "private"
 lock type that is owned by the filp
Message-ID: <20131210203503.GB20831@fieldses.org>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
 <1384965906-27327-4-git-send-email-jlayton@redhat.com>
 <20131120195032.GA7387@fieldses.org>
 <20131209114653.7b3a1423@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209114653.7b3a1423@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 11:46:53AM -0500, Jeff Layton wrote:
> On Wed, 20 Nov 2013 14:50:32 -0500
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > On Wed, Nov 20, 2013 at 11:45:04AM -0500, Jeff Layton wrote:
> > > Due to some unfortunate history, POSIX locks have very strange and
> > > unhelpful semantics. The thing that usually catches people by surprise
> > > is that they are dropped whenever the process closes any file descriptor
> > > associated with the inode.
> > > 
> > > This is extremely problematic for people developing file servers that
> > > need to implement byte-range locks. Developers often need a "lock
> > > management" facility to ensure that file descriptors are not closed
> > > until all of the locks associated with the inode are finished.
> > > 
> > > This patchset adds a new type of lock that attempts to address this
> > > issue. These locks work just like "normal" POSIX read/write locks, but
> > > have semantics that are more like BSD locks with respect to inheritance
> > > and behavior on close.
> > > 
> > > This is implemented primarily by changing how fl_owner field is set for
> > > these locks. Instead of having them owned by the files_struct of the
> > > process, they are instead owned by the filp on which they were acquired.
> > > Thus, they are inherited across fork() and are only released when the
> > > last reference to a filp is put.
> > > 
> > > These new semantics prevent them from being merged with "classic" POSIX
> > > locks, even if they are acquired by the same process. These locks will
> > > also conflict with "classic" POSIX locks even if they are acquired by
> > > the same process or on the same file descriptor.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > ---
> > >  fs/locks.c                       | 22 +++++++++++++++++++++-
> > >  include/uapi/asm-generic/fcntl.h | 15 +++++++++++++++
> > >  2 files changed, 36 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/locks.c b/fs/locks.c
> > > index 86cafc3..3b278a6 100644
> > > --- a/fs/locks.c
> > > +++ b/fs/locks.c
> > > @@ -348,6 +348,26 @@ static int posix_assign_type(struct file_lock *fl, long type)
> > >  {
> > >  	int err;
> > >  
> > > +	/*
> > > +	 * FL_FILP_PRIVATE locks are "owned" by the filp upon which they were
> > > +	 * acquired, regardless of what task is dealing with them. Set the
> > > +	 * fl_owner appropriately.
> > > +	 */
> > > +	switch (type) {
> > > +	case F_RDLCKP:
> > > +		type = F_RDLCK;
> > > +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> > > +		break;
> > > +	case F_WRLCKP:
> > > +		type = F_WRLCK;
> > > +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> > > +		break;
> > > +	case F_UNLCKP:
> > > +		type = F_UNLCK;
> > > +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> > > +		break;
> > > +	}
> > > +
> > 
> > After this fl_owner gets set to current->files in
> > flock{64}_to_posix_lock and then reset here.  That seems like a trap for
> > the unwary reader.
> > 
> > Could you do something like rename this flock_to_posix_lock_common and
> > move all the 32/64-bit-independent initialization here?
> > 
> > Looks like there's way more duplication than necessary between those two
> > cases.
> > 
> 
> Ok, finally got a chance to start looking at this again...
> 
> I agree that at first glance, it looks like there is a lot of
> duplication between flock_to_posix_lock and flock64_to_posix_lock, but
> the problem we have is that we need to initialize the file_locks with
> info from two different types of structs that were passed in from
> userland (flock and flock64).
> 
> I don't see a clean way to consolidate the two given that...

Doh, yes I overlooked that.  Still seems like there should be more to
do, but let me go look at your revised series....

--b.

> 
> > (Also, why do we have an fl_owner_t instead of using a void?)
> > 
> > --b.
> > 
> > >  	err = assign_type(fl, type);
> > >  	if (err)
> > >  		return err;
> > > @@ -2225,7 +2245,7 @@ void locks_remove_filp(struct file *filp)
> > >  
> > >  	while ((fl = *before) != NULL) {
> > >  		if (fl->fl_file == filp) {
> > > -			if (IS_FLOCK(fl)) {
> > > +			if (IS_FLOCK(fl) || IS_POSIX(fl)) {
> > >  				locks_delete_lock(before);
> > >  				continue;
> > >  			}
> > > diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> > > index 95e46c8..6b7b68a 100644
> > > --- a/include/uapi/asm-generic/fcntl.h
> > > +++ b/include/uapi/asm-generic/fcntl.h
> > > @@ -151,6 +151,21 @@ struct f_owner_ex {
> > >  #define F_UNLCK		2
> > >  #endif
> > >  
> > > +/*
> > > + * fd "private" POSIX locks.
> > > + *
> > > + * Usually POSIX locks held by a process are released on *any* close and are
> > > + * not inherited across a fork().
> > > + *
> > > + * These lock types will conflict with normal POSIX locks, but are "owned"
> > > + * by the fd, not the process. This means that they are inherited across
> > > + * fork() like BSD (flock) locks, and they are only closed when the last
> > > + * reference to the the filp against which were acquired is closed.
> > > + */
> > > +#define F_RDLCKP	5
> > > +#define F_WRLCKP	6
> > > +#define F_UNLCKP	7
> > > +
> > >  /* for old implementation of bsd flock () */
> > >  #ifndef F_EXLCK
> > >  #define F_EXLCK		4	/* or 3 */
> > > -- 
> > > 1.8.3.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > ------------------------------------------------------------------------------
> > Shape the Mobile Experience: Free Subscription
> > Software experts and developers: Be at the forefront of tech innovation.
> > Intel(R) Software Adrenaline delivers strategic insight and game-changing 
> > conversations that shape the rapidly evolving mobile landscape. Sign up now. 
> > http://pubads.g.doubleclick.net/gampad/clk?id=63431311&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Nfs-ganesha-devel mailing list
> > Nfs-ganesha-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/nfs-ganesha-devel
> 
> 
> -- 
> Jeff Layton <jlayton@redhat.com>
