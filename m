Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3EFTE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:04:56 -0400
Received: from mx2.sisa.samsung.com ([63.166.156.250]:55122 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3EFTEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:04:55 -0400
X-ASG-Debug-ID: 1367867094-05112907200d8b0001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Topic: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call
 kfree() while holding device power lock
X-ASG-Orig-Subj: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Index: AQHOSoyXedE0CiKV/Ee/GdKhNFCEcA==
Date: Mon, 6 May 2013 19:04:53 +0000
Message-ID: <1367867093.2953.49.camel@lorien>
References: <1367614010.8452.2.camel@lorien>
	 <20130504125116.GA13770@amd.pavel.ucw.cz>
	 <1882177.s6zpHZ6crc@vostro.rjw.lan>
	 <20130506120925.GA25542@amd.pavel.ucw.cz>
In-Reply-To: <20130506120925.GA25542@amd.pavel.ucw.cz>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.5]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7579030CCEDC2A4EAE54A207B29DC6E0@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1367867094
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46J531h025602

dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
the reference count is 0. Fix it to call kfree() after releasing the lock.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Rafael Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/common.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
index 39c3252..e5b99f7 100644
--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -61,24 +61,26 @@ EXPORT_SYMBOL_GPL(dev_pm_get_subsys_data);
 int dev_pm_put_subsys_data(struct device *dev)
 {
 	struct pm_subsys_data *psd;
-	int ret = 0;
+	int ret = 1;
 
 	spin_lock_irq(&dev->power.lock);
 
 	psd = dev_to_psd(dev);
 	if (!psd) {
-		ret = -EINVAL;
 		goto out;
 	}
 
 	if (--psd->refcount == 0) {
 		dev->power.subsys_data = NULL;
-		kfree(psd);
 		ret = 1;
+	} else {
+		psd = NULL;
+		ret = 0;
 	}
 
  out:
 	spin_unlock_irq(&dev->power.lock);
+	kfree(psd);
 
 	return ret;
 }
-- 
1.7.10.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
