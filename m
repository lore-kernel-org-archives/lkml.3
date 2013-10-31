Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3JaPYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:24:51 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:58328 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3JaPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:24:49 -0400
Date: Thu, 31 Oct 2013 11:24:45 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: WTF: driver-core-next contains recursive directory removal!
Message-ID: <20131031152445.GB11698@mtj.dyndns.org>
References: <8761sexu2l.fsf@xmission.com>
 <20131030224444.GA9092@kroah.com>
 <87vc0etli6.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc0etli6.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Al, hi!)

Hey, again.

On Wed, Oct 30, 2013 at 03:57:37PM -0700, Eric W. Biederman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > I don't think there's an issue here, otherwise both Tejun and I would
> > have found some issues during testing, same for all of the other
> > linux-next users for the past few weeks.
> 
> There issues were subtle and hard to detect especially without
> instrumenting the code during pci hotplug to look for them.  Memory
> leaks, use after free, and needing pci hotplug to reproduce them made
> the kinds of bugs I saw when I was working with it easy to go unnoticed
> in light testing.

You're missing the part where kobject holds an extra reference of its
sysfs_dirent.  Regardless of the removal order, kobj->sd doesn't go
away until the kobj is explicitly destroyed.  I have no idea how that
would lead to the various subtle and critical issues you claim to
exist.  Can you please elaborate what you're thinking about?  As it
currently stands, it's severely lacking details.

> Beyond that the code has the deep issue that the code breaks normal
> filesystem expectations in a way that is certain to confuse filesystem
> people like Al Viro.

First of all, the current sysfs behavior is likely more confusing than
the new one - we delete local files but don't recurse into
subdirectories.  This used to work fine when all sysfs directories
were associated with a kobj as we could simply defer sysfs lifetime
management to that of kobjs.  This no longer is true.  We have
subdirectories which aren't associated with kobjects and our removal
policy is strange at best - files which exist immediately below a kobj
directory are recursively removed automatically but files under
subdirectories and subdirectories themselves aren't.  If you forget to
delete them, it doesn't even fail.  They just leak.

We can go either direction - either make removal properly recursive or
require manual recursion from sysfs users, and the merged patches
implement the former.  While the latter *could* be an option too, I
don't see how that is a good idea.  We'd be requiring meaningless
boilerplate cleanup code for no good reason and when a subsystem
forgets to delete an odd file, the options we could take would be
either 1. fail directory deletion or 2. leak undeleted nodes.  Both
suck.  Anything which complicates and fails in exit path is a pretty
bad design.  What is a driver to do after its "kill me" call fails?

I asked you multiple times why you keep mentioning Al Viro.  IIRC,
there was an issue that Al ran into back when sysfs was using vfs
constructs for its internal representation, which hasn't been the case
for ages now.  vfs interacts with sysfs the same way it interacts with
any other distributed file systems.  I hope you're not asserting that
recursive removal from remote is somehow confusing to vfs.

The implemented behavior is something which is fully understood and
can be described extremely concisely - the removal is recusrive.  I
don't think many people would have problem grasping that.

> And yes that code being at all recursive is one of the things that Viro
> objected to when you had him review sysfs before merging my cleanups
> long ago.

IIRC, my first major involvement with sysfs was completing conversion
to using sysfs_dirent exclusively for its internal representation and
I don't recall "your cleanups".  Maybe it was before my involvement.
I don't see why Al would have problem with sysfs implementing
recursive removal of its nodes, tho.  The argument is strange because
our current behavior is something a lot more unexpected.

Al, can you please chime in if you still care?

> Recursive removal is absolutely unnecessary, and it hides bugs, and
> makes the code unnecessarily complex for no good reason.

So, are you saying that it's better to require each and every user of
sysfs to remove all files and subdirectories on their cleanup paths?
Why is that beneficial?  Wouldn't that be a lot more code than
necessary?  What does that buy us?

Thanks.

-- 
tejun
