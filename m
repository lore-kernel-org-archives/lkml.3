Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3ITQIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3ITQIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:08:20 -0400
Message-ID: <1379693282.5434.10.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH v2 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if
 !audit_context
From: Eric Paris <eparis@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Richard Guy Briggs <rgb@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>, Zach Levis <zml@linux.vnet.ibm.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 20 Sep 2013 12:08:02 -0400
In-Reply-To: <20130915171109.GA15418@redhat.com>
References: <20130915171038.GA15410@redhat.com>
	 <20130915171109.GA15418@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-15 at 19:11 +0200, Oleg Nesterov wrote:
> If audit_filter_task() nacks the new thread it makes sense
> to clear TIF_SYSCALL_AUDIT which can be copied from parent
> by dup_task_struct().
> 
> A wrong TIF_SYSCALL_AUDIT is not really bad but it triggers
> the "slow" audit paths in entry.S to ensure the task can not
> miss audit_syscall_*() calls, this is pointless if the task
> has no ->audit_context.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>

Acked-by: Eric Paris <eparis@redhat.com>

Richard, please pick this up into your tree.

> ---
>  kernel/auditsc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 9845cb3..95293ab 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -943,8 +943,10 @@ int audit_alloc(struct task_struct *tsk)
>  		return 0; /* Return if not auditing. */
>  
>  	state = audit_filter_task(tsk, &key);
> -	if (state == AUDIT_DISABLED)
> +	if (state == AUDIT_DISABLED) {
> +		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
>  		return 0;
> +	}
>  
>  	if (!(context = audit_alloc_context(state))) {
>  		kfree(key);


