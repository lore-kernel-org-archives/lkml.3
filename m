Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3JEAqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 20:46:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JEAqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 20:46:15 -0400
Date: Sat, 5 Oct 2013 01:46:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pipe/cred lockdep warning
Message-ID: <20131005004612.GS13318@ZenIV.linux.org.uk>
References: <20131001145755.GA22729@redhat.com>
 <20131003185630.GJ13318@ZenIV.linux.org.uk>
 <CA+55aFxEs=bdtw-SPRSnVz7bGE3Pyi+tM7wsEdwxu+GL5qq5_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEs=bdtw-SPRSnVz7bGE3Pyi+tM7wsEdwxu+GL5qq5_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 04:27:35PM -0700, Linus Torvalds wrote:
> On Thu, Oct 3, 2013 at 11:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Note, BTW, that splice to /proc/<pid>/attr/<something> is broken.
> > proc_pid_attr_write() is *not* supposed to allow partial writes at all.
> > Frankly, I'd consider adding a ->splice_write() instance that would
> > simply return -EINVAL there...
> 
> That sounds like the right thing to do.
> 
> Or possibly go even further, and say that the default is to return
> -EINVAL, and files and filesystems that actually want the
> "default_file_splice_write()" semantics have to say so in their d_op
> structure.
> 
> Hmm?

f_op, unfortunately...  That's going to be a _lot_ of churn, I'm afraid ;-/
We have 2002 instances of file_operations in the tree.  774 of those
have ->write.  60 have both ->aio_write and ->write, 4 - only ->aio_write.

->splice_write is present only for 25.  Which leaves 753 instances of
file_operations to review and decide whether we keep the current behaviour
or start giving -EINVAL.  In a lot of those the answer will be EINVAL,
but which ones those are?

We could, I suppose, generate a commit that would add default_file_splice_write
to those 753 instances and then get rid of them one by one (e.g. provide
the same thing under different name and use that name in already reviewed
cases if behaviour is right, so that we could keep track of what's left
to do), but...
	a) if we go that way, I would suggest doing the first commit as
right-after-rc1 special
	b) I'd expect that review and removal to take at least a full cycle
and contain quite a few mistaken decisions ;-/
