Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaIYSoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:44:15 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:58012 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIYSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:44:14 -0400
Date: Thu, 25 Sep 2014 13:44:03 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140925184403.GB28101@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <20140910123525.GA29064@ubuntu-hedt>
 <20140910162155.GA7748@mail.hallyn.com>
 <20140910164212.GA32587@ubuntu-hedt>
 <20140911181034.GA58733@ubuntu-hedt>
 <87d2am3r8a.fsf@x220.int.ebiederm.org>
 <20140924132925.GA48721@ubuntu-hedt>
 <87y4t9ndw5.fsf@x220.int.ebiederm.org>
 <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
 <87wq8reftb.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq8reftb.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:05:36AM -0700, Eric W. Biederman wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > On Wed, Sep 24, 2014 at 7:10 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >
> >
> >> So in summary I see:
> >> - Low utility in being able to manipulate files with bad uids.
> >> - Bad uids are mostly likely malicious action.
> >> - make_bad_inode is trivial to analyze.
> >> - No impediments to change if I am wrong.
> >>
> >> So unless there is a compelling case, right now I would recommend
> >> returning -EIO initially.   That allows us to concentrate on the easier
> >> parts of this and it leaves the changes only in fuse.
> >
> > The problem with marking the inode bad is that it will mark it bad for
> > all instances of this filesystem.  Including ones which are in a
> > namespace where the UIDs make perfect sense.
> 
> There are two cases:
> app <-> fuse
> fuse <-> server
> 
> I proposed mark_bad_inode for "userspace server -> fuse".
> Where we have one superblock and one server so and one namespace that
> they decide to talk in when the filesystem was mounted.
> 
> I think bad_inode is a reasonable response when the filesystem server
> starts spewing non-sense.
> 
> > So that really doesn't look like a good solution.
> >
> > Doing the check in inode_permission() might be too heavyweight, but
> > it's still the only one that looks sane.
> 
> For the "app <-> fuse" case we already have checks in inode_permision
> that are kuid based that handle that case.  We use kuids not for
> performance (although there is a small advatnage) but to much more to
> keep the logic simple and maintainable.
> 
> 
> For the "app -> fuse" case in .setattr we do need a check to verify
> that the uid and gid are valid.  However that check was added with
> the basic user namespace support and fuse current returns -EOVERFLOW
> when that happens.

Where does this happen? I haven't managed to track it down yet.

I've also added a check in fuse for this. If a uid/gid passed to
fuse_setattr doesn't map into the namespace it will return -EINVAL.
Sounds like maybe it should return -EOVERFLOW instead.

Thanks,
Seth
