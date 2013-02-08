Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947035Ab3BHUYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:24:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946902Ab3BHUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:24:00 -0500
Date: Fri, 8 Feb 2013 15:23:14 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, williams@redhat.com
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208202314.GF31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
 <20130208003501.GC31684@hansolo.jdub.homelinux.org>
 <20130208181949.GD31684@hansolo.jdub.homelinux.org>
 <87k3qiwomi.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3qiwomi.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:13:09PM -0800, Eric W. Biederman wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> >> Right, agreed.  As I said, I think that is mostly a secondary issue.
> >> Hopefully it will be easy to fix once we figure out why we're getting
> >> the ENOMEM error.
> >> 
> >> Python backtrace below.  Seems to be failing on forking a umount command
> >> after init'ing the chroot.  I can put the full output somewhere if
> >> people are interested.
> >
> > OK.  I've bisected this down to:
> >
> > 50804fe3737ca6a5942fdc2057a18a8141d00141 is the first bad commit
> > commit 50804fe3737ca6a5942fdc2057a18a8141d00141
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Tue Mar 2 15:41:50 2010 -0800
> >
> >     pidns: Support unsharing the pid namespace.
> >     
> >
> > I haven't really gotten much farther than that yet, but the bisect was
> > pretty straight forward.  Eric, is there anything specific I can gather
> > or do to help figure out why that is causing mock to get such a weird
> > error?  I can provide the bisect log if you'd like.

< Two emails fly past each other in the night >

> My best guess in some dark corner of mock has untested code to unshare a
> pid namespace, and that corner started doing something now that
> unsharing of the pid namespace actually works.
> 
> If mock has called unshare(CLONE_NEWPID). And then forked a process and
> that process exited, and then forked anothe process that second and all
> subsequent fork calls will fail with -ENOMEM (because init has exited in
> the pid namespace).  -ENOMEM will be generated because of a failure of
> alloc_pid.
> 
> Looking at that code path a little closer that just about has to be it,
> because I goofed and the error path drops the lock but not irqs.  The
> patch below should fix the nasty warning and confirm where the code is
> failing in copy_process.

OK.  I'll turn the debug option back on and give this patch a try.

> An strace to see which syscalls mock is making and with which flags
> would be very interesting.  I am almost certain that there is a
> unshare(CLONE_NEWPID) somewhere in there.  But in a remote corner of
> possibility it could weird clone flags, or something else.

Oh, I have that but it's a python app with a helper C app and it's a...
verbose strace.  It's here for one failure:

http://jwboyer.fedorapeople.org/pub/mock-strace

Hopefully the testcase from my other email will help though.  It's much
simpler.

> Beyond that I suspect we want to work with the mock folks so they get
> their code to use a pid namespace working the way they intended.

Right.  CC'd Clark (for real this time).

I'll let you know on the patch.

josh
