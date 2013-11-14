Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3KNQt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:49:26 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50123 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab3KNQoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:05 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 09/26] staging/lustre/llite: error setting max_cache_mb at mount time
Date: Fri, 15 Nov 2013 00:42:56 +0800
Message-Id: <1384447393-13838-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

The root cause is that when max_cache_mb conf parameter is applied,
the client isn't connected to the OST yet so that sbi->ll_dt_exp is
NULL. However, it's not necessary to shrink the cache memory in this
case so success should be returned.

Lustre-change: http://review.whamcloud.com/7194
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3676
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/lproc_llite.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 18a5998c..17d3911 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -393,8 +393,8 @@ static ssize_t ll_max_cached_mb_seq_write(struct file *file, const char *buffer,
 		return -ERANGE;
 	}
 
-	if (sbi->ll_dt_exp == NULL)
-		return -ENODEV;
+	if (sbi->ll_dt_exp == NULL) /* being initialized */
+		GOTO(out, rc = 0);
 
 	spin_lock(&sbi->ll_lock);
 	diff = pages_number - cache->ccc_lru_max;
-- 
1.7.9.5

