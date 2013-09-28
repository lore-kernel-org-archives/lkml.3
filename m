Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3I1HTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 03:19:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55991 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3I1HS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 03:18:57 -0400
X-Nat-Received: from [202.181.97.72]:63175 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380352728.26479
To: rientjes@google.com
Cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org>
	<201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com>
	<201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com>
Message-Id: <201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 28 Sep 2013 16:18:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 28092013 #11086313, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> There may not be any eligible processes left and then the machine panics.  

Some of enterprise users might prefer "kernel panic followed by kdump and
automatic reboot" to "a system is not responding for unpredictable period", for
the panic helps getting information for analyzing what process caused the
freeze. Well, can they use "Panic (Reboot) On Soft Lockups" option?

> These time-based delays also have caused a complete depletion of memory 
> reserves if more than one process is chosen and each consumes an 
> non-neglible amount of memory which would then cause livelock.  We used to 
> have a jiffies-based rekill in 2.6.18 internally and we finally could 
> remove it when mm->mmap_sem issues were fixed (mostly by checking for 
> fatal_signal_pending() and aborting when necessary).

So, you've already tried that.

Currently the OOM killer kills a process after

  blocking_notifier_call_chain(&oom_notify_list, 0, &freed);

in out_of_memory() released all reclaimable memory. This call helps reducing
the chance to kill a process if the bad process no longer asks for more memory.
But if the bad process continues asking for more memory and the chosen task is
in TASK_UNINTERRUPTIBLE state, this call helps the OOM killer to be disabled
for unpredictable period. Therefore, releasing all reclaimable memory before
the OOM killer kills a process might be considered bad.

Then, what about an approach described below?

(1) Introduce a kernel thread which reserves (e.g.) 1 percent of kernel memory
    (this amount should be configurable via sysctl) upon startup.

(2) The kernel thread sleeps using wait_event(memory_reservoir_wait) and
    releases PAGE_SIZE bytes from the reserved memory upon each wakeup.

(3) The OOM killer calls wake_up() like

     	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
     		if (unlikely(frozen(task)))
     			__thaw_task(task);
    +		/* Let the memory reservoir release memory if the chosen process cannot die. */
    +		if (time_after(jiffies, p->memdie_stamp) &&
    +		    task->state == TASK_UNINTERRUPTIBLE)
    +		        wake_up(&memory_reservoir_wait);
     		if (!force_kill)
     			return OOM_SCAN_ABORT;
     	}

    in oom_scan_process_thread().

(4) When a task where test_tsk_thread_flag(task, TIF_MEMDIE) is true has
    terminated and memory used by the task is reclaimed, the reclaimed memory
    is again reserved by the kernel thread up to 1 percent of kernel memory.

In this way, we could shorten the duration of the OOM killer being disabled
unless the reserved memory was not enough to terminate the chosen process.
