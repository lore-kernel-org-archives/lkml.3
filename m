Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab3FIUAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 16:00:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3FIUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 16:00:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] x86, range: make add_range use blank slot
Date: Sun,  9 Jun 2013 13:00:05 -0700
Message-Id: <1370808005-23565-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370808005-23565-1-git-send-email-yinghai@kernel.org>
References: <1370808005-23565-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now add_range_with_merge will generate blank slot as subtract_range.
we could reach the array limit because of blank slots.

We can let add_range to have second try to use blank slot.

Also use WARN_ONCE to print trace.

Reported-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> v3.9
---
 kernel/range.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/range.c
===================================================================
--- linux-2.6.orig/kernel/range.c
+++ linux-2.6/kernel/range.c
@@ -3,23 +3,34 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/bug.h>
 #include <linux/sort.h>
-
 #include <linux/range.h>
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
 {
-	if (start >= end)
-		return nr_range;
+	int i;
 
-	/* Out of slots: */
-	if (nr_range >= az)
+	if (start >= end)
 		return nr_range;
 
-	range[nr_range].start = start;
-	range[nr_range].end = end;
+	/* Out of slots ? */
+	if (nr_range < az) {
+		i = nr_range;
+		nr_range++;
+	} else {
+		/* find blank slot */
+		for (i = 0; i < az; i++)
+			if (!range[i].end)
+				break;
+		if (i == az) {
+			WARN_ONCE(1, "run out of slot in ranges\n");
+			return az;
+		}
+	}
 
-	nr_range++;
+	range[i].start = start;
+	range[i].end = end;
 
 	return nr_range;
 }
@@ -98,10 +109,9 @@ void subtract_range(struct range *range,
 			if (i < az) {
 				range[i].end = range[j].end;
 				range[i].start = end;
-			} else {
-				pr_err("%s: run out of slot in ranges\n",
-					__func__);
-			}
+			} else
+				WARN_ONCE(1, "run out of slot in ranges\n");
+
 			range[j].end = start;
 			continue;
 		}
