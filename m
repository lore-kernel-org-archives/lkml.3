Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaCCSSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:18:11 -0500
Received: from mail-wg0-f65.google.com ([74.125.82.65]:41225 "EHLO
	mail-wg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaCCSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:18:08 -0500
From: Romain Izard <romain.izard.pro@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH] trace: module: Maintain a valid user count
Date: Mon,  3 Mar 2014 19:17:32 +0100
Message-Id: <1393870652-7304-1-git-send-email-romain.izard.pro@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The replacement of the 'count' variable by two variables 'incs' and
'decs' to resolve some race conditions during module unloading was done
in parallel with some cleanup in the trace subsystem, and was integrated
as a merge.

Unfortunately, the formula for this replacement was wrong in the tracing
code, and the refcount in the traces was not usable as a result.

Use 'count = incs - decs' to compute the user count.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
---
 include/trace/events/module.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 161932737416..1228d963b6d1 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -78,7 +78,8 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) -
+			__this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 
-- 
1.8.3.2

