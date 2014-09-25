Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaIYTsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:48:37 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47864 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIYTsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:48:35 -0400
Date: Thu, 25 Sep 2014 14:48:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140925194825.GB39447@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
References: <20140910162155.GA7748@mail.hallyn.com>
 <20140910164212.GA32587@ubuntu-hedt>
 <20140911181034.GA58733@ubuntu-hedt>
 <87d2am3r8a.fsf@x220.int.ebiederm.org>
 <20140924132925.GA48721@ubuntu-hedt>
 <87y4t9ndw5.fsf@x220.int.ebiederm.org>
 <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
 <87wq8reftb.fsf@x220.int.ebiederm.org>
 <20140925184403.GB28101@ubuntu-hedt>
 <87bnq3a4xy.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnq3a4xy.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:14:01PM -0700, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > On Thu, Sep 25, 2014 at 11:05:36AM -0700, Eric W. Biederman wrote:
> >> Miklos Szeredi <miklos@szeredi.hu> writes:
> >> 
> >> > On Wed, Sep 24, 2014 at 7:10 PM, Eric W. Biederman
> >> > <ebiederm@xmission.com> wrote:
> >> >
> >> >
> >> >> So in summary I see:
> >> >> - Low utility in being able to manipulate files with bad uids.
> >> >> - Bad uids are mostly likely malicious action.
> >> >> - make_bad_inode is trivial to analyze.
> >> >> - No impediments to change if I am wrong.
> >> >>
> >> >> So unless there is a compelling case, right now I would recommend
> >> >> returning -EIO initially.   That allows us to concentrate on the easier
> >> >> parts of this and it leaves the changes only in fuse.
> >> >
> >> > The problem with marking the inode bad is that it will mark it bad for
> >> > all instances of this filesystem.  Including ones which are in a
> >> > namespace where the UIDs make perfect sense.
> >> 
> >> There are two cases:
> >> app <-> fuse
> >> fuse <-> server
> >> 
> >> I proposed mark_bad_inode for "userspace server -> fuse".
> >> Where we have one superblock and one server so and one namespace that
> >> they decide to talk in when the filesystem was mounted.
> >> 
> >> I think bad_inode is a reasonable response when the filesystem server
> >> starts spewing non-sense.
> >> 
> >> > So that really doesn't look like a good solution.
> >> >
> >> > Doing the check in inode_permission() might be too heavyweight, but
> >> > it's still the only one that looks sane.
> >> 
> >> For the "app <-> fuse" case we already have checks in inode_permision
> >> that are kuid based that handle that case.  We use kuids not for
> >> performance (although there is a small advatnage) but to much more to
> >> keep the logic simple and maintainable.
> >> 
> >> 
> >> For the "app -> fuse" case in .setattr we do need a check to verify
> >> that the uid and gid are valid.  However that check was added with
> >> the basic user namespace support and fuse current returns -EOVERFLOW
> >> when that happens.
> >
> > Where does this happen? I haven't managed to track it down yet.
> 
> Sorry iattr_to_setattr look for from_kuid and from_kgid.
> 
> The call path is
> fuse_setattr
>    fuse_do_setattr
>       iattr_to_fattr.

Bah. Sorry, I misread that originally and thought you were talking about
something outside of fuse. And I was looking at a tree with my fuse
changes, so of course I wouldn't have found it.

Actually in 3.17-rc6 I still don't see that iattr_to_fattr (I assume
this is what you meant) checks the results of the conversion (not that
it really needs to since it uses init_user_ns), nor any use of EOVERFLOW
in fuse. Anyway, it's not really important.

> Keeping everything in kuids for as long as possible and only converting
> at the edges tends to mean that I caught most of the conversion issues
> with my basic support for user namespaces.
> 
> > I've also added a check in fuse for this. If a uid/gid passed to
> > fuse_setattr doesn't map into the namespace it will return -EINVAL.
> > Sounds like maybe it should return -EOVERFLOW instead.
> 
> I am not 100% about -EOVERLFLOW but it is the closest I could come up
> with.
> 
> Frankly looking at what I have coded I am inconsistent.  In chown_common
> I use -EINVAL, whereas in fuse I use -EOVERFLOW.  So it is probably
> worth a second look, and probably a patch to a man page or two
> just to document this weird case.
> 
> One document that has advised some of my decisions is the rational for
> how 64bit file offset support was added on 32bit systems ages ago.
> That is where I got -EOVERFLOW.  The logic for handling 64bit file
> offsets was ultimately that any operation that could cause
> corruption would return an error (typically EOVERFLOW).
> 
> Most of the vfs operations with uids are unlikely to cause corruption
> and are more likely to be problematic if they don't work which is why
> I tend to use overflow_uid/-1.
> 
> For when uid/gid values don't map into a kuid/kgid value. Some error
> is definitely required.

Well, unless you say otherwise I guess I'll leave it -EINVAL to be
consistent with chown_common().

> I am on the fence about what to do when a uid from the filesystem server
> or for other filesystems the on-disk data structures does not map, but
> make_bad_inode is simpler in conception.  So make_bad_inode seems like
> a good place to start.   For fuse especially this isn't hard because
> the make_bad_inode calls are already there to handle a change in i_mode.

I agree that if we're unsure then make_bad_inode is a more logical place
to start, since it's easier to loosen the restrictions later than to
tighten them. I've got an initiail implementation that I'm in the
process of testing. If you want to take a look I've pushed it to:

  git://kernel.ubuntu.com/sforshee/linux.git fuse-userns 

Thanks,
Seth

