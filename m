Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880AbaGCJyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:54:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047AbaGCJXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/198] Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set
Date: Thu,  3 Jul 2014 10:19:10 +0100
Message-Id: <1404379241-8590-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/elantech.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 1f011270846a..899e89bd243d 100644
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
1.9.1

