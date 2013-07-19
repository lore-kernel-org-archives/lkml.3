Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab3GSIsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:48:42 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:33614 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759869Ab3GSIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:48:38 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: alipowski@interia.pl, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com,
        srinivas.kandagatla@st.com, sean@mess.org
Subject: [PATCH v1 1/2] media: rc: Add user count to rc dev.
Date: Fri, 19 Jul 2013 09:39:27 +0100
Message-Id: <1374223167-4980-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1374223132-4924-1-git-send-email-srinivas.kandagatla@st.com>
References: <1374223132-4924-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds user count to rc_dev structure, the reason to add this
new member is to allow other code like lirc to open rc device directly.
In the existing code, rc device is only opened by input subsystem which
works ok if we have any input drivers to match. But in case like lirc
where there will be no input driver, rc device will be never opened.

Having this user count variable will be useful to allow rc device to be
opened from code other than rc-main.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/rc-main.c |   11 +++++++++--
 include/media/rc-core.h    |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1cf382a..e800b96 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -702,15 +702,22 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 static int ir_open(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
+	int rval = 0;
 
-	return rdev->open(rdev);
+	if (!rdev->users++)
+		rval = rdev->open(rdev);
+
+	if (rval)
+		rdev->users--;
+
+	return rval;
 }
 
 static void ir_close(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 
-	 if (rdev)
+	 if (rdev && !--rdev->users)
 		rdev->close(rdev);
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 06a75de..b42016a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -101,6 +101,7 @@ struct rc_dev {
 	bool				idle;
 	u64				allowed_protos;
 	u64				enabled_protocols;
+	u32				users;
 	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;
-- 
1.7.6.5

