Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbaGDXIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:08:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366AbaGDWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.15 05/66] Input: synaptics - fix resolution for manually provided min/max
Date: Fri,  4 Jul 2014 15:14:04 -0700
Message-Id: <20140704221423.059319019@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -347,15 +347,6 @@ static int synaptics_resolution(struct p
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
 
@@ -366,6 +357,16 @@ static int synaptics_resolution(struct p
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


