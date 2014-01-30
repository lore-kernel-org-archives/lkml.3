Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaA3MLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:11:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43773 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaA3MKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:10:48 -0500
Date: Thu, 30 Jan 2014 15:10:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] gru: unlocking should be conditional in
 gru_dump_context()
Message-ID: <20140130121044.GB13267@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reviewing this and noticed that unlocking should be conditional on
the error path.  I've changed it to unlock and return directly since we
only do it once and it seems unlikely to change in the near future.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
index 9b2062d17327..2bef3f76032a 100644
--- a/drivers/misc/sgi-gru/grukdump.c
+++ b/drivers/misc/sgi-gru/grukdump.c
@@ -139,8 +139,11 @@ static int gru_dump_context(struct gru_state *gru, int ctxnum,
 
 	ubuf += sizeof(hdr);
 	ubufcch = ubuf;
-	if (gru_user_copy_handle(&ubuf, cch))
-		goto fail;
+	if (gru_user_copy_handle(&ubuf, cch)) {
+		if (cch_locked)
+			unlock_cch_handle(cch);
+		return -EFAULT;
+	}
 	if (cch_locked)
 		ubufcch->delresp = 0;
 	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
@@ -179,10 +182,6 @@ static int gru_dump_context(struct gru_state *gru, int ctxnum,
 		ret = -EFAULT;
 
 	return ret ? ret : bytes;
-
-fail:
-	unlock_cch_handle(cch);
-	return -EFAULT;
 }
 
 int gru_dump_chiplet_request(unsigned long arg)
