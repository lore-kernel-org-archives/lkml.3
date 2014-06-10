Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaFJTuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:50:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaFJTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 109/160] module: remove warning about waiting module removal.
Date: Tue, 10 Jun 2014 12:45:49 -0700
Message-Id: <1402429600-20477-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 79465d2fd48e68940c2bdecddbdecd45bbba06fe upstream.

We remove the waiting module removal in commit 3f2b9c9cdf38 (September
2013), but it turns out that modprobe in kmod (< version 16) was
asking for waiting module removal.  No one noticed since modprobe would
check for 0 usage immediately before trying to remove the module, and
the race is unlikely.

However, it means that anyone running old (but not ancient) kmod
versions is hitting the printk designed to see if anyone was running
"rmmod -w".  All reports so far have been false positives, so remove
the warning.

Fixes: 3f2b9c9cdf389e303b2273679af08aab5f153517
Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
Cc: Elliott, Robert (Server Storage) <Elliott@hp.com>
Acked-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[ kamal: backport to 3.13: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/module.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f5a3b1e..6b931bd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -815,11 +815,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (!(flags & O_NONBLOCK)) {
-		printk(KERN_WARNING
-		       "waiting module removal not supported: please upgrade");
-	}
-
 	if (mutex_lock_interruptible(&module_mutex) != 0)
 		return -EINTR;
 
-- 
1.9.1

