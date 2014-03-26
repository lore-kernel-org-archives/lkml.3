Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaCZGVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:21:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCZGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:21:43 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: scameron@beardog.cce.hp.com, JBottomley@paralles.com
Cc: iss_storagedev@hp.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] [SCSI] hpsa: use trans_support after value assigned
Date: Wed, 26 Mar 2014 15:24:02 +0900
Message-Id: <1395815042-26917-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because trans_support be used when check i/o accelerator mode support
before its value assigned, it caused following build warning:

drivers/scsi/hpsa.c: In function ‘hpsa_init_one’:
drivers/scsi/hpsa.c:7468:20: warning: ‘trans_support’
may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (trans_support & CFGTBL_Trans_io_accel1) {
                    ^
drivers/scsi/hpsa.c:7459:6: note: ‘trans_support’ was
declared here
  u32 trans_support;
      ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..a4ae873 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7455,7 +7455,7 @@ clean_up:
 
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
-	u32 trans_support;
+	u32 trans_support = readl(&(h->cfgtable->TransportSupport));
 	unsigned long transMethod = CFGTBL_Trans_Performant |
 					CFGTBL_Trans_use_short_tags;
 	int i;
@@ -7479,7 +7479,6 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
-	trans_support = readl(&(h->cfgtable->TransportSupport));
 	if (!(trans_support & PERFORMANT_MODE))
 		return;
 
-- 
1.8.3.2

