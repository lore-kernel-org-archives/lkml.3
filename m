Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3EHVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:01:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38509 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932101Ab3EHVBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:01:47 -0400
Message-Id: <20130508210144.268483628@asylum.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Wed, 08 May 2013 16:01:04 -0500
From: athorlton@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 2/2] panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix up issues with interspersed output from multiple
simultaneous calls to warn or dump_stack on multi-cpu systems.
References: <20130508210102.898396979@asylum.americas.sgi.com>
Content-Disposition: inline; filename=add-cpu-pid-warn.patch

This patch adds in the cpu/pid that called WARN() so that the stack
traces can be matched up with the WARNING messages.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Robin Holt <holt@sgi.com>
Signed-off-by: Alex Thorlton <athorlton@sgi.com>
---
 kernel/panic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux.orig/kernel/panic.c
+++ linux/kernel/panic.c
@@ -399,8 +399,9 @@ struct slowpath_args {
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
+	pr_warn("------------[ cut here ]------------\n");
+	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",  '
+		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);

