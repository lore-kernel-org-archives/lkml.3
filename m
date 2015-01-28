Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbbA1Uzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbbA1Uzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Input - synaptics: do not release extra buttons once they are pressed
Date: Wed, 28 Jan 2015 15:10:05 -0500
Message-Id: <1422475807-15033-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code releases the extra buttons right after they are pressed.
As soon as a new serio report comes in, the hw state is reset to 0
and so the buttons are released.

Check for the report type before acting on the current extra buttons
state.

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/mouse/synaptics.c | 10 +++++++---
 drivers/input/mouse/synaptics.h |  3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 0d12664..d58863b 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -688,7 +688,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
 		}
 
 		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
-		    ((buf[0] ^ buf[3]) & 0x02)) {
+		    SYN_REPORT_EXT_BUTTONS(buf)) {
 			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap)) {
 			default:
 				/*
@@ -792,8 +792,12 @@ static void synaptics_report_buttons(struct psmouse *psmouse,
 		input_report_key(dev, BTN_BACK, hw->down);
 	}
 
-	for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
-		input_report_key(dev, BTN_0 + i, hw->ext_buttons & (1 << i));
+	if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
+	    SYN_REPORT_EXT_BUTTONS(psmouse->packet)) {
+		for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
+			input_report_key(dev, BTN_0 + i,
+					 hw->ext_buttons & (1 << i));
+	}
 }
 
 static void synaptics_report_mt_data(struct psmouse *psmouse,
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 6faf9bb..0b2b711 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -115,6 +115,9 @@
 #define SYN_NEWABS_RELAXED		2
 #define SYN_OLDABS			3
 
+/* synaptics extended button packet */
+#define SYN_REPORT_EXT_BUTTONS(buf)	(((buf)[0] ^ (buf)[3]) & 0x02)
+
 /* amount to fuzz position data when touchpad reports reduced filtering */
 #define SYN_REDUCED_FILTER_FUZZ		8
 
-- 
2.1.0

