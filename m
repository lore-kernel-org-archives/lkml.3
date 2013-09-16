Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab3IPTuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:50:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56362 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IPTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:50:07 -0400
Date: Mon, 16 Sep 2013 20:50:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
Message-ID: <20130916195003.GE13318@ZenIV.linux.org.uk>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
 <1379335925-30858-3-git-send-email-miklos@szeredi.hu>
 <20130916181938.GD13318@ZenIV.linux.org.uk>
 <CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 09:03:25PM +0200, Miklos Szeredi wrote:
> On Mon, Sep 16, 2013 at 8:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Mon, Sep 16, 2013 at 02:51:56PM +0200, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >>
> >> commit b6f4bee02f "fs/9p: Fix atomic_open" fixed the O_EXCL behavior, but
> >> results in a dentry leak if v9fs_vfs_lookup() returns non-NULL.
> >
> > Frankly, I would prefer to deal with that in fs/namei.c:atomic_open()
> > instead.  I.e. let it call finish_no_open() as it used to do and
> > turn
> >                 if (create_error && dentry->d_inode == NULL) {
> >                         error = create_error;
> >                         goto out;
> >                 }
> > in fs/namei.c:atomic_open() into
> >                 if (!dentry->d_inode) {
> >                         if (create_error) {
> >                                 error = create_error;
> >                                 goto out;
> >                         }
> >                 } else if ((open_flag & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL)) {
> >                         error = -EEXIST;
> >                         goto out;
> >                 }
> >
> > rather than try to deal with that crap in each instance of ->atomic_open()...
> > Objections?
> 
> ->atomic_open() could be any one of
> 
>  lookup
>  lookup+create
>  lookup+create+open
> 
> If it's the second one then the above is wrong.  Sure, we could check
> FILE_CREATED as well, and if file wasn't created yet dentry is
> positive then we return EEXIST.  But for that to be correct we need
> the last patch in the series, preventing FILE_CREATED from being set
> unconditionally.

You mean, lookup + create + return finish_no_open()?  Does anything actually
do that?  I agree that we want your "deal with setting FILE_CREATED in
filesystems", BTW, and I'm fine with putting it in front of the rest of
the queue.

I would definitely prefer EEXIST logics dealt with in fs/namei.c - if nothing
else, it had been done wrong in too many instances...
