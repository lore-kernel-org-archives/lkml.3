Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607Ab3ECUqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:46:54 -0400
Received: from mx2.sisa.samsung.com ([63.166.156.250]:48445 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763578Ab3ECUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:46:53 -0400
X-ASG-Debug-ID: 1367614012-051129071a04320001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree() while
 holding device power lock
Thread-Topic: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
X-ASG-Orig-Subj: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree() while
 holding device power lock
Thread-Index: AQHOSD9WkkQkCwYLLkewoPShwxGqcg==
Date: Fri, 3 May 2013 20:46:50 +0000
Message-ID: <1367614010.8452.2.camel@lorien>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.7]
Content-Type: text/plain; charset="utf-8"
Content-ID: <059CC7F1C823A24F96532224F6AF8F94@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1367614012
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r43Kkxqw015351

dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
the reference count is 0. Fix it to call kfree() after releasing the lock.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/common.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
index 39c3252..da05fe2 100644
--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -73,13 +73,17 @@ int dev_pm_put_subsys_data(struct device *dev)
 
 	if (--psd->refcount == 0) {
 		dev->power.subsys_data = NULL;
-		kfree(psd);
 		ret = 1;
 	}
 
  out:
 	spin_unlock_irq(&dev->power.lock);
 
+	if (ret == 1) {
+		/* kfree() verifies that its argument is nonzero. */
+		kfree(psd);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_put_subsys_data);
-- 
1.7.10.4


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
