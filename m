Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3HBKqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:46:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218Ab3HBKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 57/99] Drivers: hv: balloon: Do not post pressure status if interrupted
Date: Fri,  2 Aug 2013 18:08:10 +0800
Message-Id: <20130802100233.980637755@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit c5e2254f8d63a6654149aa32ac5f2b7dd66a976d upstream.

When we are posting pressure status, we may get interrupted and handle
the un-balloon operation. In this case just don't post the status as we
know the pressure status is stale.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_balloon.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -975,6 +975,14 @@ static void post_status(struct hv_dynmem
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


