Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3ATUVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 15:21:36 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:61273 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3ATUVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 15:21:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130120192527.GC6771@redhat.com>
References: <20130116181830.GA6469@redhat.com> <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com>
 <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com>
 <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com>
 <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com>
 <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
 <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 12:21:14 -0800
X-Google-Sender-Auth: 4Elu02bob70aFsFfomM-DYZTPsI
Message-ID: <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ptrace: ensure arch_ptrace/ptrace_request can never
 race with SIGKILL
To: Oleg Nesterov <oleg@redhat.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 11:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> +
> +static void ptrace_unfreeze_traced(struct task_struct *task)
> +{
> +       if (task->state != __TASK_TRACED)
> +               return;
> +
> +       if (WARN_ON(!task->ptrace || task->parent != current))
> +               return;

This WARN_ON() is bogus.

Because you added the warning, you then need to make the callers check
for the whole PTRACE_UNATTACH.

So I think you should just remove the WARN_ON(), and then just call
ptrace_unfreeze_traced() unconditionally after you've successfully
done a ptrace_check_attach(). Just to keep the code simpler.

Also, in your corrected version, you had

+               if (!wait_task_inactive(child, __TASK_TRACED)) {
+                       /* This can only happen if may_ptrace_stop() fails */
+                       WARN_ON(child->state == __TASK_TRACED);
+                       ret = -ESRCH;

where I actually think that the comment is not really helpful. It
doesn't really explain what he child can do to get to ptrace_stop() in
the first place, and what that does to the child state...

               Linus
