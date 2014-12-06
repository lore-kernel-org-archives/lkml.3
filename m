Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaLFPIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:08:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47649 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752097AbaLFPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/66] Input: synaptics - fix resolution for manually provided min/max
Date: Sat,  6 Dec 2014 16:06:59 +0100
Message-Id: <6608dfb5328a3769e9aea98a5a1d9c5435b7104c.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d49cb7aeebb974713f9f7ab2991352d3050b095b upstream.

commit 421e08c41fda fixed the reported min/max for the X and Y axis,
but unfortunately, it broke the resolution of those same axis.

On the t540p, the resolution is the same regarding X and Y. It is not
a problem for xf86-input-synaptics because this driver is only interested
in the ratio between X and Y.
Unfortunately, xf86-input-cmt uses directly the resolution, and having a
null resolution leads to some divide by 0 errors, which are translated by
-infinity in the resulting coordinates.

Reported-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 87ec0f49ae98..d4d46d2bbe5d 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -347,15 +347,6 @@ static int synaptics_resolution(struct psmouse *psmouse)
 	unsigned char resp[3];
 	int i;
 
-	for (i = 0; min_max_pnpid_table[i].pnp_ids; i++)
-		if (matches_pnp_id(psmouse, min_max_pnpid_table[i].pnp_ids)) {
-			priv->x_min = min_max_pnpid_table[i].x_min;
-			priv->x_max = min_max_pnpid_table[i].x_max;
-			priv->y_min = min_max_pnpid_table[i].y_min;
-			priv->y_max = min_max_pnpid_table[i].y_max;
-			return 0;
-		}
-
 	if (SYN_ID_MAJOR(priv->identity) < 4)
 		return 0;
 
@@ -366,6 +357,16 @@ static int synaptics_resolution(struct psmouse *psmouse)
 		}
 	}
 
+	for (i = 0; min_max_pnpid_table[i].pnp_ids; i++) {
+		if (matches_pnp_id(psmouse, min_max_pnpid_table[i].pnp_ids)) {
+			priv->x_min = min_max_pnpid_table[i].x_min;
+			priv->x_max = min_max_pnpid_table[i].x_max;
+			priv->y_min = min_max_pnpid_table[i].y_min;
+			priv->y_max = min_max_pnpid_table[i].y_max;
+			return 0;
+		}
+	}
+
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 5 &&
 	    SYN_CAP_MAX_DIMENSIONS(priv->ext_cap_0c)) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_MAX_COORDS, resp)) {
-- 
2.1.3

