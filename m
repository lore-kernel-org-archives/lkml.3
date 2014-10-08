Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaJHCFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:05:33 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63209 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHCFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:05:32 -0400
X-Original-SENDERIP: 10.177.31.16
X-Original-MAILFROM: ciogenis@gmail.com
Date: Wed, 8 Oct 2014 11:05:29 +0900
From: Hyogi Gim <ciogenis@gmail.com>
To: a.zummo@towertech.it, akpm@linux-foundation.org, john.stultz@linaro.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/interface.c: check the validation of rtc_time in
 __rtc_read_time
Message-ID: <20141008020529.GA21464@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of rtc devices always return '0' when rtc_class_ops.read_time is called.
So if rtc_time isn't verified in callback, rtc interface cannot know whether
rtc_time is valid.

Check rtc_time by using 'rtc_valid_tm' in '__rtc_read_time'. And add the
message for debugging.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
---
 drivers/rtc/interface.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5b2717f..818ea97 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -30,6 +30,14 @@ static int __rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 	else {
 		memset(tm, 0, sizeof(struct rtc_time));
 		err = rtc->ops->read_time(rtc->dev.parent, tm);
+		if (err < 0) {
+			dev_err(&rtc->dev, "read_time: fail to read\n");
+			return err;
+		}
+
+		err = rtc_valid_tm(tm);
+		if (err < 0)
+			dev_err(&rtc->dev, "read_time: rtc_time isn't valid\n");
 	}
 	return err;
 }
-- 
1.8.3.2

