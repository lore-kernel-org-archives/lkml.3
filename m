Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaIETYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:24:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaIETYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:24:01 -0400
Date: Fri, 5 Sep 2014 19:23:34 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vfs: Check for invalid i_uid in may_follow_link()
Message-ID: <20140905192334.GR16450@ubuntumail>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <1409672696-15847-2-git-send-email-seth.forshee@canonical.com>
 <20140905170509.GI16450@ubuntumail>
 <20140905190053.GB84919@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905190053.GB84919@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> On Fri, Sep 05, 2014 at 05:05:09PM +0000, Serge Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > Filesystem uids which don't map into a user namespace may result
> > > in inode->i_uid being INVALID_UID. A symlink and its parent
> > > could have different owners in the filesystem can both get
> > > mapped to INVALID_UID, which may result in following a symlink
> > > when this would not have otherwise been permitted. Prevent this
> > > by adding a check that the uid is valid before the comparison.
> > > 
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > 
> > I'm a bit uncomfortable about this, but I can't put my finger
> > on why.  Wonder if it could mess up root looking into
> > a malicious user's task by looking under /proc/self/root.
> > I suppose not, as this should only be the case (with root in
> > init_user_ns) for fuse?
> > 
> > Anyway it seems needed for keeping root from falling into a trap.
> 
> This shouldn't mess up looking into /proc/self/root or anything else
> where the symlink isn't under control of the malicious user. Plus this
> restriction only applies to world-writable directories with the sticky
> bit set.

Oh - yeah, i saw that and glossed over it for some reason.  Thanks.

> > Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> > 
> > > ---
> > >  fs/namei.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index a996bb48dfab..193da09e903e 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -741,7 +741,7 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
> > >  		return 0;
> > >  
> > >  	/* Allowed if parent directory and link owner match. */
> > > -	if (uid_eq(parent->i_uid, inode->i_uid))
> > > +	if (uid_valid(inode->i_uid) && uid_eq(parent->i_uid, inode->i_uid))
> > >  		return 0;
> > >  
> > >  	audit_log_link_denied("follow_link", link);
> > > -- 
> > > 1.9.1
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
