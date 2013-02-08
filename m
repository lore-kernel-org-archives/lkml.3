Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947213Ab3BHV2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:28:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947086Ab3BHV2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:28:13 -0500
Date: Fri, 8 Feb 2013 16:27:26 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, williams@redhat.com
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208212726.GH31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
 <20130208003501.GC31684@hansolo.jdub.homelinux.org>
 <20130208181949.GD31684@hansolo.jdub.homelinux.org>
 <87k3qiwomi.fsf@xmission.com>
 <20130208202314.GF31684@hansolo.jdub.homelinux.org>
 <87r4kqttz8.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4kqttz8.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:45:47PM -0800, Eric W. Biederman wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> 
> > < Two emails fly past each other in the night >
> 
> Yep.
> 
> >> My best guess in some dark corner of mock has untested code to unshare a
> >> pid namespace, and that corner started doing something now that
> >> unsharing of the pid namespace actually works.
> >> 
> >> If mock has called unshare(CLONE_NEWPID). And then forked a process and
> >> that process exited, and then forked anothe process that second and all
> >> subsequent fork calls will fail with -ENOMEM (because init has exited in
> >> the pid namespace).  -ENOMEM will be generated because of a failure of
> >> alloc_pid.
> >> 
> >> Looking at that code path a little closer that just about has to be it,
> >> because I goofed and the error path drops the lock but not irqs.  The
> >> patch below should fix the nasty warning and confirm where the code is
> >> failing in copy_process.
> >
> > OK.  I'll turn the debug option back on and give this patch a try.
> 
> Thanks.  Your minimal test case also confirms my hunch. But we should
> fix the error path as well.
> 
> >> An strace to see which syscalls mock is making and with which flags
> >> would be very interesting.  I am almost certain that there is a
> >> unshare(CLONE_NEWPID) somewhere in there.  But in a remote corner of
> >> possibility it could weird clone flags, or something else.
> >
> > Oh, I have that but it's a python app with a helper C app and it's a...
> > verbose strace.  It's here for one failure:
> >
> > http://jwboyer.fedorapeople.org/pub/mock-strace
> >
> > Hopefully the testcase from my other email will help though.  It's much
> > simpler.
> 
> Yes.  Your other test case confirms my patch you bisected this to is
> working correctly.
> 
> >> Beyond that I suspect we want to work with the mock folks so they get
> >> their code to use a pid namespace working the way they intended.
> >
> > Right.  CC'd Clark (for real this time).
> >
> > I'll let you know on the patch.

The patch appears to work as expected.  With CONFIG_DEBUG_ATOMIC_SLEEP
set I don't see the backtrace error.  That should go in.

> Cool.  Looking at the strace I can't figure out what mock expected
> to happen or how mock was working before this.  As mock is calling
> unshare(CLONE_NEWNS|CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWPID) all in one
> go.
> 
> Previous to my patch enabling CLONE_NEWPID that would cause the unshare
> to fail.

Oh.  Indeed.  On a kernel without the commit in question I see this from
mock:

DEBUG: Unsharing. Flags: 738328576
DEBUG: unshare(738328576) failed, falling back to unshare(67239936)
DEBUG: Unsharing. Flags: 67239936

So it's trying with NEWPID and that fails, so it falls back to just
NEWNS | NEWUTS.  That explains it working.

> So it looks mock is taking a buggy untested code path and things are not
> working as it expected.

Quite possibly, yes.  I instrumented the kernel a bit and it is indeed
failing in the alloc_pid call.

Clark, thoughts here?

josh
