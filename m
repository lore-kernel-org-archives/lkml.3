Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaHGVCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:02:11 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:10160 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbaHGVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:00:58 -0400
X-IronPort-AV: E=Sophos;i="5.01,820,1400018400"; 
   d="scan'208";a="88647123"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] gdrom: fix error return code
Date: Thu,  7 Aug 2014 22:57:44 +0200
Message-Id: <1407445067-4044-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/cdrom/gdrom.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc31..46ecd95 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -807,16 +807,20 @@ static int probe_gdrom(struct platform_device *devptr)
 	if (err)
 		goto probe_fail_cmdirq_register;
 	gd.gdrom_rq = blk_init_queue(gdrom_request, &gdrom_lock);
-	if (!gd.gdrom_rq)
+	if (!gd.gdrom_rq) {
+		err = -ENOMEM;
 		goto probe_fail_requestq;
+	}
 
 	err = probe_gdrom_setupqueue();
 	if (err)
 		goto probe_fail_toc;
 
 	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
-	if (!gd.toc)
+	if (!gd.toc) {
+		err = -ENOMEM;
 		goto probe_fail_toc;
+	}
 	add_disk(gd.disk);
 	return 0;
 

