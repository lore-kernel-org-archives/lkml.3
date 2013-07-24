Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3GXOSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:18:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45888 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab3GXOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Arjan van de Ven" <arjan@infradead.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Bart Van Assche" <bart.vanassche@gmail.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.40666954@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [51/85] timer: Fix jiffies wrap behavior of round_jiffies_common()
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -145,9 +145,11 @@ static unsigned long round_jiffies_commo
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

