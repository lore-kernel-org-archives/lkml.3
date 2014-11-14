Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161877AbaKNTkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:40:39 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57320 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161834AbaKNTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:39:05 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 4/7] input: alps: Use NULL instead dummy argument for alps_identify
Date: Fri, 14 Nov 2014 20:38:23 +0100
Message-Id: <1415993906-13307-5-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change alps_identify() function code so it can be called also without
priv parameter which is useful for alps_detect(). Instead passing dummy value
now alps_identify() accept also NULL value and skip filling priv data. It is
useless for alps_detect() and it will speed up detection of alps devices.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |  114 +++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 43 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 5603870..0176425 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2162,8 +2162,7 @@ static void alps_set_defaults(struct alps_data *priv)
 	}
 }
 
-static int alps_match_table(struct psmouse *psmouse, struct alps_data *priv,
-			    unsigned char *e7, unsigned char *ec)
+static const struct alps_model_info *alps_match_table(unsigned char *e7, unsigned char *ec)
 {
 	const struct alps_model_info *model;
 	int i;
@@ -2174,24 +2173,49 @@ static int alps_match_table(struct psmouse *psmouse, struct alps_data *priv,
 		if (!memcmp(e7, model->signature, sizeof(model->signature)) &&
 		    (!model->command_mode_resp ||
 		     model->command_mode_resp == ec[2])) {
+			return model;
+		}
+	}
 
-			priv->proto_version = model->proto_version;
-			alps_set_defaults(priv);
+	return NULL;
+}
 
-			priv->flags = model->flags;
-			priv->byte0 = model->byte0;
-			priv->mask0 = model->mask0;
+static inline bool alps_match_v5(unsigned char *e7, unsigned char *ec)
+{
+	return (e7[0] == 0x73 && e7[1] == 0x03 && e7[2] == 0x50 &&
+		ec[0] == 0x73 && (ec[1] == 0x01 || ec[1] == 0x02));
+}
 
-			return 0;
-		}
-	}
+static inline bool alps_match_v7(unsigned char *e7, unsigned char *ec)
+{
+	return (ec[0] == 0x88 &&
+		((ec[1] & 0xf0) == 0xb0 || (ec[1] & 0xf0) == 0xc0));
+}
 
-	return -EINVAL;
+static inline bool alps_match_rushmore_v3(unsigned char *e7, unsigned char *ec)
+{
+	return (ec[0] == 0x88 && ec[1] == 0x08);
+}
+
+static inline bool alps_match_v3(unsigned char *e7, unsigned char *ec)
+{
+	return (ec[0] == 0x88 && ec[1] == 0x07 &&
+		ec[2] >= 0x90 && ec[2] <= 0x9d);
+}
+
+static inline bool alps_match_any(unsigned char *e7, unsigned char *ec)
+{
+	return (alps_match_table(e7, ec) ||
+		alps_match_v5(e7, ec) ||
+		alps_match_v7(e7, ec) ||
+		alps_match_rushmore_v3(e7, ec) ||
+		alps_match_v3(e7, ec));
 }
 
 static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 {
 	unsigned char e6[4], e7[4], ec[4];
+	const struct alps_model_info *model;
 
 	/*
 	 * First try "E6 report".
@@ -2217,40 +2241,46 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 	    alps_exit_command_mode(psmouse))
 		return -EIO;
 
-	/* Save the Firmware version */
-	memcpy(priv->fw_ver, ec, 3);
+	if (priv) {
 
-	if (alps_match_table(psmouse, priv, e7, ec) == 0) {
-		return 0;
-	} else if (e7[0] == 0x73 && e7[1] == 0x03 && e7[2] == 0x50 &&
-		   ec[0] == 0x73 && (ec[1] == 0x01 || ec[1] == 0x02)) {
-		priv->proto_version = ALPS_PROTO_V5;
-		alps_set_defaults(priv);
+		/* Save the Firmware version */
+		memcpy(priv->fw_ver, ec, 3);
 
-		return 0;
-	} else if (ec[0] == 0x88 &&
-		   ((ec[1] & 0xf0) == 0xb0 || (ec[1] & 0xf0) == 0xc0)) {
-		priv->proto_version = ALPS_PROTO_V7;
-		alps_set_defaults(priv);
-
-		return 0;
-	} else if (ec[0] == 0x88 && ec[1] == 0x08) {
-		priv->proto_version = ALPS_PROTO_V3;
-		alps_set_defaults(priv);
+		if ((model = alps_match_table(e7, ec))) {
+			priv->proto_version = model->proto_version;
+			alps_set_defaults(priv);
+			priv->flags = model->flags;
+			priv->byte0 = model->byte0;
+			priv->mask0 = model->mask0;
+			return 0;
+		} else if (alps_match_v5(e7, ec)) {
+			priv->proto_version = ALPS_PROTO_V5;
+			alps_set_defaults(priv);
+			return 0;
+		} else if (alps_match_v7(e7, ec)) {
+			priv->proto_version = ALPS_PROTO_V7;
+			alps_set_defaults(priv);
+			return 0;
+		} else if (alps_match_rushmore_v3(e7, ec)) {
+			priv->proto_version = ALPS_PROTO_V3;
+			alps_set_defaults(priv);
+			priv->hw_init = alps_hw_init_rushmore_v3;
+			priv->decode_fields = alps_decode_rushmore;
+			priv->x_bits = 16;
+			priv->y_bits = 12;
+			priv->flags |= ALPS_IS_RUSHMORE;
+			return 0;
+		} else if (alps_match_v3(e7, ec)) {
+			priv->proto_version = ALPS_PROTO_V3;
+			alps_set_defaults(priv);
+			return 0;
+		}
 
-		priv->hw_init = alps_hw_init_rushmore_v3;
-		priv->decode_fields = alps_decode_rushmore;
-		priv->x_bits = 16;
-		priv->y_bits = 12;
-		priv->flags |= ALPS_IS_RUSHMORE;
+	} else {
 
-		return 0;
-	} else if (ec[0] == 0x88 && ec[1] == 0x07 &&
-		   ec[2] >= 0x90 && ec[2] <= 0x9d) {
-		priv->proto_version = ALPS_PROTO_V3;
-		alps_set_defaults(priv);
+		if (alps_match_any(e7, ec))
+			return 0;
 
-		return 0;
 	}
 
 	psmouse_dbg(psmouse,
@@ -2427,9 +2457,7 @@ init_fail:
 
 int alps_detect(struct psmouse *psmouse, bool set_properties)
 {
-	struct alps_data dummy;
-
-	if (alps_identify(psmouse, &dummy) < 0)
+	if (alps_identify(psmouse, NULL) < 0)
 		return -1;
 
 	if (set_properties) {
-- 
1.7.9.5

