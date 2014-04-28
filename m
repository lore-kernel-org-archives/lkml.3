Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaD1TTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:19:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40176 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbaD1TTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:19:04 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] rcutorture: don't mark torture_init_{begin,end} with __init
Date: Mon, 28 Apr 2014 20:03:35 +0100
Message-Id: <1398711815-22153-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the time rcutorture is initialised via its module_init callback, the
.init.text section of torture.ko has already been freed, so the calls to
torture_init{begin,end} end up branching to junk.

This patch removes the __init annotations from torture_init_{begin,end}
to make sure the code is there when we want to call it.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Just lost a day to this -- I was sure my static relocation handling must
be to blame!

 kernel/torture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index acc9afc2f26e..d5ef30ce6eb5 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -596,7 +596,7 @@ static void torture_stutter_cleanup(void)
  * The runnable parameter points to a flag that controls whether or not
  * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-void __init torture_init_begin(char *ttype, bool v, int *runnable)
+void torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
 	torture_type = ttype;
@@ -610,7 +610,7 @@ EXPORT_SYMBOL_GPL(torture_init_begin);
 /*
  * Tell the torture module that initialization is complete.
  */
-void __init torture_init_end(void)
+void torture_init_end(void)
 {
 	mutex_unlock(&fullstop_mutex);
 	register_reboot_notifier(&torture_shutdown_nb);
-- 
1.9.2

