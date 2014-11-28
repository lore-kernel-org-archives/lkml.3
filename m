Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaK1Sb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:31:58 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45082 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaK1SYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:09 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 01/30] jiffies: Remove HZ > USEC_PER_SEC special case
Date: Fri, 28 Nov 2014 19:23:31 +0100
Message-Id: <1417199040-21044-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HZ never goes much further 1000 and a bit. And if we ever reach one tick
per microsecond, we might be having a problem.

Lets stop maintaining this special case.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/time.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20f..e44f6f1 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -260,10 +260,11 @@ EXPORT_SYMBOL(jiffies_to_msecs);
 
 unsigned int jiffies_to_usecs(const unsigned long j)
 {
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	/* Hz usually doesn't go much further MSEC_PER_SEC */
+	BUILD_BUG_ON(HZ >= USEC_PER_SEC);
+
+#if !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
 	return (HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
@@ -543,10 +544,8 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 {
 	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+#if !(USEC_PER_SEC % HZ)
 	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return u * (HZ / USEC_PER_SEC);
 #else
 	return (USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
-- 
2.1.3

