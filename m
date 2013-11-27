Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3K0BAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846Ab3K0A7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.12 112/116] s390/vtime: correct idle time calculation
Date: Tue, 26 Nov 2013 16:58:05 -0800
Message-Id: <20131127005744.682332366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -929,7 +929,7 @@ static ssize_t show_idle_count(struct de
 		idle_count = ACCESS_ONCE(idle->idle_count);
 		if (ACCESS_ONCE(idle->clock_idle_enter))
 			idle_count++;
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return sprintf(buf, "%llu\n", idle_count);
 }
 static DEVICE_ATTR(idle_count, 0444, show_idle_count, NULL);
@@ -947,7 +947,7 @@ static ssize_t show_idle_time(struct dev
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
@@ -191,7 +191,7 @@ cputime64_t s390_get_idle_time(int cpu)
 		sequence = ACCESS_ONCE(idle->sequence);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
-	} while ((sequence & 1) || (idle->sequence != sequence));
+	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
 	return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
 }
 


