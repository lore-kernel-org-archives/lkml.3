Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbaHHWZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:25:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbaHHUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 166/259] Input: fix defuzzing logic
Date: Fri,  8 Aug 2014 13:39:49 -0700
Message-Id: <1407530482-4483-167-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@chromium.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/input.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d2965e4..960b389 100644
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
1.9.1

