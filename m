Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3AUAO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:14:27 -0500
Received: from ozlabs.org ([203.10.76.45]:47212 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3AUAO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:14:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chris Samuel <chris@csamuel.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when module signature checking fails
In-Reply-To: <50F67D75.9080508@csamuel.org>
References: <50F67D75.9080508@csamuel.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 10:06:11 +1030
Message-ID: <87a9s3xw9g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Samuel <chris@csamuel.org> writes:
> /* Please CC me, I'm not on LKML */
>
> * Reworked from the original patch based on feedback from Josh Boyer
> * (putting the code in load_module()) and Rusty Russel (use
> * KERN_NOTICE).  Extended to cover the other failure modes.

We have errnos for a reason; let's not pollute the kernel logs.  That's
a userspace job.

> @@ -3115,8 +3130,10 @@ static int load_module(struct load_info *info, 
> const char __user *uargs,
>    #ifdef CONFIG_MODULE_SIG
>   	mod->sig_ok = info->sig_ok;
> -	if (!mod->sig_ok)
> +	if (!mod->sig_ok) {
> +		printk_once(KERN_NOTICE "Module verification failed: signature and/or 
> required key missing - tainting kernel\n");
>   		add_taint_module(mod, TAINT_FORCED_MODULE);
> +	}

This part is OK, but I'll add mod->name to the printk.

How's this:

module: printk message when module signature fail taints kernel.

Reported-by: Chris Samuel <chris@csamuel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index ec535aa..e095e19 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3169,8 +3169,12 @@ again:
 
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
-	if (!mod->sig_ok)
+	if (!mod->sig_ok) {
+		printk_once(KERN_NOTICE
+			    "%s: module verification failed: signature and/or"
+			    " required key missing - tainting kernel\n");
 		add_taint_module(mod, TAINT_FORCED_MODULE);
+	}
 #endif
 
 	/* Now module is in final location, initialize linked lists, etc. */

