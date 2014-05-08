Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaEHVID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:08:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:50414 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753994AbaEHVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:07:59 -0400
Message-Id: <20140508210750.343298193@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 08 May 2014 17:07:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>,
        Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH 1/2] trace: module: Maintain a valid user count
References: <20140508210703.464573159@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-trace-module-Maintain-a-valid-user-count.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Izard <romain.izard.pro@gmail.com>

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
Cc: stable@vger.kernel.org # 2.6.35
Fixes: c1ab9cab7509 "merge conflict resolution"
Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 11fd51b..daa60c7 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -80,7 +80,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 
-- 
1.8.5.3


