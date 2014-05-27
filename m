Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaE0Sal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:30:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54275 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaE0Sak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:30:40 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix busted pr_info conversion in kernel/workqueue.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14250.1401215339.1@turing-police.cc.vt.edu>
Date: Tue, 27 May 2014 14:28:59 -0400
Message-ID: <14251.1401215339@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend - first attempt ate the To: line)

commit 2d916033a318d7e763eb099c69600d5dcd1ccb6b
Author: Fabian Frederick <fabf@skynet.be>
Date:   Mon May 12 13:59:35 2014 -0400

    kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info

This commit did an incorrect printk->pr_info conversion. If we were
converting to pr_info() we should lose the log_level parameter. The problem is
that this is called (indirectly) by show_regs_print_info(), which is called
with various log_levels (from _INFO clear to _EMERG). So we leave it as
a printk() call so the desired log_level is applied.

Not a full revert, as the other half of the patch is correct.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-next/kernel/workqueue.c.dist	2014-05-26 11:18:40.155380772 -0400
+++ linux-next/kernel/workqueue.c	2014-05-27 12:07:51.464678172 -0400
@@ -4440,7 +4440,7 @@ void print_worker_info(const char *log_l
 		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
 
 	if (fn || name[0] || desc[0]) {
-		pr_info("%sWorkqueue: %s %pf", log_lvl, name, fn);
+		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
 		if (desc[0])
 			pr_cont(" (%s)", desc);
 		pr_cont("\n");


