Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572Ab3D3Mfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760119Ab3D3Mfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:35:46 -0400
Date: Tue, 30 Apr 2013 14:36:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
Message-ID: <20130430123634.GA10465@redhat.com>
References: <515DBB00.20208@sr71.net>
 <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
 <5162E8DC.4080204@sr71.net>
 <20130411074529.GA1629@redhat.com>
 <51670549.70205@sr71.net>
 <20130416110651.GB620@redhat.com>
 <516DBD12.4030006@sr71.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <516DBD12.4030006@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 02:05:22PM -0700, Dave Hansen wrote:
> > But since this (most likely) is rtime monotonicity problem it
> > is bug by itself and probably that should be fixed. Can you 
> > check second patch attached and see if it trigger the warning.
> 
> Yup, it triggers lots of warnings.  Here's one.
> 
> > [  460.789710] ------------[ cut here ]------------
> > [  460.789730] WARNING: at /home/davehans/linux.git/kernel/sched/cputime.c:563 cputime_adjust+0xe6/0xf0()
> > [  460.789736] Hardware name: PRIMEQUEST 1800E2
> > [  460.789739] Modules linked in:
> > [  460.789745] Pid: 4245, comm: top Tainted: G        W    3.9.0-rc7-00004-gbb33db7-dirty #19
> > [  460.789748] Call Trace:
> > [  460.789777]  [<ffffffff810c6dc7>] warn_slowpath_common+0xb7/0x120
> > [  460.789783]  [<ffffffff810c6e5a>] warn_slowpath_null+0x2a/0x40
> > [  460.789789]  [<ffffffff8111a8d6>] cputime_adjust+0xe6/0xf0
> > [  460.789795]  [<ffffffff8111b755>] ? thread_group_cputime+0x5/0x140
> > [  460.789800]  [<ffffffff8111bbb9>] thread_group_cputime_adjusted+0x59/0x70

Dave, could you test attached patch and check if make warnings gone.
Patch is not right fix, but if it prevent the warnings, this will
give clue where the problem can be.

Stanislaw

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="stop_use_task_sched_runtime.patch"

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e93cca9..057faa8 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -313,7 +313,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
+		times->sum_exec_runtime += t->se.sum_exec_runtime;
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();

--k1lZvvs/B4yU6o8G--
