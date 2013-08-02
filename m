Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3HBVJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:09:46 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44681 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3HBVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:09:42 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/3] up.c: Use local_irq_{save,restore}() in smp_call_function_single.
Date: Fri,  2 Aug 2013 14:09:35 -0700
Message-Id: <1375477776-13302-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
References: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The SMP version of this function doesn't unconditionally enable irqs,
so neither should this !SMP version.  There are no know problems
caused by this, but we make the change for consistency's sake.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 kernel/up.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/up.c b/kernel/up.c
index 144e572..b1cf036 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -10,11 +10,13 @@
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 				int wait)
 {
+	unsigned long flags;
+
 	WARN_ON(cpu != 0);
 
-	local_irq_disable();
-	(func)(info);
-	local_irq_enable();
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
 
 	return 0;
 }
-- 
1.7.11.7

