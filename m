Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbbAIDtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:49:20 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45364 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbbAIDtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:49:19 -0500
From: Gigi Joseph <gigi.joseph@gmail.com>
X-Google-Original-From: Gigi Joseph <gigi.joseph@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Cc: Gigi Joseph <gigi.joseph@ti.com>, Amir Ayun <amira@ti.com>,
        Pavan Savoy <pavan_savoy@ti.com>, Leonid Iziumtsev <x0153368@ti.com>
Subject: [PATCH 6/6] drivers:misc:ti-st: protect against bad packets
Date: Fri,  9 Jan 2015 03:49:03 +0000
Message-Id: <1420775343-24867-1-git-send-email-gigi.joseph@ti.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We encounter situations where we got bad packet type from the
UART (probably due to platform problem or UART driver issues)
which caused us out of boundary array access,
which eventually led to kernel panic.

Signed-off-by: Amir Ayun <amira@ti.com>
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Leonid Iziumtsev <x0153368@ti.com>
Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
---
 drivers/misc/ti-st/st_core.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 54be83d..c8c6a36 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -343,12 +343,26 @@ void st_int_recv(void *disc_data,
 			/* Unknow packet? */
 		default:
 			type = *ptr;
-			if (st_gdata->list[type] == NULL) {
-				pr_err("chip/interface misbehavior dropping"
-					" frame starting with 0x%02x", type);
-				goto done;
 
+			/* Default case means non-HCILL packets,
+			 * possibilities are packets for:
+			 * (a) valid protocol -  Supported Protocols within
+			 *     the ST_MAX_CHANNELS.
+			 * (b) registered protocol - Checked by
+			 *     "st_gdata->list[type] == NULL)" are supported
+			 *     protocols only.
+			 *  Rules out any invalid protocol and
+			 *  unregistered protocols with channel ID < 16.
+			 */
+
+			if ((type >= ST_MAX_CHANNELS) ||
+					(st_gdata->list[type] == NULL)) {
+				pr_err("chip/interface misbehavior: "
+						"dropping frame starting "
+						"with 0x%02x\n", type);
+				goto done;
 			}
+
 			st_gdata->rx_skb = alloc_skb(
 					st_gdata->list[type]->max_frame_size,
 					GFP_ATOMIC);
@@ -893,5 +907,3 @@ void st_core_exit(struct st_data_s *st_gdata)
 		kfree(st_gdata);
 	}
 }
-
-
-- 
1.9.1

