Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaEYSOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:14:20 -0400
Received: from mout.gmx.net ([212.227.17.20]:63299 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaEYSOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:14:19 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: sivanich@sgi.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] sgi-gru: use time_before()
Date: Sun, 25 May 2014 20:14:13 +0200
Message-Id: <1401041653-20847-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:0T+ro/dXSyaff4EhmVOgZBNuYeCUhgf4zJurHVHKH5vHesj7hgV
 Sghx1umQ5yhMoIvYjJrJwO3nevM4tJZOeD7qfcDjJdshKYKPqGThYXSTYOH1fgM+zKfcVft
 XdCYv2n3V9izTqCa8r3JfwUuduhqLEsnVSy+8aUXxwfTzN6xjPeIuwUuW74gzrHwqJgwJ9p
 nnUdWQyGJSTqq5HWp28RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/misc/sgi-gru/grumain.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index ae16c8c..1525870 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -930,6 +930,7 @@ int gru_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct gru_thread_state *gts;
 	unsigned long paddr, vaddr;
+	unsigned long expires;
 
 	vaddr = (unsigned long)vmf->virtual_address;
 	gru_dbg(grudev, "vma %p, vaddr 0x%lx (0x%lx)\n",
@@ -954,7 +955,8 @@ again:
 			mutex_unlock(&gts->ts_ctxlock);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
-			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
+			expires = gts->ts_steal_jiffies + GRU_STEAL_DELAY;
+			if (time_before(expires, jiffies))
 				gru_steal_context(gts);
 			goto again;
 		}
-- 
1.7.10.4

