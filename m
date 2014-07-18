Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbaGRNI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:08:58 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17414 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761078AbaGRNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:08:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/170] Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set
Date: Fri, 18 Jul 2014 14:10:18 +0200
Message-Id: <98cd9c0a1313779a90bde789e464f75ab6e49800.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fb4f8f568a9def02240ef9bf7aabd246dc63a081 upstream.

The touchpad on the GIGABYTE U2442 not only stops communicating when we try
to set bit 3 (enable real hardware resolution) of reg_10, but on some BIOS
versions also when we set bit 1 (enable two finger mode auto correct).

I've asked the original reporter of:
https://bugzilla.kernel.org/show_bug.cgi?id=61151

To check that not setting bit 1 does not lead to any adverse effects on his
model / BIOS revision, and it does not, so this commit fixes the touchpad
not working on these versions by simply never setting bit 1 for laptop
models with the no_hw_res quirk.

Reported-and-tested-by: James Lademann <jwlademann@gmail.com>
Tested-by: Philipp Wolfer <ph.wolfer@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/elantech.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 360e46b200de..233516aff595 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -849,7 +849,7 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
 		if (etd->set_hw_resolution)
 			etd->reg_10 = 0x0b;
 		else
-			etd->reg_10 = 0x03;
+			etd->reg_10 = 0x01;
 
 		if (elantech_write_reg(psmouse, 0x10, etd->reg_10))
 			rc = -1;
@@ -1350,7 +1350,8 @@ static int elantech_reconnect(struct psmouse *psmouse)
 }
 
 /*
- * Some hw_version 3 models go into error state when we try to set bit 3 of r10
+ * Some hw_version 3 models go into error state when we try to set
+ * bit 3 and/or bit 1 of r10.
  */
 static const struct dmi_system_id no_hw_res_dmi_table[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
-- 
2.0.0

