Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbaE3NlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:41:10 -0400
Received: from mout.gmx.net ([212.227.17.22]:63344 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaE3NlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:41:08 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: sivanich@sgi.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH RESEND] sgi-gru: use time_before()
Date: Fri, 30 May 2014 15:40:59 +0200
Message-Id: <1401457259-17401-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:iAWew8TPcdonfXxdUPs7jrePw4timjyw3Y8zdHxKRiGpVphGIdo
 6b0PerOztk1psWk2Tdn6x3rvE5p5umnyKB8ld71ax3Fd9sRj2K+QHOhe144g6LyQy+EEh6J
 lLRLMvPjtmUAODES+4xfiyAtYC6L8UJXti8KNa9IZuLEMNWlO6MA438fHNMxwvPFVLUDh5D
 6g7kcVXBCj7EtgHWfDLig==
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

