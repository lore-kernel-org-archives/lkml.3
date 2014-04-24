Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaDXGfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:35:54 -0400
Received: from ozlabs.org ([103.22.144.67]:56157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaDXGfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:35:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: <linux-kernel@vger.kernel.org>
Cc: Valerio Vanni <valerio.vanni@inwind.it>
Cc: Elliott@ozlabs.org, Robert (Server Storage) <Elliott@hp.com>
Cc: "Lucas De Marchi" <lucas.de.marchi@gmail.com>
Subject: [PATCH] module: remove warning about waiting module removal.
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Apr 2014 15:54:50 +0930
Message-ID: <87zjjbdz2l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We remove the waiting module removal in commit 3f2b9c9cdf38 (September
2013), but it turns out that modprobe in kmod (< version 16) was
asking for waiting module removal.  Noone noticed since modprobe would
check for 0 usage immediately before trying to remove the module, and
the race is unlikely.

However, it means that anyone running old (but not ancient) kmod
versions is hitting the printk designed to see if anyone was running
"rmmod -w".  All reports so far have been false positives, so remove
the warning.

Fixes: 3f2b9c9cdf389e303b2273679af08aab5f153517
Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
Cc: Elliott, Robert (Server Storage) <Elliott@hp.com>
Cc: stable@kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index 11869408f79b..ae7821898bf2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -815,9 +815,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (!(flags & O_NONBLOCK))
-		pr_warn("waiting module removal not supported: please upgrade\n");
-
 	if (mutex_lock_interruptible(&module_mutex) != 0)
 		return -EINTR;
 
