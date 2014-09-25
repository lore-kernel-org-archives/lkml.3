Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaIYQVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:21:41 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36394 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaIYQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:21:40 -0400
Date: Thu, 25 Sep 2014 11:21:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140925162127.GA28101@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:04:04PM +0200, Miklos Szeredi wrote:
> On Wed, Sep 24, 2014 at 7:10 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> 
> 
> > So in summary I see:
> > - Low utility in being able to manipulate files with bad uids.
> > - Bad uids are mostly likely malicious action.
> > - make_bad_inode is trivial to analyze.
> > - No impediments to change if I am wrong.
> >
> > So unless there is a compelling case, right now I would recommend
> > returning -EIO initially.   That allows us to concentrate on the easier
> > parts of this and it leaves the changes only in fuse.
> 
> The problem with marking the inode bad is that it will mark it bad for
> all instances of this filesystem.  Including ones which are in a
> namespace where the UIDs make perfect sense.

As far as I can tell there can only be one interpretation of the uid
userspace hands us for an inode per superblock. If userspace hands us
1000 it can't map to kuid 101000 in one context and 1000 in another
context because there's only one inode. If the uid doesn't map into
whatever namespace we're using to interpret it there's no value for
i_uid which will cause it to be re-evaluated in a different context.

I don't think it would be a good idea to do that anyway. /proc is
mounted in my unprivileged container (i.e. uid 0 in the container maps
to some unprivileged uid outside the container). Interpreting uid 0 in
/proc relative to my container's namespace would give root in the
container access to things that it shouldn't have access to.

Thanks,
Seth

