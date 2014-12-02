Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaLBEFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:05:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34535 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbaLBEEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: do a safe overflow check in ktime_add_safe
Date: Mon,  1 Dec 2014 23:04:05 -0500
Message-Id: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktime_add_safe would check for overflows, but since ktime variables are
signed, overflowing them is an undefined behaviour and should be avoided.

Rather than checking for wraparound after the overflow, check for
potential overflowing values prior to adding both ktimes.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/time/hrtimer.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aa..42fb631 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -290,16 +290,14 @@ EXPORT_SYMBOL_GPL(ktime_divns);
  */
 ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
 {
-	ktime_t res = ktime_add(lhs, rhs);
-
 	/*
 	 * We use KTIME_SEC_MAX here, the maximum timeout which we can
 	 * return to user space in a timespec:
 	 */
-	if (res.tv64 < 0 || res.tv64 < lhs.tv64 || res.tv64 < rhs.tv64)
-		res = ktime_set(KTIME_SEC_MAX, 0);
+	if (lhs.tv64 > (KTIME_MAX - rhs.tv64))
+		return ktime_set(KTIME_SEC_MAX, 0);
 
-	return res;
+	return ktime_add(lhs, rhs);
 }
 
 EXPORT_SYMBOL_GPL(ktime_add_safe);
-- 
1.7.10.4

