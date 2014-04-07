Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaDGFWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:22:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaDGFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:22:02 -0400
From: "Dolev Raviv" <draviv@codeaurora.org>
To: "'Tanya Brokhman'" <tlinder@codeaurora.org>, <dedekind1@gmail.com>
Cc: <linux-mtd@lists.infradead.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
Subject: RE: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
Date: Mon, 7 Apr 2014 08:21:58 +0300
Message-ID: <001701cf5221$4e056ad0$ea104070$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQL15YNOzqULd1f36Bp/dPePYasur5i4d44Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Dolev Raviv <draviv@codeaurora.org>

Thanks,
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


-----Original Message-----
From: linux-mtd [mailto:linux-mtd-bounces@lists.infradead.org] On Behalf Of
Tanya Brokhman
Sent: Tuesday, April 01, 2014 11:02 AM
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org; open list; Tanya Brokhman
Subject: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap

At first mount it's possible that there are not enough free PEBs since there
are PEB's pending to be erased. In such scenario, fm_pool (which is the pool
from which user required PEBs are allocated) will be empty.
Try fixing the above described situation by synchronously performing pending
erase work, thus produce another free PEB.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c index
457ead3..9a36f78 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -595,10 +595,29 @@ static void refill_wl_pool(struct ubi_device *ubi)
static void refill_wl_user_pool(struct ubi_device *ubi)  {
 	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	int err;
 
 	return_unused_pool_pebs(ubi, pool);
 
 	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
+retry:
+		if (!ubi->free.rb_node ||
+		   (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
+			/*
+			 * There are no available PEBs. Try to free
+			 * PEB by means of synchronous execution of
+			 * pending works.
+			 */
+			if (ubi->works_count == 0)
+				break;
+			spin_unlock(&ubi->wl_lock);
+			err = do_work(ubi);
+			spin_lock(&ubi->wl_lock);
+			if (err < 0)
+				break;
+			goto retry;
+		}
+
 		pool->pebs[pool->size] = __wl_get_peb(ubi);
 		if (pool->pebs[pool->size] < 0)
 			break;
--
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

