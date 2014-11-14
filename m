Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161893AbaKNTlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:41:08 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57526 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaKNTjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:39:01 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/7] input: alps: Move alps_dolphin_get_device_area into alps_hw_init_dolphin_v1
Date: Fri, 14 Nov 2014 20:38:22 +0100
Message-Id: <1415993906-13307-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves function call alps_dolphin_get_device_area() from function
alps_identify() to alps_hw_init_dolphin_v1() so alps_identify() will not call
any other psmouse commands.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index cbfdcfc..5603870 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1991,9 +1991,9 @@ error:
 	return -1;
 }
 
-static int alps_dolphin_get_device_area(struct psmouse *psmouse,
-					struct alps_data *priv)
+static int alps_dolphin_get_device_area(struct psmouse *psmouse)
 {
+	struct alps_data *priv = psmouse->private;
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[4] = {0};
 	int num_x_electrode, num_y_electrode;
@@ -2042,6 +2042,9 @@ static int alps_hw_init_dolphin_v1(struct psmouse *psmouse)
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[2];
 
+	if (alps_dolphin_get_device_area(psmouse))
+		return -EIO;
+
 	/* This is dolphin "v1" as empirically defined by florin9doi */
 	param[0] = 0x64;
 	param[1] = 0x28;
@@ -2223,10 +2226,8 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 		   ec[0] == 0x73 && (ec[1] == 0x01 || ec[1] == 0x02)) {
 		priv->proto_version = ALPS_PROTO_V5;
 		alps_set_defaults(priv);
-		if (alps_dolphin_get_device_area(psmouse, priv))
-			return -EIO;
-		else
-			return 0;
+
+		return 0;
 	} else if (ec[0] == 0x88 &&
 		   ((ec[1] & 0xf0) == 0xb0 || (ec[1] & 0xf0) == 0xc0)) {
 		priv->proto_version = ALPS_PROTO_V7;
-- 
1.7.9.5

