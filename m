Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaBYPOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:14:20 -0500
Received: from fieldses.org ([174.143.236.118]:41817 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbaBYPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:14:18 -0500
Date: Tue, 25 Feb 2014 10:13:49 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 08/11] vfs: Merge check_submounts_and_drop and
 d_invalidate
Message-ID: <20140225151349.GA19981@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <87eh34jbsl.fsf_-_@xmission.com>
 <20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu>
 <87y510dpra.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y510dpra.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:01:29PM -0800, Eric W. Biederman wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > On Sat, Feb 15, 2014 at 01:39:22PM -0800, Eric W. Biederman wrote:
> >> 
> >> Now that d_invalidate is the only caller of check_submounts_and_drop,
> >> expand check_submounts_and_drop inline in d_invalidate.
> >> 
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  fs/dcache.c            |   55 +++++++++++++++++++----------------------------
> >>  include/linux/dcache.h |    1 -
> >>  2 files changed, 22 insertions(+), 34 deletions(-)
> >> 
> >> diff --git a/fs/dcache.c b/fs/dcache.c
> >> index 27585b1dd6f1..5b41205cbf33 100644
> >> --- a/fs/dcache.c
> >> +++ b/fs/dcache.c
> 
> >> -int check_submounts_and_drop(struct dentry *dentry)
> >> +int d_invalidate(struct dentry *dentry)
> >>  {
> >>  	int ret = 0;
> >>  
> >> +	/*
> >> +	 * If it's already been dropped, return OK.
> >> +	 */
> >> +	spin_lock(&dentry->d_lock);
> >> +	if (d_unhashed(dentry)) {
> >> +		spin_unlock(&dentry->d_lock);
> >> +		return 0;
> >> +	}
> >> +	spin_unlock(&dentry->d_lock);
> >> +
> >>  	/* Negative dentries can be dropped without further checks */
> >>  	if (!dentry->d_inode) {
> >>  		d_drop(dentry);
> >
> >
> > You can optimize this by including the negative check within the above d_locked
> > region and calling __d_drop() instead.
> 
> For this patch just moving the code and not changing it is the corret
> thing to do because it helps with review and understanding the code.
> 
> There are two ways I could see going with optimizing the preamble.
> Simply dropping the d_lock from around the d_unhashed test as a pointer
> dereference should be atomic, and the test is racy against
> d_materialise_unique.

Could you explain?  What's the race, and what are the consequences?

--b.

> (We don't always hold the parent
> directories inode mutex when d_invalidate is called).  So the d_lock
> buys us very little.  Alternatively we could move the work into the
> d_walk callbacks.
> 
> That kind of optimization deserves it's own patch that can be reviewed
> independently.
> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
