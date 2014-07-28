Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaG1OtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:49:14 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:39695 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaG1OtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:49:13 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] kernel: timer.c: Small improvement in apply_slack()
Date: Mon, 28 Jul 2014 16:48:45 +0200
Message-Id: <1406558925-24060-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In apply_slack(), find_last_bit() is applied to a bitmask consisting
of precisely BITS_PER_LONG bits. Since mask is non-zero, we might as
well eliminate the function call and use __fls() directly. On x86_64,
this shaves 22 bytes of the only caller, mod_timer().

Found through Coverity CID 1192106, but that is a false positive,
since Coverity is not aware that mask != 0 implies that find_last_bit
will not return BITS_PER_LONG.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 3bb01a3..b7d1a1e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -836,7 +836,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 	if (mask == 0)
 		return expires;
 
-	bit = find_last_bit(&mask, BITS_PER_LONG);
+	bit = __fls(mask);
 
 	mask = (1UL << bit) - 1;
 
-- 
1.9.2

