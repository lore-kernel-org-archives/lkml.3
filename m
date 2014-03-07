Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaCGK4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:56:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35610 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaCGK4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:56:30 -0500
From: Vegard Nossum <vegard.nossum@oracle.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] isdnloop: NUL-terminate strings from userspace
Date: Fri,  7 Mar 2014 11:56:04 +0100
Message-Id: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

