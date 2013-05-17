Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3EQIoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:44:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56919 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3EQIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:44:16 -0400
Message-ID: <1368780244.2813.14.camel@ThinkPad-T5421>
Subject: [RFC PATCH nohz] return NOTIFY_BAD in cpu down call back to stop
 offlining the cpu
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 17 May 2013 16:44:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051708-0260-0000-0000-00000303F1C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tick_nohz_cpu_down_callback() if the cpu is the one handling
timekeeping , it seems that we should return something that could stop
notify CPU_DOWN_PREPARE, and then start notify CPU_DOWN_FAILED on the
already called notifier call backs.

-EINVAL will be converted to 0 by notifier_to_errno(), then the cpu
would be taken down with part of the DOWN_PREPARE notifier callbacks
called, and something bad could happen after that.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bc67d42..17b8155 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -306,7 +306,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		 * we can't safely shutdown that CPU.
 		 */
 		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
-			return -EINVAL;
+			return NOTIFY_BAD;
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.7.1

