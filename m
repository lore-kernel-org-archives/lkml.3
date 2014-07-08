Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaGHTPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54274 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755769AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Hutterer" <peter.hutterer@who-t.net>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.612380283@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 069/125] Input: synaptics - fix resolution for
 manually provided min/max
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[bwh: Backported to 3.2: I didn't apply the PNP ID changes, so the
 code being moved looks different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -245,14 +245,6 @@ static int synaptics_resolution(struct p
 	struct synaptics_data *priv = psmouse->private;
 	unsigned char resp[3];
 
-	if (quirk_min_max) {
-		priv->x_min = quirk_min_max[0];
-		priv->x_max = quirk_min_max[1];
-		priv->y_min = quirk_min_max[2];
-		priv->y_max = quirk_min_max[3];
-		return 0;
-	}
-
 	if (SYN_ID_MAJOR(priv->identity) < 4)
 		return 0;
 
@@ -263,6 +255,14 @@ static int synaptics_resolution(struct p
 		}
 	}
 
+	if (quirk_min_max) {
+		priv->x_min = quirk_min_max[0];
+		priv->x_max = quirk_min_max[1];
+		priv->y_min = quirk_min_max[2];
+		priv->y_max = quirk_min_max[3];
+		return 0;
+	}
+
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 5 &&
 	    SYN_CAP_MAX_DIMENSIONS(priv->ext_cap_0c)) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_MAX_COORDS, resp)) {

