Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab3K0BiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:38:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab3K0A6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.10 75/80] s390/vtime: correct idle time calculation
Date: Tue, 26 Nov 2013 16:57:44 -0800
Message-Id: <20131127005646.121386715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 4560e7c3317c7a2b370e36dadd3a3bac2ed70818 upstream.

Use the ACCESS_ONCE macro for both accesses to idle->sequence in the
loops to calculate the idle time. If only one access uses the macro,
the compiler is free to cache the value for the second access which
can cause endless loops.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/smp.c   |    4 ++--
 arch/s390/kernel/vtime.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -933,7 +933,7 @@ static ssize_t show_idle_count(struct de
 		idle_count = ACCESS_ONCE(idle->idle_count);
 		if (ACCESS_ONCE(idle->clock_idle_enter))
 			idle_count++;
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return sprintf(buf, "%llu\n", idle_count);
 }
 static DEVICE_ATTR(idle_count, 0444, show_idle_count, NULL);
@@ -951,7 +951,7 @@ static ssize_t show_idle_time(struct dev
 		idle_time = ACCESS_ONCE(idle->idle_time);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	idle_time += idle_enter ? ((idle_exit ? : now) - idle_enter) : 0;
 	return sprintf(buf, "%llu\n", idle_time >> 12);
 }
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -190,7 +190,7 @@ cputime64_t s390_get_idle_time(int cpu)
 		sequence = ACCESS_ONCE(idle->sequence);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
 }
 


