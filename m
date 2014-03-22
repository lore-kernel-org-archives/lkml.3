Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaCVVZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:25:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:56082 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaCVVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:25:04 -0400
Date: Sat, 22 Mar 2014 22:25:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        joseph.salisbury@canonical.com, JBottomley@parallels.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-scsi@vger.kernel.org, thenzl@redhat.com
Subject: Re: please fix FUSION (Was:
 [v3.13][v3.14][Regression]kthread:makekthread_create()killable)
In-Reply-To: <20140322192511.GA14811@redhat.com>
Message-ID: <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
References: <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
 <20140322192511.GA14811@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Oleg Nesterov wrote:
> On 03/22, Tetsuo Handa wrote:
> > Many kernel operations (e.g. mutex_lock() wait_event() wait_for_completion())
> > ignore SIGKILL and the current users depend on SIGKILL being ignored. Thus,
> > commit 786235ee sounds like a kernel API breakage.
> 
> Personally I do not really think so, but OK. In this case lets revert
> 786235ee.

We have explicitely:

    mutex_lock, mutex_lock_killable and mutex_lock_interruptible.

Ditto for wait_event and wait_for_completion.

So the existance of the uninterruptible versions does not make an
argument for the kthread_create() case.
 
> > Commit 786235ee "kthread: make kthread_create() killable" changed to
> > leave kthread_create() as soon as receiving SIGKILL. But this change
> > caused boot failures because systemd-udevd receives SIGKILL due to timeout
> > while loading SCSI controller drivers using finit_module() [1].
> 
> And I still think that 786235ee simply uncovered the problems in this
> driver. Perhaps we should change kthread_create() for some reason, but
> (imho) not because we need to help the buggy code.

Right.
 
> > Therefore, this patch changes kthread_create() from "wait forever in
> > killable state" to "wait for 10 seconds in unkillable state, check for
> > the OOM killer every second".
> 
> Personally I dislike this change. In fact I think it is ugly. But this
> is only my opinion.

It's not only ugly, it's activly wrong. It's as wrong as 786235ee
itself. And 786235ee needs to be reverted and the revert must go into
3.13.stable as well. I'll send a revert request in separate mail.

Thanks,

	tglx
