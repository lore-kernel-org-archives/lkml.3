Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3HGSx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:53:58 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58866 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab3HGSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130807180553.GA4920@redhat.com>
References: <20130807180530.GA4916@redhat.com>
	<20130807180553.GA4920@redhat.com>
Date: Wed, 7 Aug 2013 11:53:50 -0700
X-Google-Sender-Auth: dDLvx3YNg3APTVk_XhOyeTvXxx0
Message-ID: <CAGXu5jKuSp=c94xAQzdG4QenXnWs0X2n+jCyQb0b1Ncp6tbRMg@mail.gmail.com>
Subject: Re: [PATCH 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if !audit_context
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 11:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> If audit_filter_task() nacks the new thread it makes sense
> to clear TIF_SYSCALL_AUDIT which can be copied from parent
> by dup_task_struct().
>
> A wrong TIF_SYSCALL_AUDIT is not really bad, but it triggers
> the "slow" audit paths in entry.S.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/auditsc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 9845cb3..95293ab 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -943,8 +943,10 @@ int audit_alloc(struct task_struct *tsk)
>                 return 0; /* Return if not auditing. */
>
>         state = audit_filter_task(tsk, &key);
> -       if (state == AUDIT_DISABLED)
> +       if (state == AUDIT_DISABLED) {
> +               clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
>                 return 0;
> +       }
>
>         if (!(context = audit_alloc_context(state))) {
>                 kfree(key);
> --
> 1.5.5.1
>
>

Interestingly, I see no other callers of "clear_tsk_thread_flag(tsk,
TIF_SYSCALL_AUDIT)" :)

This patch seems right, since TIF_SYSCALL_AUDIT is set only when
audit_filter_task != AUDIT_DISABLED. Though maybe this should be
explicitly handled in dup_task_struct()?

-Kees

-- 
Kees Cook
Chrome OS Security
