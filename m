Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab3DGUnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 16:43:00 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:41119 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934228Ab3DGUm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 16:42:59 -0400
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Apr 2013 16:42:59 EDT
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApTnAFzKYVFV5qjOPGdsb2JhbABRgwUBAYJ2hSOySIZzBAGBABcDAQEBATg1gk0vEwEPGIECChoTiBi9ORWNSieBHYNIA50GjCuBXjqBLg
X-Suspected-Spam: Yes
X-IronPort-AV: E=Sophos;i="4.87,426,1363129200"; 
   d="scan'208";a="231849031"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: MT - handle semi-mt devices in core
Date: Sun,  7 Apr 2013 21:41:32 +0200
Message-Id: <1365363692-986-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most semi-mt drivers use the slots in a manual way, but really only
need to treat the finger count manually. With this patch, a semi-mt
driver may use the input-mt core for everything else.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

an earlier version of this patch came about as a test to handle the
synaptics profile sensor without too much extra work. I do not know
how that test panned out (no response), but this patch will likely be
useful regardless.

Henrik

 drivers/input/input-mt.c | 8 +++++++-
 include/linux/input/mt.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 71db193..d398f13 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -79,6 +79,8 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 	}
 	if (flags & INPUT_MT_DIRECT)
 		__set_bit(INPUT_PROP_DIRECT, dev->propbit);
+	if (flags & INPUT_MT_SEMI_MT)
+		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
 	if (flags & INPUT_MT_TRACK) {
 		unsigned int n2 = num_slots * num_slots;
 		mt->red = kcalloc(n2, sizeof(*mt->red), GFP_KERNEL);
@@ -246,6 +248,7 @@ void input_mt_sync_frame(struct input_dev *dev)
 {
 	struct input_mt *mt = dev->mt;
 	struct input_mt_slot *s;
+	bool use_count = false;
 
 	if (!mt)
 		return;
@@ -259,7 +262,10 @@ void input_mt_sync_frame(struct input_dev *dev)
 		}
 	}
 
-	input_mt_report_pointer_emulation(dev, (mt->flags & INPUT_MT_POINTER));
+	if ((mt->flags & INPUT_MT_POINTER) && !(mt->flags & INPUT_MT_SEMI_MT))
+		use_count = true;
+
+	input_mt_report_pointer_emulation(dev, use_count);
 
 	mt->frame++;
 }
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 2e86bd0..1b1dfa8 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -19,6 +19,7 @@
 #define INPUT_MT_DIRECT		0x0002	/* direct device, e.g. touchscreen */
 #define INPUT_MT_DROP_UNUSED	0x0004	/* drop contacts not seen in frame */
 #define INPUT_MT_TRACK		0x0008	/* use in-kernel tracking */
+#define INPUT_MT_SEMI_MT	0x0010	/* semi-mt device, finger count handled manually */
 
 /**
  * struct input_mt_slot - represents the state of an input MT slot
-- 
1.8.2

