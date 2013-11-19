Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3KSSrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:47:06 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:52268
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab3KSSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:47:04 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, joe@perches.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v2] power: Replace printks with dev_* and pr_* routines
Date: Tue, 19 Nov 2013 11:46:58 -0700
Message-Id: <1384886818-11861-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced printks with dev_* and pr_* routines. Replacing printk in
__suspend_report_result() will require passing in struct device *
pointer from calling routines and this will require changes to
external interface suspend_report_result() which is used by several
drivers. Hence, this one instance is replaced by pr_err().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9f098a8..3f42c43 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -349,8 +349,8 @@ static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 static void pm_dev_err(struct device *dev, pm_message_t state, char *info,
 			int error)
 {
-	printk(KERN_ERR "PM: Device %s failed to %s%s: error %d\n",
-		dev_name(dev), pm_verb(state.event), info, error);
+	dev_err(dev, "PM: failed to %s%s: error %d\n",
+		pm_verb(state.event), info, error);
 }
 
 static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
@@ -1308,9 +1308,8 @@ int dpm_prepare(pm_message_t state)
 				error = 0;
 				continue;
 			}
-			printk(KERN_INFO "PM: Device %s not prepared "
-				"for power transition: code %d\n",
-				dev_name(dev), error);
+			dev_info("PM: not prepared for power transition: ",
+				 "code %d\n", error);
 			put_device(dev);
 			break;
 		}
@@ -1347,7 +1346,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_start);
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
 	if (ret)
-		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
+		pr_err("%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
 
-- 
1.8.3.2

