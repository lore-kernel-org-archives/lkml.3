Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161848AbaKNTjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62303 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161540AbaKNTiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:38:54 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/7] input: alps: Set correct name of psmouse device in alps_init()
Date: Fri, 14 Nov 2014 20:38:20 +0100
Message-Id: <1415993906-13307-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some laptops after starting them from off state (not after reboot), function
alps_probe_trackstick_v3() (called from function alps_identify()) does not
detect trackstick. To fix this problem we need to reset device. But function
alps_identify() is called also from alps_detect() and we do not want to reset
device in detect function because it will slow down initialization of all other
non alps devices.

This patch moves code for setting correct device name & protocol from function
alps_detect() to alps_init() which already doing full device reset.

So this patch removes need to do trackstick detection in alps_detect() function.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 8d85c79..9ffa98d 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2392,6 +2392,10 @@ int alps_init(struct psmouse *psmouse)
 	if (input_register_device(priv->dev2))
 		goto init_fail;
 
+	if (!(priv->flags & ALPS_DUALPOINT))
+		psmouse->name = "GlidePoint TouchPad";
+	psmouse->model = priv->proto_version;
+
 	psmouse->protocol_handler = alps_process_byte;
 	psmouse->poll = alps_poll;
 	psmouse->disconnect = alps_disconnect;
@@ -2422,11 +2426,18 @@ int alps_detect(struct psmouse *psmouse, bool set_properties)
 		return -1;
 
 	if (set_properties) {
+		/*
+		 * NOTE: To detect model and trackstick presence we need to do
+		 *       full device reset. To speed up detection and prevent
+		 *       calling duplicate initialization sequence (both in
+		 *       alps_detect() and alps_init()) we set model/protocol
+		 *       version and correct name in alps_init() (which will
+		 *       do full device reset). For now set name to DualPoint.
+		 */
 		psmouse->vendor = "ALPS";
-		psmouse->name = dummy.flags & ALPS_DUALPOINT ?
-				"DualPoint TouchPad" : "GlidePoint";
-		psmouse->model = dummy.proto_version << 8;
+		psmouse->name = "DualPoint TouchPad";
 	}
+
 	return 0;
 }
 
-- 
1.7.9.5

