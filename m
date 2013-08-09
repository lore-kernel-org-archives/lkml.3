Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967860Ab3HINem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967832Ab3HINel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:34:41 -0400
Date: Fri, 9 Aug 2013 15:28:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch for lost wakeups
Message-ID: <20130809132851.GA31901@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Linus Torvalds wrote:
>
> > Name:    Xorg
> > State:    S (sleeping)
> > Tgid:    2597
> > Pid:    2597
> > PPid:    2595
> > TracerPid:    0
> > Uid:    0    0    0    0
> > Gid:    0    0    0    0
> > FDSize:    64
> > Groups:
> > VmPeak:       44640 kB
> > VmSize:       31232 kB
> > VmLck:           0 kB
> > VmHWM:       20560 kB
> > VmRSS:       20016 kB
> > VmData:        5728 kB
> > VmStk:         160 kB
> > VmExe:        1952 kB
> > VmLib:       11296 kB
> > VmPTE:         128 kB
> > VmSwap:           0 kB
> > Threads:    1
> > SigQ:    1/15809
> > SigPnd:    00000000000000000000000000000000
> > ShdPnd:    00000000000000000000000000200000
> > SigBlk:    00000000000000000000000000000000
> > SigIgn:    80000000000000000000000006001000
> > SigCgt:    000000000000000000000001e020eecf

OK, given that Threads == 1 this is wrong in any case.

Could you please reproduce with the trivial patch below ? (please also
should /proc/pid/stack).

If (with this patch) SigQ: should "1" at the end, then we have a scheduler
race or someone does set_tsk_thread_flag(non-current-task, TIF_SIGPENDING)
without locking/wakeup.

Otherwise we should identify the wrong clear_flag(TIF_SIGPENDING).

Oleg.


diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..d4a8cbb 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -286,7 +286,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 	}
 
 	seq_printf(m, "Threads:\t%d\n", num_threads);
-	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
+	seq_printf(m, "SigQ:\t%lu/%lu %d\n", qsize, qlim, !!signal_pending(p));
 
 	/* render them all */
 	render_sigset_t(m, "SigPnd:\t", &pending);

