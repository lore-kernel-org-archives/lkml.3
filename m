Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaCVXuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 19:50:25 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52789 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaCVXuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:50:24 -0400
X-Nat-Received: from [202.181.97.72]:50266 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1395532222.728
To: oleg@redhat.com
Cc: joseph.salisbury@canonical.com, JBottomley@parallels.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-scsi@vger.kernel.org, thenzl@redhat.com
Subject: Re: please fix FUSION (Was:[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <532B1B67.5050104@canonical.com>
	<20140320192307.GA11883@redhat.com>
	<20140321183443.GA3891@redhat.com>
	<201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
	<20140322192511.GA14811@redhat.com>
In-Reply-To: <20140322192511.GA14811@redhat.com>
Message-Id: <201403230850.FGE57320.QOtJHFSMOVLFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 23 Mar 2014 08:50:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 22032014 #7600319, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/22, Tetsuo Handa wrote:
> >
> > Oleg Nesterov wrote:
> > > Tetsuo, what do you think?
> >
> > I don't like blocking SIGKILL while doing operations that depend on memory
> > allocation by other processes. If the OOM killer is triggered and it chose
> > the process blocking SIGKILL in mptsas_init() (I know it unlikely happens),
> > it generates the OOM killer deadlock.
> 
> It seems that we do not understand each other.
> 

I'm agreeing with you regarding long term solution. I think that I and you
do not understand each other regarding which approach should be used for short
term solution.

> I do not like this hack too. And it is even wrong, you can't really block
> SIGKILL. And it is unnecessary in a sense that (I think) it is fine that
> module_init() reacts to SIGKILL and aborts, just the fact it crashes the
> kernel in the error paths is not fine.

I expect that kernel code reacts to SIGKILL and aborts, but current code
(not only fusion but any code) is not ready for reacting to SIGKILL due to
use of uninterruptible versions of lock/wait etc. operators.

> The driver should be fixed anyway. As for timeout, either userspace/systemd
> should be changed to not send SIGKILL after 30 secs, or (better) the driver
> should be changed to not waste 30 secs.

I'm not asserting that we should not fix the driver and the userspace.
I agree that we should fix the driver to respond SIGKILL properly and
fix the userspace not to send SIGKILL on hard coded timeout.

> 
> The hack I sent can only serve as a short term solution, it should be
> reverted once we have something better. And, otoh, this hack only affects
> the problematic driver which should be fixed in any case.
> 
> Do you see my point? I can be wrong, but I think that you constantly
> misunderstand the intent.
> 
> > My preference is to fix kthread_create() to handle SIGKILL gracefully.
> 
> And now I do not understand you too. I do not understand why should we
> "fix" kthread_create().

I can see your point. But as for kernel for Ubuntu 14.04 LTS (which the date
of kernel freeze comes shortly), fixing kthread_create() is the safer choice,
for we haven't proved that the fusion is the only kernel code which is
disturbed by commit 786235ee.

After we confirmed that there is no more kernel code which is disturbed by
commit 786235ee, we can revert the "kthread: Handle SIGKILL gracefully in
kthread_create()." patch.

> 
> > Many kernel operations (e.g. mutex_lock() wait_event() wait_for_completion())
> > ignore SIGKILL and the current users depend on SIGKILL being ignored. Thus,
> > commit 786235ee sounds like a kernel API breakage.
> 
> Personally I do not really think so, but OK. In this case lets revert
> 786235ee.
> 
> > Commit 786235ee "kthread: make kthread_create() killable" changed to
> > leave kthread_create() as soon as receiving SIGKILL. But this change
> > caused boot failures because systemd-udevd receives SIGKILL due to timeout
> > while loading SCSI controller drivers using finit_module() [1].
> 
> And I still think that 786235ee simply uncovered the problems in this
> driver. Perhaps we should change kthread_create() for some reason, but
> (imho) not because we need to help the buggy code.
> 

I don't mean to help the buggy code. The "kthread: Handle SIGKILL gracefully
in kthread_create()." patch (or revert commit 786235ee) is short term solution
(especially for distributions which the date of kernel freeze is approaching).

> > Therefore, this patch changes kthread_create() from "wait forever in
> > killable state" to "wait for 10 seconds in unkillable state, check for
> > the OOM killer every second".
> 
> Personally I dislike this change. In fact I think it is ugly. But this
> is only my opinion.
> 
> If you convince someone to take this patch I won't argue.
