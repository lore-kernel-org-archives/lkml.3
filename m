Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaF3Vvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:51:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:13588 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaF3Vvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:45 -0400
Message-Id: <20140630215144.592455236@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 30 Jun 2014 17:50:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [for-next][PATCH 2/4] uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
References: <20140630215038.852406012@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-uprobes-Change-unregister-apply-to-WARN-if-uprobe-co.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Add WARN_ON's into uprobe_unregister() and uprobe_apply() to ensure
that nobody tries to play with the dead uprobe/consumer. This helps
to catch the bugs like the one fixed by the previous patch.

In the longer term we should fix this poorly designed interface.
uprobe_register() should return "struct uprobe *" which should be
passed to apply/unregister. Plus other semantic changes, see the
changelog in commit 41ccba029e94.

Link: http://lkml.kernel.org/p/20140627170140.GA18322@redhat.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/uprobes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c445e392e93f..6f3254e8c137 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -846,7 +846,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
 {
 	int err;
 
-	if (!consumer_del(uprobe, uc))	/* WARN? */
+	if (WARN_ON(!consumer_del(uprobe, uc)))
 		return;
 
 	err = register_for_each_vma(uprobe, NULL);
@@ -927,7 +927,7 @@ int uprobe_apply(struct inode *inode, loff_t offset,
 	int ret = -ENOENT;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return ret;
 
 	down_write(&uprobe->register_rwsem);
@@ -952,7 +952,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	struct uprobe *uprobe;
 
 	uprobe = find_uprobe(inode, offset);
-	if (!uprobe)
+	if (WARN_ON(!uprobe))
 		return;
 
 	down_write(&uprobe->register_rwsem);
-- 
2.0.0


