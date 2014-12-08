Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaLHXDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:03:35 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:13375 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbaLHXDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:03:31 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Dec 2014 15:27:35 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: The address of query8 must be calculated based on which query registers are present
Date: Mon, 8 Dec 2014 15:02:00 -0800
Message-ID: <1418079720-11766-2-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418079720-11766-1-git-send-email-aduggan@synaptics.com>
References: <1418079720-11766-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a touchpad does not report relative data then query 6 will not be present and the address
of query 8 will be one less. This patches calculates the location of query 8 instead of
hardcoding the offset.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index b069369..bc38c1e 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -640,17 +640,6 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	has_rel = !!(buf[0] & BIT(3));
 	has_gestures = !!(buf[0] & BIT(5));
 
-	if (has_gestures) {
-		/* query 8 to find out if query 10 exists */
-		ret = rmi_read(hdev, data->f11.query_base_addr + 8, buf);
-		if (ret) {
-			hid_err(hdev, "can not read gesture information: %d.\n",
-				ret);
-			return ret;
-		}
-		has_query10 = !!(buf[0] & BIT(2));
-	}
-
 	/*
 	 * At least 4 queries are guaranteed to be present in F11
 	 * +1 for query 5 which is present since absolute events are
@@ -661,8 +650,19 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	if (has_rel)
 		++query_offset; /* query 6 is present */
 
-	if (has_gestures)
+	if (has_gestures) {
+		/* query 8 to find out if query 10 exists */
+		ret = rmi_read(hdev,
+			data->f11.query_base_addr + query_offset + 1, buf);
+		if (ret) {
+			hid_err(hdev, "can not read gesture information: %d.\n",
+				ret);
+			return ret;
+		}
+		has_query10 = !!(buf[0] & BIT(2));
+
 		query_offset += 2; /* query 7 and 8 are present */
+	}
 
 	if (has_query9)
 		++query_offset;
-- 
2.1.0

