Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3FIPuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:50:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13543 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3FIPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:50:20 -0400
X-Spam-Score: -100.8
Message-ID: <51B4A408.4050909@asianux.com>
Date: Sun, 09 Jun 2013 23:49:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: timer: looping issue, need reset variable 'found'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to __internal_add_timer(), in _next_timer_interrupt(), when
'tv1.vec' find one, but need 'cascade bucket(s)', we still need find
each slot of 'tv*.vec'.

So need reset variable 'found', so can fully scan ''do {...} while()''
for 'tv*.vec'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/timer.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index aa8b964..0fce618 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1197,7 +1197,7 @@ static unsigned long __next_timer_interrupt(struct tvec_base *base)
 {
 	unsigned long timer_jiffies = base->timer_jiffies;
 	unsigned long expires = timer_jiffies + NEXT_TIMER_MAX_DELTA;
-	int index, slot, array, found = 0;
+	int index, slot, array;
 	struct timer_list *nte;
 	struct tvec *varray[4];
 
@@ -1208,7 +1208,6 @@ static unsigned long __next_timer_interrupt(struct tvec_base *base)
 			if (tbase_get_deferrable(nte->base))
 				continue;
 
-			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
 			if (!index || slot < index)
@@ -1232,6 +1231,7 @@ cascade:
 
 	for (array = 0; array < 4; array++) {
 		struct tvec *varp = varray[array];
+		bool found = false;
 
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
@@ -1239,7 +1239,7 @@ cascade:
 				if (tbase_get_deferrable(nte->base))
 					continue;
 
-				found = 1;
+				found = true;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
 			}
-- 
1.7.7.6
