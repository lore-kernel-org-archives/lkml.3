Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaFIIv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:51:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58377 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbaFIIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/146] timer: Prevent overflow in apply_slack
Date: Mon,  9 Jun 2014 10:49:20 +0200
Message-Id: <da2eadf4eedb2658cb029ba98b22490c6dcc88a0.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13db3d1..4addfa27f67d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -822,7 +822,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
-- 
1.9.3

