Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaLDAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:25:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45355 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLDAZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:25:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: adjtimex: validate the ADJ_FREQUENCY case
Date: Wed,  3 Dec 2014 19:25:05 -0500
Message-Id: <1417652705-1959-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify that the frequency value from userspace is valid and makes sense.

Unverified values can cause overflows later on.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/time/ntp.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 87a346f..54828cf 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -633,6 +633,15 @@ int ntp_validate_timex(struct timex *txc)
 	if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
 		return -EPERM;
 
+	if (txc->modes & ADJ_FREQUENCY) {
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+		if (txc->freq < 0)
+			return -EINVAL;
+		if (LONG_MAX / PPM_SCALE < txc->freq)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.7.10.4

