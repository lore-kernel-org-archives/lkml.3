Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaE0RZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:25:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40062 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaE0RZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:25:39 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix busted pr_info conversion in kernel/workqueue.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 27 May 2014 13:25:32 -0400
Message-ID: <10297.1401211532@turing-police.cc.vt.edu>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

