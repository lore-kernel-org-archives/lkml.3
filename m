Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3LRHgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:36:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59890 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3LRHgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:36:31 -0500
From: xqx12 <s2exqx@gmail.com>
To: giometti@enneenne.com, linux-kernel@vger.kernel.org
Cc: chyyuu@gmail.com, xuyongjiande@gmail.com, xqx12 <xiaoqixue_1@163.com>
Subject: [PATCH] a multiplication overflow in drivers/pps/pps.c
Date: Wed, 18 Dec 2013 15:36:11 +0800
Message-Id: <1387352171-3811-1-git-send-email-xiaoqixue_1@163.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is an overflow in the following code :

ticks = fdata.timeout.sec * HZ;

while ticks is a signed 64-bit, but the result of fdata.timeout.sec *
HZ will be converted be 32-bit first. So ticks will be a wrong value
after multiplication overflow.

Reported-by: Qixue Xiao <xiaoqixue_1@163.com>
Suggested-by: Yongjian Xu <xuyongjiande@gmail.com>
Suggested-by: Yu Chen <chyyuu@gmail.com>
Signed-off-by: Qixue Xiao <xiaoqixue_1@163.com>
---
 drivers/pps/pps.c |    2 +-
 gentags.sh        |    4 +++
 memory_leak.txt   |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 1 deletion(-)
 create mode 100755 gentags.sh
 create mode 100644 memory_leak.txt

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2f07cd6..44ddd22 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -164,7 +164,7 @@ static long pps_cdev_ioctl(struct file *file,
 			dev_dbg(pps->dev, "timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
-			ticks = fdata.timeout.sec * HZ;
+			ticks = (s64)(fdata.timeout.sec) * HZ;
 			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
 
 			if (ticks != 0) {
-- 
1.7.9.5

