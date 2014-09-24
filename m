Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaIXN3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:29:37 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:51604 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaIXN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:29:34 -0400
Date: Wed, 24 Sep 2014 08:29:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140924132925.GA48721@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <20140910123525.GA29064@ubuntu-hedt>
 <20140910162155.GA7748@mail.hallyn.com>
 <20140910164212.GA32587@ubuntu-hedt>
 <20140911181034.GA58733@ubuntu-hedt>
 <87d2am3r8a.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2am3r8a.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:29:57PM -0700, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > On Wed, Sep 10, 2014 at 11:42:12AM -0500, Seth Forshee wrote:
> >> On Wed, Sep 10, 2014 at 06:21:55PM +0200, Serge E. Hallyn wrote:
> >> > Quoting Seth Forshee (seth.forshee@canonical.com):
> >> > > On Tue, Sep 02, 2014 at 10:44:53AM -0500, Seth Forshee wrote:
> >> > > > Another issue mentioned by Eric was what to use for i_[ug]id if the ids
> >> > > > from userspace don't map into the user namespace, which is going to be a
> >> > > > problem for any other filesystems which become mountable from user
> >> > > > namespaces as well. We discussed a few options for addressing this, the
> >> > > > most promising of which seems to be either using INVALID_[UG]ID for
> >> > > > these inodes or creating vfs-wide "nobody" ids for this purpose. After
> >> > > > thinking about it for a while I'm favoring using the invalid ids, but
> >> > > > I'm hoping to solicit some more feedback.
> >> > > > 
> >> > > > For now these patches are using invalid ids if the user doesn't map into
> >> > > > the namespace. I went through the vfs code and found one place where
> >> > > > this could be handled better (addressed in patch 1 of the series). The
> >> > > > only other issue I found was that currently no one, not even root, can
> >> > > > change onwership of such inodes, but I suspect we can find a way around
> >> > > > this.
> >> > > 
> >> > > I started playing around with using -2 as a global nobody id. The
> >> > > changes below (made on top of this series) are working fine in light
> >> > > testing. I'm still not sure about the security implications of doing
> >> > > this though. Possibly the nobody id should be removed from init_user_ns
> >> > > to prevent any use of the id to gain unauthroized access to such files.
> >> > > Thoughts?
> >> > 
> >> > Can you explain the downsides of just using -1?  What are we able to do
> >> > (as a fuse-in-container user) when we use -2 that we can't do when it
> >> > uses -1?
> >> 
> >> The thing that happens with -1 is that checks like
> >> capable_wrt_inode_uidgid() always fail on those inodes because
> >> INVALID_UID isn't ever mapped into any namespace, even if you're
> >> system-wide root. If we use a real id this check would at least pass in
> >> init_user_ns, assuming that we don't have to remove -2 from init_user_ns
> >> for security reasons.
> >> 
> >> Or we could modify these checks so that CAP_SYS_ADMIN always gets
> >> permission or something like that, which might be the better way to go.
> >
> > This ought to do (untested as of yet). I think I like this best, but I'm
> > also interested in hearing what Eric has to say.
> 
> So thinking about this and staring at fuse a little more I don't like
> the approach of mapping bad uids into INVALID_UID in the case of fuse.
> 
> What scares me is that we are looking at a very uncommon case that no
> one will test much.  And depending for security on a very subtle
> interpretation of semantics that only matter when someone is attacking
> us seems scary to me.
> 
> For fuse at least I would assume that any time a file shows up with a
> uid that doesn't map, and we map it to INVALID_UID I would assume it is
> the work of a hostile user.  It could be a misconfiguration but it is a
> broken action on the part of the filesystem in either case.
> 
> Therefore given that a bad uid can only occur as a result of accidental
> or hostile action can we please call make_bad_inode in those cases?  And
> thus always return -EIO.
> 
> That way no one needs to consider what happens if we cache bad data or
> we try to use bad data, and it is an easy position to retreat from
> if it happens that we need to do something different.

One thing I don't understand is why you're qualifying these statements
to be limited to fuse. Normal filesystems will have to deal with the
same problem if/when they are made mountable from user namespaces; is
this concern not valid there? Or would you advocate the same behavior
for normal filesystems as well? Otherwise it seems like we're just
putting off dealing with it for a while.

I'd prefer for the mounts to be as useful as possible when the fs
contains ids that don't map into the namespace, but it's also difficult
to argue against taking the more restricted approach at first and
loosening up if needed. So I guess I'm okay with returning -EIO to start
out.

Thanks,
Seth
