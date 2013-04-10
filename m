Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3DJRHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3DJRHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:07:30 -0400
Date: Wed, 10 Apr 2013 13:07:21 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: destroy filename correctly
Message-ID: <20130410130721.12dd6755@tlielax.poochiereds.net>
In-Reply-To: <1364799600-10338-1-git-send-email-dmonakhov@openvz.org>
References: <1364799600-10338-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Apr 2013 11:00:00 +0400
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> filename should be destroyed via final_putname() instead of __putname()
> Otherwise this result in following BUGON() in case of long names:
>   kernel BUG at mm/slab.c:3006!
>   Call Trace:
>   kmem_cache_free+0x1c1/0x850
>   audit_putname+0x88/0x90
>   putname+0x73/0x80
>   sys_symlinkat+0x120/0x150
>   sys_symlink+0x16/0x20
>   system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  kernel/auditsc.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index a371f85..bfe7ca6 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1010,7 +1010,7 @@ static inline void audit_free_names(struct audit_context *context)
>  	list_for_each_entry_safe(n, next, &context->names_list, list) {
>  		list_del(&n->list);
>  		if (n->name && n->name_put)
> -			__putname(n->name);
> +			final_putname(n->name);
>  		if (n->should_free)
>  			kfree(n);
>  	}
> @@ -2036,7 +2036,7 @@ void audit_putname(struct filename *name)
>  	BUG_ON(!context);
>  	if (!context->in_syscall) {
>  #if AUDIT_DEBUG == 2
> -		printk(KERN_ERR "%s:%d(:%d): __putname(%p)\n",
> +		printk(KERN_ERR "%s:%d(:%d): final_putname(%p)\n",
>  		       __FILE__, __LINE__, context->serial, name);
>  		if (context->name_count) {
>  			struct audit_names *n;
> @@ -2047,7 +2047,7 @@ void audit_putname(struct filename *name)
>  				       n->name, n->name->name ?: "(null)");
>  			}
>  #endif
> -		__putname(name);
> +		final_putname(name);
>  	}
>  #if AUDIT_DEBUG
>  	else {

Looks correct to me...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
