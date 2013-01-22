Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3AVRwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:52:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab3AVRwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:52:35 -0500
Date: Tue, 22 Jan 2013 18:51:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/3] ptrace: ensure arch_ptrace/ptrace_request can
	never race with SIGKILL
Message-ID: <20130122175146.GA17351@redhat.com>
References: <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com> <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com> <20130121194723.GA18775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121194723.GA18775@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Oleg Nesterov wrote:
>
> On 01/21, Linus Torvalds wrote:
> >
> > I guess that works then. It's a bit sad, but at least I see why you did it.
>
> OK, please see v3 rebased on top of "unexport ptrace_check_attach()" you
> already applied.
>
> I tried to update the comment in ptrace_check_attach(), and changed unfreeze()
> to simply do WARN_ON() without if/return.

Damn. But the current "if (request != PTRACE_DETACH)" is not right,
somehow I forgot that it can fail.

I am sending "[PATCH v4 2/3]" in reply to 2/3. Or see the fixlet below.

And perhaps you were right, ptrace_unfreeze_traced() should prevent the
attach-after-detach race itself... but iiuc then it needs the full mb(),
rmb() if not enough for transitivity.

Sorry for confusion.

Oleg.

------------------------------------------------------------------------------
[PATCH v3 4/3] ptrace: if PTRACE_DETACH fails we need ptrace_unfreeze_traced()

Somehow I forgot that PTRACE_DETACH can fail if !valid_signal(data).
Fix the check before ptrace_unfreeze_traced().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index b6c22b5..6cbeaae 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -939,7 +939,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out_put_task_struct;
 
 	ret = arch_ptrace(child, request, addr, data);
-	if (request != PTRACE_DETACH)
+	if (ret || request != PTRACE_DETACH)
 		ptrace_unfreeze_traced(child);
 
  out_put_task_struct:
@@ -1082,7 +1082,7 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  request == PTRACE_INTERRUPT);
 	if (!ret) {
 		ret = compat_arch_ptrace(child, request, addr, data);
-		if (request != PTRACE_DETACH)
+		if (ret || request != PTRACE_DETACH)
 			ptrace_unfreeze_traced(child);
 	}
 
-- 
1.5.5.1


