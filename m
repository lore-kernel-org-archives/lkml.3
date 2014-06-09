Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaFII6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58563 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Romain Izard <romain.izard.pro@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/146] trace: module: Maintain a valid user count
Date: Mon,  9 Jun 2014 10:50:25 +0200
Message-Id: <a6de3391b3a25001ba78c534482bfabdc3b8ca46.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Izard <romain.izard.pro@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 098507ae3ec2331476fb52e85d4040c1cc6d0ef4 upstream.

The replacement of the 'count' variable by two variables 'incs' and
'decs' to resolve some race conditions during module unloading was done
in parallel with some cleanup in the trace subsystem, and was integrated
as a merge.

Unfortunately, the formula for this replacement was wrong in the tracing
code, and the refcount in the traces was not usable as a result.

Use 'count = incs - decs' to compute the user count.

Link: http://lkml.kernel.org/p/1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com

Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Fixes: c1ab9cab7509 "merge conflict resolution"
Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/trace/events/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 161932737416..ca298c7157ae 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 
-- 
1.9.3

