Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaGGWeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:34:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:39462
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaGGWeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:34:10 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
Date: Mon,  7 Jul 2014 16:34:24 -0700
Message-Id: <1404776065-8685-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404776037-8644-1-git-send-email-kys@microsoft.com>
References: <1404776037-8644-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with Win8, we have implemented several optimizations to improve the
scalability and performance of the VMBUS transport between the Host and the
Guest. Some of the non-performance critical services cannot leverage these
optimization since they only read and process one message at a time.
Make adjustments to the callback dispatch code to account for the way
non-performance critical drivers handle reading of the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/connection.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index e84f452..ae22e3c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -339,9 +339,13 @@ static void process_chn_event(u32 relid)
 		 */
 
 		do {
-			hv_begin_read(&channel->inbound);
+			if (read_state)
+				hv_begin_read(&channel->inbound);
 			channel->onchannel_callback(arg);
-			bytes_to_read = hv_end_read(&channel->inbound);
+			if (read_state)
+				bytes_to_read = hv_end_read(&channel->inbound);
+			else
+				bytes_to_read = 0;
 		} while (read_state && (bytes_to_read != 0));
 	} else {
 		pr_err("no channel callback for relid - %u\n", relid);
-- 
1.7.4.1

