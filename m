Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaGSXtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:49:20 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43175 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGSXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:49:18 -0400
Date: Sat, 19 Jul 2014 16:49:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, David Herrmann <dh.herrmann@gmail.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: fix defuzzing logic
Message-ID: <20140719234843.GA28580@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We attempt to remove noise from coordinates reported by devices in
input_handle_abs_event(), unfortunately, unless we were dropping the
event altogether, we were ignoring the adjusted value and were passing
on the original value instead.

Reviewed-by: Andrew de los Reyes <adlr@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1c4c0db..29ca0bb 100644
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
Dmitry
