Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaEHLNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:13:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750942AbaEHLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:13:29 -0400
Date: Thu, 8 May 2014 07:13:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Romain Izard <romain.izard.pro@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [GIT PULL] trace: module: Maintain a valid user count
Message-ID: <20140508071327.38a880d7@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This is a long standing bug that causes bogus data to show up
in the refcnt field of the module_refcnt tracepoint. It was
introduced by a merge conflict resolution back in 2.6.35-rc days.

The result should be refcnt = incs - decs, but instead it did
refcnt = incs + decs.

Please pull the latest trace-fixes-v3.15-rc4 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.15-rc4

Tag SHA1: df839af2f97c5761d24b7a1c80f5ac8c4fa63dfe
Head SHA1: 098507ae3ec2331476fb52e85d4040c1cc6d0ef4


Romain Izard (1):
      trace: module: Maintain a valid user count

----
 include/trace/events/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 098507ae3ec2331476fb52e85d4040c1cc6d0ef4
Author: Romain Izard <romain.izard.pro@gmail.com>
Date:   Tue Mar 4 10:09:39 2014 +0100

    trace: module: Maintain a valid user count
    
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
 
