Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab3BHUNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:13:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45242 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3BHUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:13:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
Date: Fri, 08 Feb 2013 12:13:09 -0800
In-Reply-To: <20130208181949.GD31684@hansolo.jdub.homelinux.org> (Josh Boyer's
	message of "Fri, 8 Feb 2013 13:19:49 -0500")
Message-ID: <87k3qiwomi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Djtj1/IXFytBzyU3W7XCCOHTPWCA75uo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Josh Boyer <jwboyer@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> On Thu, Feb 07, 2013 at 07:35:01PM -0500, Josh Boyer wrote:
>> On Thu, Feb 07, 2013 at 02:15:02PM -0800, Andrew Morton wrote:
>> > On Thu, 7 Feb 2013 16:57:42 -0500
>> > Josh Boyer <jwboyer@redhat.com> wrote:
>> > 
>> > > Hi All,
>> > > 
>> > > We've hit a weird error in Fedora using the 3.8-rcX kernels.  It seems
>> > > the mock tool is getting back ENOMEM when doing very simple things that
>> > > normally just work.  The 3.7 kernels on the same userspace work just
>> > > fine.  It seems just running 'mock init -v' is enough to cause the
>> > > failure.
>> > 
>> > I assume you're not seeing the "page allocation failure" message and
>> > backtrace.  This means that either
>> 
>> Right.  If I disable our debug options, I see no backtraces at all and
>> the python app still gets ENOMEM returned.  (See below for those
>> interested).
>> 
>> > a) it's a __GFP_NOWARN callsite.  This is rare.  Or
>> > 
>> > b) it's actually a different error but someone went and overwrote a
>> >    callee's return value with -ENOMEM.  We do this a lot and it sucks.
>> 
>> We do it in copy_io :\.
>> 
>> > > At first glance it seems copy_io is failing (possibly because
>> > > get_task_io_context fails), and then the above fallout is printed.  The
>> > > warning seems fairly valid, but I don't think that is the root of the
>> > > problem.
>> > 
>> > yes, get_task_io_context() might be the place.  Tried adding a few
>> > error-path printks in there to see what's happening?
>> 
>> Yeah, that's my next step.  I guess I know what I'll be doing tomorrow.
>> 
>> > I can't see anything around there which leaves interrupts disabled
>> > though.  It's quite likely that there's some code with is forgetting to
>> > reenable interrupts on a rarely-tested error path, and that ENOMEM is
>> > tickling the bug.
>> 
>> Right, agreed.  As I said, I think that is mostly a secondary issue.
>> Hopefully it will be easy to fix once we figure out why we're getting
>> the ENOMEM error.
>> 
>> Python backtrace below.  Seems to be failing on forking a umount command
>> after init'ing the chroot.  I can put the full output somewhere if
>> people are interested.
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

My best guess in some dark corner of mock has untested code to unshare a
pid namespace, and that corner started doing something now that
unsharing of the pid namespace actually works.

If mock has called unshare(CLONE_NEWPID). And then forked a process and
that process exited, and then forked anothe process that second and all
subsequent fork calls will fail with -ENOMEM (because init has exited in
the pid namespace).  -ENOMEM will be generated because of a failure of
alloc_pid.

Looking at that code path a little closer that just about has to be it,
because I goofed and the error path drops the lock but not irqs.  The
patch below should fix the nasty warning and confirm where the code is
failing in copy_process.

An strace to see which syscalls mock is making and with which flags
would be very interesting.  I am almost certain that there is a
unshare(CLONE_NEWPID) somewhere in there.  But in a remote corner of
possibility it could weird clone flags, or something else.

Beyond that I suspect we want to work with the mock folks so they get
their code to use a pid namespace working the way they intended.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 8 Feb 2013 12:05:54 -0800
Subject: [PATCH] pid: unlock_irq when alloc_pid fails because init has
 exited.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index de9af60..f2c6a68 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -331,7 +331,7 @@ out:
 	return pid;
 
 out_unlock:
-	spin_unlock(&pidmap_lock);
+	spin_unlock_irq(&pidmap_lock);
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
-- 
1.7.5.4
