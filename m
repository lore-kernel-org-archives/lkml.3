Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaH1NOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:36 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45762 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaH1NOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, gregkh@linuxfoundation.org
Subject: [PATCH 02/11] misc: st_core: Protect unsigned value against becoming negative
Date: Thu, 28 Aug 2014 14:14:08 +0100
Message-Id: <1409231657-18294-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity reported:
  This less-than-zero comparison of an unsigned value is never true.

In answer to that, we only ever decrement if protos_registered is
positive.  We can subsequently remove the paranoid checking during
unregister.

Cc: gregkh@linuxfoundation.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/misc/ti-st/st_core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 1972d57a..54be83d 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -153,8 +153,9 @@ static void st_reg_complete(struct st_data_s *st_gdata, char err)
 				(st_gdata->list[i]->priv_data, err);
 			pr_info("protocol %d's cb sent %d\n", i, err);
 			if (err) { /* cleanup registered protocol */
-				st_gdata->protos_registered--;
 				st_gdata->is_registered[i] = false;
+				if (st_gdata->protos_registered)
+					st_gdata->protos_registered--;
 			}
 		}
 	}
@@ -639,14 +640,12 @@ long st_unregister(struct st_proto_s *proto)
 		return -EPROTONOSUPPORT;
 	}
 
-	st_gdata->protos_registered--;
+	if (st_gdata->protos_registered)
+		st_gdata->protos_registered--;
+
 	remove_channel_from_table(st_gdata, proto);
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 
-	/* paranoid check */
-	if (st_gdata->protos_registered < ST_EMPTY)
-		st_gdata->protos_registered = ST_EMPTY;
-
 	if ((st_gdata->protos_registered == ST_EMPTY) &&
 	    (!test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 		pr_info(" all chnl_ids unregistered ");
-- 
1.9.1

