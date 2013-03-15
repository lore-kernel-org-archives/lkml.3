Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3COSVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3COSVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:21:53 -0400
Date: Fri, 15 Mar 2013 19:19:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: lockdep splat with prepare_bprm_creds
Message-ID: <20130315181956.GA9315@redhat.com>
References: <51429E72.7090405@oracle.com> <20130315042628.GV21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315042628.GV21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Al Viro wrote:
>
> On Fri, Mar 15, 2013 at 12:07:14AM -0400, Sasha Levin wrote:
> > Hi all,
> >
> > While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> > I've stumbled on the following.
> >
> > Dave Jones reported something similar, but that seemed to involve cgroup's mutex
> > and didn't seem like it was the same issue as this one.
>
> Lovely...  It's an execve() attempt on a "binary" that is, in fact, a procfs
> file (/proc/<pid>/stack),

probably... other lock_trace() callers can't generate this lockdep output
afaics.

> with its ->read() trying to grab ->cred_guard_mutex.
> The fact that it's seq_file-based is irrelevant here - all that matters is
> that we have ->read() for some file trying to grab ->cred_guard_mutex.

Yes, perhaps the patch below makes sense anyway as a cleanup, but obviously
it can't help.

Cough... I am shy to disclose my ignorance, but could you explain how
open_exec()->do_filp_open(MAY_EXEC) can succeed in this case? At least
acl_permission_check() looks as if open_exec() should fail...

Just curious, thanks in advance.

Oleg.

--- x/fs/proc/base.c
+++ x/fs/proc/base.c
@@ -317,12 +317,12 @@ static int proc_pid_stack(struct seq_fil
 	err = lock_trace(task);
 	if (!err) {
 		save_stack_trace_tsk(task, &trace);
+		unlock_trace(task);
 
 		for (i = 0; i < trace.nr_entries; i++) {
 			seq_printf(m, "[<%pK>] %pS\n",
 				   (void *)entries[i], (void *)entries[i]);
 		}
-		unlock_trace(task);
 	}
 	kfree(entries);
 

