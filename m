Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaFGBag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:30:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36127 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Deborah Townsend" <dstownse@us.ibm.com>,
        "Jiri Bohac" <jbohac@suse.cz>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.514324212@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 41/92] timer: Prevent overflow in apply_slack
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 98a01e779f3c66b0b11cd7e64d531c0e41c95762 upstream.

On architectures with sizeof(int) < sizeof (long), the
computation of mask inside apply_slack() can be undefined if the
computed bit is > 32.

E.g. with: expires = 0xffffe6f5 and slack = 25, we get:

expires_limit = 0x20000000e
bit = 33
mask = (1 << 33) - 1  /* undefined */

On x86, mask becomes 1 and and the slack is not applied properly.
On s390, mask is -1, expires is set to 0 and the timer fires immediately.

Use 1UL << bit to solve that issue.

Suggested-by: Deborah Townsend <dstownse@us.ibm.com>
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Link: http://lkml.kernel.org/r/20140418152310.GA13654@midget.suse.cz
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -769,7 +769,7 @@ unsigned long apply_slack(struct timer_l
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 

