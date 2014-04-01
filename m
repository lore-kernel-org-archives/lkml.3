Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaDAKI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:08:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47261 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:08:26 -0400
From: Vegard Nossum <vegard.nossum@oracle.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] isdnloop: NUL-terminate strings from userspace
Date: Tue,  1 Apr 2014 12:08:18 +0200
Message-Id: <1396346898-8950-1-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the in-kernel and BSD strlcpy() require that the source string is
NUL terminated. We could use strncpy() + explicitly terminate the result,
but this relies on src and dest having the same size, so the safest thing
to do seems to explicitly terminate the source string before doing the
strlcpy().

Fixes: f9a23c84486ed35 ("isdnloop: use strlcpy() instead of strcpy()")
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/isdn/isdnloop/isdnloop.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 02125e6..50cd348 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1070,6 +1070,14 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 		return -EBUSY;
 	if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
 		return -EFAULT;
+
+	/*
+	 * Null terminate strings from userspace so we don't have to worry
+	 * about this later on.
+	 */
+	for (i = 0; i < 3; i++)
+		sdef.num[i][sizeof(sdef.num[0]) - 1] = '\0';
+
 	spin_lock_irqsave(&card->isdnloop_lock, flags);
 	switch (sdef.ptype) {
 	case ISDN_PTYPE_EURO:
-- 
1.7.10.4

