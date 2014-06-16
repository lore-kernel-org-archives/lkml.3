Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaFPUAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaFPUAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:00:36 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: use atomic_t to simplify audit_serial()
Date: Mon, 16 Jun 2014 15:56:15 -0400
Message-Id: <2fe582f41341249b34a76b8507e6b2589fa5f676.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is already a primitive to do this operation in the atomic_t, use it
to simplify audit_serial().

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 218899b..d41266c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1257,19 +1257,9 @@ err:
  */
 unsigned int audit_serial(void)
 {
-	static DEFINE_SPINLOCK(serial_lock);
-	static unsigned int serial = 0;
+	static atomic_t serial = ATOMIC_INIT(0);
 
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(&serial_lock, flags);
-	do {
-		ret = ++serial;
-	} while (unlikely(!ret));
-	spin_unlock_irqrestore(&serial_lock, flags);
-
-	return ret;
+	return atomic_add_return(1, &serial);
 }
 
 static inline void audit_get_stamp(struct audit_context *ctx,
-- 
1.7.1

