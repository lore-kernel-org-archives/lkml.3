Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3FERxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:53:16 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:21169 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756957Ab3FERxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:53:06 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 53/53] Input: atmel_mxt_ts - Only use first T9 instance
Date: Wed,  5 Jun 2013 18:37:46 +0100
Message-Id: <1370453866-16534-54-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver only registers one input device, which uses the screen parameters
from the first T9 instance. The first T63 instance also uses those parameters.

It is incorrect to send input reports from the second instances of these
objects if they are enabled: the input scaling will be wrong and the positions
will be mashed together.

This also causes problems on Android if the number of slots exceeds 32.

In the future, this could be handled by looking for enabled touch object
instances and creating an input device for each one.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 0474cb9..5dfdbbb 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1774,10 +1774,11 @@ static int mxt_parse_object_table(struct mxt_data *data)
 			data->T7_address = object->start_address;
 			break;
 		case MXT_TOUCH_MULTI_T9:
+			/* Only handle messages from first T9 instance */
 			data->T9_reportid_min = min_id;
-			data->T9_reportid_max = max_id;
-			data->num_touchids = object->num_report_ids
-						* mxt_obj_instances(object);
+			data->T9_reportid_max = min_id +
+						object->num_report_ids - 1;
+			data->num_touchids = object->num_report_ids;
 			break;
 		case MXT_TOUCH_KEYARRAY_T15:
 			data->T15_reportid_min = min_id;
@@ -1800,10 +1801,10 @@ static int mxt_parse_object_table(struct mxt_data *data)
 			data->T48_reportid = min_id;
 			break;
 		case MXT_PROCI_ACTIVE_STYLUS_T63:
+			/* Only handle messages from first T63 instance */
 			data->T63_reportid_min = min_id;
-			data->T63_reportid_max = max_id;
-			data->num_stylusids = object->num_report_ids
-						* mxt_obj_instances(object);
+			data->T63_reportid_max = min_id;
+			data->num_stylusids = 1;
 			break;
 		case MXT_TOUCH_MULTITOUCHSCREEN_T100:
 			data->T100_reportid_min = min_id;
-- 
1.7.10.4

