Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967804Ab3DRQ7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:59:52 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41421 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967753Ab3DRQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:59:25 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: sameo@linux.intel.com
Cc: mchehab@redhat.com, andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 12/12] radio-si476x: Fix incorrect pointer checking
Date: Thu, 18 Apr 2013 09:58:38 -0700
Message-Id: <1366304318-29620-13-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect pointer checking and make some minor code improvements:

* Remove unnecessary elements from function pointer table(vtable),
  that includes all the elements that are FM-only, this allows for not
  checking of the fucntion pointer and calling of the function
  directly(THe check if the tuner is in FM mode has to be done anyway)

* Fix incorrect function pointer checking where the code would check one
  pointer to be non-NULL, but would use other pointer, which would not
  be checked.

* Remove code duplication in "si476x_radio_read_rsq_blob" and
  "si476x_radio_read_rsq_primary_blob".

* Add some BUG_ON statements for function pointers that should never be NULL

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/radio/radio-si476x.c |   90 +++++++++++++-----------------------
 1 file changed, 33 insertions(+), 57 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9430c6a..378c7f0 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -270,8 +270,6 @@ struct si476x_radio;
  * @seek_start: Star station seeking
  * @rsq_status: Get Recieved Signal Quality(RSQ) status
  * @rds_blckcnt: Get recived RDS blocks count
- * @phase_diversity: Change phase diversity mode of the tuner
- * @phase_div_status: Get phase diversity mode status
  * @acf_status: Get the status of Automatically Controlled
  * Features(ACF)
  * @agc_status: Get Automatic Gain Control(AGC) status
@@ -281,16 +279,8 @@ struct si476x_radio_ops {
 	int (*seek_start)(struct si476x_core *, bool, bool);
 	int (*rsq_status)(struct si476x_core *, struct si476x_rsq_status_args *,
 			  struct si476x_rsq_status_report *);
-	int (*rds_blckcnt)(struct si476x_core *, bool,
-			   struct si476x_rds_blockcount_report *);
-
-	int (*phase_diversity)(struct si476x_core *,
-			       enum si476x_phase_diversity_mode);
-	int (*phase_div_status)(struct si476x_core *);
 	int (*acf_status)(struct si476x_core *,
 			  struct si476x_acf_status_report *);
-	int (*agc_status)(struct si476x_core *,
-			  struct si476x_agc_status_report *);
 };
 
 /**
@@ -495,22 +485,14 @@ static int si476x_radio_init_vtable(struct si476x_radio *radio,
 		.tune_freq		= si476x_core_cmd_fm_tune_freq,
 		.seek_start		= si476x_core_cmd_fm_seek_start,
 		.rsq_status		= si476x_core_cmd_fm_rsq_status,
-		.rds_blckcnt		= si476x_core_cmd_fm_rds_blockcount,
-		.phase_diversity	= si476x_core_cmd_fm_phase_diversity,
-		.phase_div_status	= si476x_core_cmd_fm_phase_div_status,
 		.acf_status		= si476x_core_cmd_fm_acf_status,
-		.agc_status		= si476x_core_cmd_agc_status,
 	};
 
 	static const struct si476x_radio_ops am_ops = {
 		.tune_freq		= si476x_core_cmd_am_tune_freq,
 		.seek_start		= si476x_core_cmd_am_seek_start,
 		.rsq_status		= si476x_core_cmd_am_rsq_status,
-		.rds_blckcnt		= NULL,
-		.phase_diversity	= NULL,
-		.phase_div_status	= NULL,
 		.acf_status		= si476x_core_cmd_am_acf_status,
-		.agc_status		= NULL,
 	};
 
 	switch (func) {
@@ -545,11 +527,15 @@ static int si476x_radio_pretune(struct si476x_radio *radio,
 	case SI476X_FUNC_FM_RECEIVER:
 		args.freq = v4l2_to_si476x(radio->core,
 					   92 * FREQ_MUL);
+
+		BUG_ON(!radio->ops->tune_freq);
 		retval = radio->ops->tune_freq(radio->core, &args);
 		break;
 	case SI476X_FUNC_AM_RECEIVER:
 		args.freq = v4l2_to_si476x(radio->core,
 					   0.6 * FREQ_MUL);
+
+		BUG_ON(!radio->ops->tune_freq);
 		retval = radio->ops->tune_freq(radio->core, &args);
 		break;
 	default:
@@ -599,7 +585,7 @@ static int si476x_radio_do_post_powerup_init(struct si476x_radio *radio,
 	if (err < 0)
 		return err;
 
-	if (func == SI476X_FUNC_FM_RECEIVER) {
+	if (!si476x_core_is_in_am_receiver_mode(radio->core)) {
 		if (si476x_core_has_diversity(radio->core)) {
 			err = si476x_core_cmd_fm_phase_diversity(radio->core,
 								 radio->core->diversity_mode);
@@ -743,6 +729,7 @@ static int si476x_radio_s_frequency(struct file *file, void *priv,
 	args.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO;
 	args.antcap		= 0;
 
+	BUG_ON(!radio->ops->tune_freq);
 	err = radio->ops->tune_freq(radio->core, &args);
 
 unlock:
@@ -833,6 +820,7 @@ static int si476x_radio_s_hw_freq_seek(struct file *file, void *priv,
 			goto unlock;
 	}
 
+	BUG_ON(!radio->ops->seek_start);
 	err = radio->ops->seek_start(radio->core,
 				     seek->seek_upward,
 				     seek->wrap_around);
@@ -854,8 +842,8 @@ static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_SI476X_INTERCHIP_LINK:
 		if (si476x_core_has_diversity(radio->core)) {
-			if (radio->ops->phase_diversity) {
-				retval = radio->ops->phase_div_status(radio->core);
+			if (!si476x_core_is_in_am_receiver_mode(radio->core)) {
+				retval = si476x_core_cmd_fm_phase_div_status(radio->core);
 				if (retval < 0)
 					break;
 
@@ -1002,7 +990,7 @@ static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl)
 			radio->core->diversity_mode = mode;
 			retval = 0;
 		} else {
-			retval = radio->ops->phase_diversity(radio->core, mode);
+			retval = si476x_core_cmd_fm_phase_diversity(radio->core, mode);
 			if (!retval)
 				radio->core->diversity_mode = mode;
 		}
@@ -1256,11 +1244,11 @@ static ssize_t si476x_radio_read_rds_blckcnt_blob(struct file *file,
 	struct si476x_rds_blockcount_report report;
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
-		err = radio->ops->rds_blckcnt(radio->core, true,
-					       &report);
-	else
+	if (si476x_core_is_in_am_receiver_mode(radio->core))
 		err = -ENOENT;
+	else
+		err = si476x_core_cmd_fm_rds_blockcount(radio->core, true,
+							&report);
 	si476x_core_unlock(radio->core);
 
 	if (err < 0)
@@ -1285,10 +1273,10 @@ static ssize_t si476x_radio_read_agc_blob(struct file *file,
 	struct si476x_agc_status_report report;
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
-		err = radio->ops->agc_status(radio->core, &report);
-	else
+	if (si476x_core_is_in_am_receiver_mode(radio->core))
 		err = -ENOENT;
+	else
+		err = si476x_core_cmd_agc_status(radio->core, &report);
 	si476x_core_unlock(radio->core);
 
 	if (err < 0)
@@ -1304,15 +1292,17 @@ static const struct file_operations radio_agc_fops = {
 	.read	= si476x_radio_read_agc_blob,
 };
 
-static ssize_t si476x_radio_read_rsq_blob(struct file *file,
-					  char __user *user_buf,
-					  size_t count, loff_t *ppos)
+
+static ssize_t __si476x_radio_read_rsq_blob(bool is_primary,
+					    struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
 {
 	int err;
 	struct si476x_radio *radio = file->private_data;
 	struct si476x_rsq_status_report report;
 	struct si476x_rsq_status_args args = {
-		.primary	= false,
+		.primary	= is_primary,
 		.rsqack		= false,
 		.attune		= false,
 		.cancel		= false,
@@ -1320,7 +1310,7 @@ static ssize_t si476x_radio_read_rsq_blob(struct file *file,
 	};
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
+	if (radio->ops->rsq_status)
 		err = radio->ops->rsq_status(radio->core, &args, &report);
 	else
 		err = -ENOENT;
@@ -1331,6 +1321,14 @@ static ssize_t si476x_radio_read_rsq_blob(struct file *file,
 
 	return simple_read_from_buffer(user_buf, count, ppos, &report,
 				       sizeof(report));
+
+}
+
+static ssize_t si476x_radio_read_rsq_blob(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	return __si476x_radio_read_rsq_blob(false, file, user_buf, count, ppos);
 }
 
 static const struct file_operations radio_rsq_fops = {
@@ -1343,29 +1341,7 @@ static ssize_t si476x_radio_read_rsq_primary_blob(struct file *file,
 						  char __user *user_buf,
 						  size_t count, loff_t *ppos)
 {
-	int err;
-	struct si476x_radio *radio = file->private_data;
-	struct si476x_rsq_status_report report;
-	struct si476x_rsq_status_args args = {
-		.primary	= true,
-		.rsqack		= false,
-		.attune		= false,
-		.cancel		= false,
-		.stcack		= false,
-	};
-
-	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
-		err = radio->ops->rsq_status(radio->core, &args, &report);
-	else
-		err = -ENOENT;
-	si476x_core_unlock(radio->core);
-
-	if (err < 0)
-		return err;
-
-	return simple_read_from_buffer(user_buf, count, ppos, &report,
-				       sizeof(report));
+	return __si476x_radio_read_rsq_blob(true, file, user_buf, count, ppos);
 }
 
 static const struct file_operations radio_rsq_primary_fops = {
-- 
1.7.10.4

