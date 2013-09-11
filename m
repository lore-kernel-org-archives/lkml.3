Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3IKRFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:05:34 -0400
Received: from hurricane.the-brannons.com ([64.62.188.119]:40243 "EHLO
	hurricane.the-brannons.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062Ab3IKRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:05:32 -0400
From: Christopher Brannon <chris@the-brannons.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, w.d.hubbs@gmail.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, dan.carpenter@oracle.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, raphael.scarv@gmail.com
Subject: [PATCH] staging: speakup: kobjects.c: Use correct values when changing voice.
Date: Wed, 11 Sep 2013 10:05:27 -0700
Message-Id: <1378919127-28259-1-git-send-email-chris@the-brannons.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new voice is selected, we set volume and pitch appropriate for
the voice.  We need to use the numeric index corresponding to the
voice when indexing into the volume and pitch tables, rather than
the raw user input that was used to select the voice.
Note that using the raw input can also lead to an invalid memory read
in the case of invalid or malicious user input.

Signed-off-by: Christopher Brannon <chris@the-brannons.com>
---
 drivers/staging/speakup/kobjects.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index 61a3f7a..f31afa2 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -651,7 +651,10 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 		* If voice was just changed, we might need to reset our default
 		* pitch and volume.
 		*/
-		if (param->var_id == VOICE) {
+		if (param->var_id == VOICE && synth &&
+		    (ret == 0 || ret == -ERESTART)) {
+			var_data = param->data;
+			value = var_data->u.n.value;
 			spk_reset_default_value("pitch", synth->default_pitch,
 				value);
 			spk_reset_default_value("vol", synth->default_vol,
-- 
1.8.1.5

