Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab3DHVno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:43:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935728Ab3DHVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:43:43 -0400
Date: Mon, 8 Apr 2013 14:43:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] auditsc: Use kzalloc instead of kmalloc+memset.
Message-Id: <20130408144341.4da5f848358f0cfaba964bd7@linux-foundation.org>
In-Reply-To: <1365329658.27045.6.camel@beeld>
References: <1365329658.27045.6.camel@beeld>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Apr 2013 16:14:18 +0600 Rakib Mullick <rakib.mullick@gmail.com> wrote:

>   In function audit_alloc_context(), use kzalloc, instead of kmalloc+memset. Patch also renames audit_zero_context() to 
> audit_set_context(), to represent it's inner workings properly.
> 
> ...
>
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1034,10 +1034,9 @@ static inline void audit_free_aux(struct audit_context *context)
>  	}
>  }
>  
> -static inline void audit_zero_context(struct audit_context *context,
> +static inline void audit_set_context(struct audit_context *context,
>  				      enum audit_state state)
>  {
> -	memset(context, 0, sizeof(*context));
>  	context->state      = state;
>  	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
>  }
> @@ -1046,9 +1045,10 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
>  {
>  	struct audit_context *context;
>  
> -	if (!(context = kmalloc(sizeof(*context), GFP_KERNEL)))
> +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context)
>  		return NULL;
> -	audit_zero_context(context, state);
> +	audit_set_context(context, state);
>  	INIT_LIST_HEAD(&context->killed_trees);
>  	INIT_LIST_HEAD(&context->names_list);
>  	return context;

Fair enough.  I'd go futher...

From: Andrew Morton <akpm@linux-foundation.org>
Subject: auditsc-use-kzalloc-instead-of-kmallocmemset-fix

remove audit_set_context() altogether - fold it into its caller

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix
+++ a/kernel/auditsc.c
@@ -1034,13 +1034,6 @@ static inline void audit_free_aux(struct
 	}
 }
 
-static inline void audit_set_context(struct audit_context *context,
-				      enum audit_state state)
-{
-	context->state      = state;
-	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
-}
-
 static inline struct audit_context *audit_alloc_context(enum audit_state state)
 {
 	struct audit_context *context;
@@ -1048,7 +1041,8 @@ static inline struct audit_context *audi
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return NULL;
-	audit_set_context(context, state);
+	context->state = state;
+	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 	INIT_LIST_HEAD(&context->killed_trees);
 	INIT_LIST_HEAD(&context->names_list);
 	return context;
_

