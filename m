Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162714Ab3LFXvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:51:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161351Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 036/152] s390/vtime: correct idle time calculation
Date: Fri,  6 Dec 2013 15:09:20 -0800
Message-Id: <1386371476-2477-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 4560e7c3317c7a2b370e36dadd3a3bac2ed70818 upstream.

Use the ACCESS_ONCE macro for both accesses to idle->sequence in the
loops to calculate the idle time. If only one access uses the macro,
the compiler is free to cache the value for the second access which
can cause endless loops.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kernel/smp.c   | 4 ++--
 arch/s390/kernel/vtime.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 7433a2f..8341c28 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -934,7 +934,7 @@ static ssize_t show_idle_count(struct device *dev,
 		idle_count = ACCESS_ONCE(idle->idle_count);
 		if (ACCESS_ONCE(idle->clock_idle_enter))
 			idle_count++;
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return sprintf(buf, "%llu\n", idle_count);
 }
 static DEVICE_ATTR(idle_count, 0444, show_idle_count, NULL);
@@ -952,7 +952,7 @@ static ssize_t show_idle_time(struct device *dev,
 		idle_time = ACCESS_ONCE(idle->idle_time);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	idle_time += idle_enter ? ((idle_exit ? : now) - idle_enter) : 0;
 	return sprintf(buf, "%llu\n", idle_time >> 12);
 }
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index e84b8b6..2fc9deb 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -195,7 +195,7 @@ cputime64_t s390_get_idle_time(int cpu)
 		sequence = ACCESS_ONCE(idle->sequence);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
 }
 
-- 
1.8.3.2

