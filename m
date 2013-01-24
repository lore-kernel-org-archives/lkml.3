Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024Ab3AXVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:30:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:40316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab3AXVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 37/46] module: fix missing module_mutex unlock
Date: Thu, 24 Jan 2013 13:13:15 -0800
Message-Id: <20130124211149.542636401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3100,8 +3100,8 @@ again:
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-	mutex_unlock(&module_mutex);
  ddebug_cleanup:
+	mutex_unlock(&module_mutex);
 	dynamic_debug_remove(info.debug);
 	synchronize_sched();
 	kfree(mod->args);


