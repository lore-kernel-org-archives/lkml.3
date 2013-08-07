Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3HGTLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab3HGTLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:11:49 -0400
Date: Wed, 7 Aug 2013 21:06:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if
	!audit_context
Message-ID: <20130807190612.GA7168@redhat.com>
References: <20130807180530.GA4916@redhat.com> <20130807180553.GA4920@redhat.com> <CAGXu5jKuSp=c94xAQzdG4QenXnWs0X2n+jCyQb0b1Ncp6tbRMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKuSp=c94xAQzdG4QenXnWs0X2n+jCyQb0b1Ncp6tbRMg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Kees Cook wrote:
>
> On Wed, Aug 7, 2013 at 11:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 9845cb3..95293ab 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -943,8 +943,10 @@ int audit_alloc(struct task_struct *tsk)
> >                 return 0; /* Return if not auditing. */
> >
> >         state = audit_filter_task(tsk, &key);
> > -       if (state == AUDIT_DISABLED)
> > +       if (state == AUDIT_DISABLED) {
> > +               clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> >                 return 0;
> > +       }
> >
> >         if (!(context = audit_alloc_context(state))) {
> >                 kfree(key);
> > --
> > 1.5.5.1
> >
> >
>
> Interestingly, I see no other callers of "clear_tsk_thread_flag(tsk,
> TIF_SYSCALL_AUDIT)" :)
>
> This patch seems right, since TIF_SYSCALL_AUDIT is set only when
> audit_filter_task != AUDIT_DISABLED. Though maybe this should be
> explicitly handled in dup_task_struct()?

Personally I agree.

But note that we have more clear-tif-after-fork's. IOW, I think we
should probably add copy_tif_flags() or something which acts like
copy_flags(). TIF_SYSCALL_TRACE, TIF_SYSCALL_EMU, TIF_NEED_RESCHED
at least. Until then we should follow the copy-them-all-then-clear
rule.

Besides, if we add the new clear_tsk_thread_flag() into copy_process's
path we probably need ifdef or ifdef'ed helper.

Oleg.

