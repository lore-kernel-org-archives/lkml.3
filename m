Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbaGRNHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:07:44 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17162 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756335AbaGRNCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:31 -0400
X-Greylist: delayed 2999 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 09:02:29 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 153/170] Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
Date: Fri, 18 Jul 2014 14:12:38 +0200
Message-Id: <0225be24ef90930873768cd368b5a8b5697a12f6.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit affb1aff300ddee54df307812b38f166e8a865ef upstream.

Starting with Win8, we have implemented several optimizations to improve the
scalability and performance of the VMBUS transport between the Host and the
Guest. Some of the non-performance critical services cannot leverage these
optimization since they only read and process one message at a time.
Make adjustments to the callback dispatch code to account for the way
non-performance critical drivers handle reading of the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hv/connection.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8dd98d4fc124..59ef4e7afdd7 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -320,9 +320,13 @@ static void process_chn_event(u32 relid)
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
2.0.0

