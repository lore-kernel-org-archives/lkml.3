Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaFGBhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <rostedt@goodmis.org>,
        "Romain Izard" <romain.izard.pro@gmail.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.848491034@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 62/92] trace: module: Maintain a valid user count
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Izard <romain.izard.pro@gmail.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/trace/events/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 

