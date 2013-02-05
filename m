Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3BEWNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3BEWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 89/93] module: fix missing module_mutex unlock
Date: Tue,  5 Feb 2013 20:07:18 -0200
Message-Id: <1360102042-10732-90-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ee61abb3223e28a1a14a8429c0319755d20d3e40 upstream.

Commit 1fb9341ac348 ("module: put modules in list much earlier") moved
some of the module initialization code around, and in the process
changed the exit paths too.  But for the duplicate export symbol error
case the change made the ddebug_cleanup path jump to after the module
mutex unlock, even though it happens with the mutex held.

Rusty has some patches to split this function up into some helper
functions, hopefully the mess of complex goto targets will go away
eventually.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 19716ac..2ad732d1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3033,8 +3033,8 @@ again:
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-	mutex_unlock(&module_mutex);
  ddebug_cleanup:
+	mutex_unlock(&module_mutex);
 	dynamic_debug_remove(info.debug);
 	synchronize_sched();
 	kfree(mod->args);
-- 
1.7.9.5

