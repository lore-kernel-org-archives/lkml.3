Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab3GKOgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:36:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3GKO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 64/98] timer: Fix jiffies wrap behavior of round_jiffies_common()
Date: Thu, 11 Jul 2013 15:24:34 +0100
Message-Id: <1373552708-15235-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bart.vanassche@gmail.com>

commit 9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1 upstream.

Direct compare of jiffies related values does not work in the wrap
around case. Replace it with time_is_after_jiffies().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/519BC066.5080600@acm.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 742912b..fab4c3b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -145,9 +145,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	/*
+	 * Make sure j is still in the future. Otherwise return the
+	 * unmodified value.
+	 */
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
-- 
1.8.1.2

