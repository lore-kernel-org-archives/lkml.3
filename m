Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbbAZKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:13:26 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:36998 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAZKNX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 05:13:23 -0500
Message-ID: <1422267197.24914.13.camel@stgolabs.net>
Subject: [PATCH] drivers/block/swim: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Date: Mon, 26 Jan 2015 02:13:17 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_current_state() instead of assigning the new state directly.
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments,
keeping track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index b5afd49..1a0b395 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -331,7 +331,7 @@ static inline void swim_motor(struct swim __iomem *base,
 			swim_select(base, RELAX);
 			if (swim_readbit(base, MOTOR_ON))
 				break;
-			current->state = TASK_INTERRUPTIBLE;
+			__set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(1);
 		}
 	} else if (action == OFF) {
@@ -350,7 +350,7 @@ static inline void swim_eject(struct swim __iomem *base)
 		swim_select(base, RELAX);
 		if (!swim_readbit(base, DISK_IN))
 			break;
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(1);
 	}
 	swim_select(base, RELAX);
@@ -374,7 +374,7 @@ static inline int swim_step(struct swim __iomem *base)
 
 	for (wait = 0; wait < HZ; wait++) {
 
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(1);
 
 		swim_select(base, RELAX);
-- 
2.1.2



