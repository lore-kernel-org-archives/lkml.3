Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIKSK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:10:56 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54433 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaIKSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:10:54 -0400
Date: Thu, 11 Sep 2014 13:10:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140911181034.GA58733@ubuntu-hedt>
Mail-Followup-To: "Serge E. Hallyn" <serge@hallyn.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <20140910123525.GA29064@ubuntu-hedt>
 <20140910162155.GA7748@mail.hallyn.com>
 <20140910164212.GA32587@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910164212.GA32587@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:42:12AM -0500, Seth Forshee wrote:
> On Wed, Sep 10, 2014 at 06:21:55PM +0200, Serge E. Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > On Tue, Sep 02, 2014 at 10:44:53AM -0500, Seth Forshee wrote:
> > > > Another issue mentioned by Eric was what to use for i_[ug]id if the ids
> > > > from userspace don't map into the user namespace, which is going to be a
> > > > problem for any other filesystems which become mountable from user
> > > > namespaces as well. We discussed a few options for addressing this, the
> > > > most promising of which seems to be either using INVALID_[UG]ID for
> > > > these inodes or creating vfs-wide "nobody" ids for this purpose. After
> > > > thinking about it for a while I'm favoring using the invalid ids, but
> > > > I'm hoping to solicit some more feedback.
> > > > 
> > > > For now these patches are using invalid ids if the user doesn't map into
> > > > the namespace. I went through the vfs code and found one place where
> > > > this could be handled better (addressed in patch 1 of the series). The
> > > > only other issue I found was that currently no one, not even root, can
> > > > change onwership of such inodes, but I suspect we can find a way around
> > > > this.
> > > 
> > > I started playing around with using -2 as a global nobody id. The
> > > changes below (made on top of this series) are working fine in light
> > > testing. I'm still not sure about the security implications of doing
> > > this though. Possibly the nobody id should be removed from init_user_ns
> > > to prevent any use of the id to gain unauthroized access to such files.
> > > Thoughts?
> > 
> > Can you explain the downsides of just using -1?  What are we able to do
> > (as a fuse-in-container user) when we use -2 that we can't do when it
> > uses -1?
> 
> The thing that happens with -1 is that checks like
> capable_wrt_inode_uidgid() always fail on those inodes because
> INVALID_UID isn't ever mapped into any namespace, even if you're
> system-wide root. If we use a real id this check would at least pass in
> init_user_ns, assuming that we don't have to remove -2 from init_user_ns
> for security reasons.
> 
> Or we could modify these checks so that CAP_SYS_ADMIN always gets
> permission or something like that, which might be the better way to go.

This ought to do (untested as of yet). I think I like this best, but I'm
also interested in hearing what Eric has to say.


diff --git a/fs/inode.c b/fs/inode.c
index 26753ba7b6d6..1029320ff029 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1840,6 +1840,9 @@ bool inode_owner_or_capable(const struct inode *inode)
 {
        struct user_namespace *ns;
 
+       if (capable(CAP_SYS_ADMIN))
+               return true;
+
        if (uid_eq(current_fsuid(), inode->i_uid))
                return true;
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 989f5bfc57dc..a472eaa52b6a 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -438,8 +438,12 @@ EXPORT_SYMBOL(capable);
  */
 bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
 {
-       struct user_namespace *ns = current_user_ns();
+       struct user_namespace *ns;
 
+       if (capable(CAP_SYS_ADMIN))
+               return true;
+
+       ns = current_user_ns();
        return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid) &&
                kgid_has_mapping(ns, inode->i_gid);
 }

