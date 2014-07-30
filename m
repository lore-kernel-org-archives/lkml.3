Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaG3MUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36796 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 86/94] Input: fix defuzzing logic
Date: Wed, 30 Jul 2014 14:15:15 +0200
Message-Id: <e4bd405b570f7e5132e4117b07a544fb6e5f6295.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 50c5d36dab930b1f1b1e3348b8608aa8b9ee7610 upstream.

We attempt to remove noise from coordinates reported by devices in
input_handle_abs_event(), unfortunately, unless we were dropping the
event altogether, we were ignoring the adjusted value and were passing
on the original value instead.

Reviewed-by: Andrew de los Reyes <adlr@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/input.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 74f47980117b..fcf77af28866 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -257,9 +257,10 @@ static int input_handle_abs_event(struct input_dev *dev,
 }
 
 static int input_get_disposition(struct input_dev *dev,
-			  unsigned int type, unsigned int code, int value)
+			  unsigned int type, unsigned int code, int *pval)
 {
 	int disposition = INPUT_IGNORE_EVENT;
+	int value = *pval;
 
 	switch (type) {
 
@@ -357,6 +358,7 @@ static int input_get_disposition(struct input_dev *dev,
 		break;
 	}
 
+	*pval = value;
 	return disposition;
 }
 
@@ -365,7 +367,7 @@ static void input_handle_event(struct input_dev *dev,
 {
 	int disposition;
 
-	disposition = input_get_disposition(dev, type, code, value);
+	disposition = input_get_disposition(dev, type, code, &value);
 
 	if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
 		dev->event(dev, type, code, value);
-- 
2.0.1

