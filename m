Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3AVG1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:27:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AVG1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:27:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when module signature checking fails
In-Reply-To: <50FDC712.1030908@csamuel.org>
References: <50F67D75.9080508@csamuel.org> <87a9s3xw9g.fsf@rustcorp.com.au> <50FDC712.1030908@csamuel.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 22 Jan 2013 14:54:03 +1030
Message-ID: <87d2wxhml8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Samuel <chris@csamuel.org> writes:
> /* Please CC me, I'm not on LKML */
>
> On 21/01/13 10:36, Rusty Russell wrote:
>
>> We have errnos for a reason; let's not pollute the kernel logs.  That's
>> a userspace job.
>
> Fair enough.
>
>> This part is OK, but I'll add mod->name to the printk.
>
> Sounds good.
>
>> How's this:
>
> Looks fine, modulo the lack of mod->name as Stephen mentioned.

Yeah, here's what is now in Linus' tree:

commit 64748a2c9062da0c32b59c1b368a86fc4613b1e1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jan 21 17:03:02 2013 +1030

    module: printk message when module signature fail taints kernel.
    
    Reported-by: Chris Samuel <chris@csamuel.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index eab0827..e69a5a6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3192,8 +3192,13 @@ again:
 
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
-	if (!mod->sig_ok)
+	if (!mod->sig_ok) {
+		printk_once(KERN_NOTICE
+			    "%s: module verification failed: signature and/or"
+			    " required key missing - tainting kernel\n",
+			    mod->name);
 		add_taint_module(mod, TAINT_FORCED_MODULE);
+	}
 #endif
 
 	/* Now module is in final location, initialize linked lists, etc. */
