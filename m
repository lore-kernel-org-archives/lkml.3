Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaJQMz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:55:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53755 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJQMz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:55:27 -0400
To: schwidefsky@de.ibm.com, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_info structure
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
	<20141016174209.GB18318@redhat.com>
	<201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
	<20141016215834.GA28864@redhat.com>
	<20141017093653.6fa60dff@mschwide>
In-Reply-To: <20141017093653.6fa60dff@mschwide>
Message-Id: <201410172155.DAD52678.HOFStQVOFOFLJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 17 Oct 2014 21:55:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> Oleg Nesterov <oleg@redhat.com> wrote:
> > I also agree that the changelog could mention exec_mmap. Plus a comment
> > about UMH_NO_WAIT && sub_info->complete == NULL. So yes, perhaps v2 makes
> > sense if Martin agrees.
> 
> Version 2 of the patch. All change requests have gone in except for the
> mention of exec_mmap. I don't quite get the relevance of it, do_execve
> can fail for the various reasons.

OK. I understood that the

| For UMH_NO_WAIT __call_usermodehelper() frees the sub_info structure
| directly, for UMH_WAIT_EXEC the call to umh_complete() allows
| call_usermodehelper_exec() to continue which then frees sub_info.

lines described the following sequence.

----------
Race window for call_usermodehelper_exec(UMH_WAIT_EXEC) case is shown below.

(1) The caller enters into sleep at wait_for_completion()
    in call_usermodehelper_exec().
(2) The khelper thread calls __call_usermodehelper() and enters into
    sleep at kthread_create(CLONE_VFORK).
(3) The worker thread calls do_execve() in ____call_usermodehelper()
    called from call_helper().
(4) complete_vfork_done() called from mm_release() called from exec_mmap()
    called from flush_old_exec() called from binfmt handler wakes up
    the khelper thread.
(5) The khelper thread calls umh_complete() and wakes up the caller.
(6) The caller fetches sub_info->retval (which is 0) and calls
    call_usermodehelper_freeinfo().
(7) do_execve() returns a negative value due to an unexpected failure
    after complete_vfork_done() was called.
(8) The worker thread tries to store sub_info->retval (which is a negative
    value).

When hitting this race window, the caller fails to know that do_execve()
failed and the worker thread triggers use-after-free memory corruption.

The race window for call_usermodehelper_exec(UMH_NO_WAIT) case is similar
except that the caller does not enter into sleep at (1) and the khelper
thread calls call_usermodehelper_freeinfo() at (5).
----------

do_execve() can fail for the various reasons. But this race unlikely happens
because do_execve() seldom fails after complete_vfork_done() was called.
