Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BAI2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:28:52 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60844 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BAI2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:28:51 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chung-Yih Wang <cywang@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] Input: synaptics - disable fuzz when using mt slots
Date: Fri,  1 Feb 2013 16:28:32 +0800
Message-Id: <1359707312-12986-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The input fuzz algorithm does a pretty good job filtering out small
jitter on input samples.

However, there is a subtle problem when fuzz is used with mt drivers that
also use input_mt_report_pointer_emulation() to report legacy single
touch coordinates.  The reported single touch coordinates are taken from
the active MT slot with smallest tracking id.  However, since the MT data
is sent first, it has already had FUZZ applied.  Thus, the ST coordinates
actually get FUZZ applied a second time, with the just-fuzzed MT value as
the 'old value'.

It appears that it is non-trivial to fix this in the mt layer/input core,
so, for now, just disable fuzz for the synaptics IMAGE_SENSOR path that
uses input_mt_report_pointer_emulation().

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 12d12ca..b6c6838 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1211,7 +1211,8 @@ static void set_abs_position_params(struct input_dev *dev,
 	int x_max = priv->x_max ?: XMAX_NOMINAL;
 	int y_min = priv->y_min ?: YMIN_NOMINAL;
 	int y_max = priv->y_max ?: YMAX_NOMINAL;
-	int fuzz = SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) ?
+	int fuzz = (SYN_CAP_REDUCED_FILTERING(priv->ext_cap_0c) &&
+			!SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) ?
 			SYN_REDUCED_FILTER_FUZZ : 0;
 
 	input_set_abs_params(dev, x_code, x_min, x_max, fuzz, 0);
-- 
1.8.1

