Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3GLNmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:42:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36091
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964799Ab3GLNmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:42:37 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] Drivers: hv: balloon: Do not post pressure status if interrupted
Date: Fri, 12 Jul 2013 06:56:15 -0700
Message-Id: <1373637375-25936-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373637375-25936-1-git-send-email-kys@microsoft.com>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
 <1373637375-25936-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are posting pressure status, we may get interrupted and handle
the un-balloon operation. In this case just don't post the status as we
know the pressure status is stale.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/hv/hv_balloon.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index bfc7be2..4abaccf 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -972,6 +972,14 @@ static void post_status(struct hv_dynmem_device *dm)
 				dm->num_pages_ballooned +
 				compute_balloon_floor();
 
+	/*
+	 * If our transaction ID is no longer current, just don't
+	 * send the status. This can happen if we were interrupted
+	 * after we picked our transaction ID.
+	 */
+	if (status.hdr.trans_id != atomic_read(&trans_id))
+		return;
+
 	vmbus_sendpacket(dm->dev->channel, &status,
 				sizeof(struct dm_status),
 				(unsigned long)NULL,
-- 
1.7.4.1

