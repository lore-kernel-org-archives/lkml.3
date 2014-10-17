Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaJQN5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbaJQN5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:57:14 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource, Add warning to clocksource_delta() validation code
Date: Fri, 17 Oct 2014 09:57:06 -0400
Message-Id: <1413554226-12652-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug report came in against an older kernel which output "backward time"
messages and the report noted that the upstream kernel worked.  After some
investigation it turned out that one of the sockets was bad on the system
and the "backward time" messages were caused by a real, but intermittent,
hardware failure.

Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108 ("clocksource: Move
cycle_last validation to core code") modifies the x86 clocksource such that
if a negative delta between two reads of time is calculated the
clocksource_delta() code will return 0.  There is no warning when this
occurs and there really should be one in order to catch not only hardware
issues like the issue above, but potential coding issues as the code is
modified.  This patch introduces a WARN() which will also dump a stack
trace to the console so the exact code path can be evaluated.

I tested this by booting on the broken hardware and left the system idle
until a negative clocksource_delta() event occurred.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 kernel/time/timekeeping_internal.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
index 4ea005a..abe6bc8 100644
--- a/kernel/time/timekeeping_internal.h
+++ b/kernel/time/timekeeping_internal.h
@@ -17,7 +17,12 @@ static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
 {
 	cycle_t ret = (now - last) & mask;
 
-	return (s64) ret > 0 ? ret : 0;
+	if ((s64)ret > 0)
+		return ret;
+
+	WARN(1, "Clocksource calculated negative delta, %lld.  last = %llu, now = %llu, mask = %llx\n",
+	     (s64)ret, last, now, mask);
+	return 0;
 }
 #else
 static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
-- 
1.7.9.3

