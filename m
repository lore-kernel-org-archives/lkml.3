Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3BHUTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:19:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947016Ab3BHUTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:19:13 -0500
Date: Fri, 8 Feb 2013 15:18:27 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208201826.GE31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
 <20130208003501.GC31684@hansolo.jdub.homelinux.org>
 <20130208181949.GD31684@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208181949.GD31684@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 01:19:49PM -0500, Josh Boyer wrote:
> On Thu, Feb 07, 2013 at 07:35:01PM -0500, Josh Boyer wrote:
> > On Thu, Feb 07, 2013 at 02:15:02PM -0800, Andrew Morton wrote:
> > > On Thu, 7 Feb 2013 16:57:42 -0500
> > > Josh Boyer <jwboyer@redhat.com> wrote:
> > > 
> > > > Hi All,
> > > > 
> > > > We've hit a weird error in Fedora using the 3.8-rcX kernels.  It seems
> > > > the mock tool is getting back ENOMEM when doing very simple things that
> > > > normally just work.  The 3.7 kernels on the same userspace work just
> > > > fine.  It seems just running 'mock init -v' is enough to cause the
> > > > failure.
> > > 
> > > I assume you're not seeing the "page allocation failure" message and
> > > backtrace.  This means that either
> > 
> > Right.  If I disable our debug options, I see no backtraces at all and
> > the python app still gets ENOMEM returned.  (See below for those
> > interested).
> > 
> > > a) it's a __GFP_NOWARN callsite.  This is rare.  Or
> > > 
> > > b) it's actually a different error but someone went and overwrote a
> > >    callee's return value with -ENOMEM.  We do this a lot and it sucks.
> > 
> > We do it in copy_io :\.
> > 
> > > > At first glance it seems copy_io is failing (possibly because
> > > > get_task_io_context fails), and then the above fallout is printed.  The
> > > > warning seems fairly valid, but I don't think that is the root of the
> > > > problem.
> > > 
> > > yes, get_task_io_context() might be the place.  Tried adding a few
> > > error-path printks in there to see what's happening?
> > 
> > Yeah, that's my next step.  I guess I know what I'll be doing tomorrow.
> > 
> > > I can't see anything around there which leaves interrupts disabled
> > > though.  It's quite likely that there's some code with is forgetting to
> > > reenable interrupts on a rarely-tested error path, and that ENOMEM is
> > > tickling the bug.
> > 
> > Right, agreed.  As I said, I think that is mostly a secondary issue.
> > Hopefully it will be easy to fix once we figure out why we're getting
> > the ENOMEM error.
> > 
> > Python backtrace below.  Seems to be failing on forking a umount command
> > after init'ing the chroot.  I can put the full output somewhere if
> > people are interested.
> 
> OK.  I've bisected this down to:
> 
> 50804fe3737ca6a5942fdc2057a18a8141d00141 is the first bad commit
> commit 50804fe3737ca6a5942fdc2057a18a8141d00141
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Tue Mar 2 15:41:50 2010 -0800
> 
>     pidns: Support unsharing the pid namespace.
>     
> 
> I haven't really gotten much farther than that yet, but the bisect was
> pretty straight forward.  Eric, is there anything specific I can gather
> or do to help figure out why that is causing mock to get such a weird
> error?  I can provide the bisect log if you'd like.

I took a look at what mock was doing and it was mostly very simple
stuff.  The two exceptions were that it was calling unshare, then doing
some file checks and I/O, and then calling fork to exec off some helper
things.  Up until the point it fails, the forks work and the children go
do whatever it is they were supposed to do.  I've CC'd Clark Williams
just in case people have questions on mock itself, but I'm not sure that
will be needed.

I have a very simple testcase (warning, ugly code) that hits this issue
now.  Build with "gcc -D_GNU_SOURCE -g unshare.c -o unshare" and then
just run it as "sudo ./unshare 10".  The sudo is needed for the unshare
call to work.

I get the following output on kernels that have the above commit:

[jwboyer@vader ~]$ sudo ./unshare 10
Calling unshare 738328576
Forked 6684
Forked 6685
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
Fork failed: Cannot allocate memory
[jwboyer@vader ~]$

which is consistent with what mock is seeing.  If I comment out the call
to unshare, it seems to always work.  It seems to consistently fail with
ENOMEM after the first 3-5 forked children, but it varies within that
range.

On a kernel without the above commit, this works every time.  I've tried
variations of 10, 100, and 10,000 iterations successfully with and
without the unshare call.

Hopefully this helps.  Testcase below.

josh

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sched.h>

int main(int argc, char **argv)
{
	int i, flags = CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWPID | CLONE_NEWIPC;
	int fd;
	pid_t pid;
	
	fd = open("./wtf-unshare", O_CREAT|O_RDWR, 0666);
	write(fd, "blah", 4);

	printf("Calling unshare %d\n", flags);
	unshare(flags);

	for (i = 0; i < atoi(argv[1]); i++) {
		pid = fork();

		if (pid == 0)
			exit(0);
		else if (pid == -1)
			perror("Fork failed");
		else
			printf("Forked %d\n", pid);
	}
	
	return 0;
}
