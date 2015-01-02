Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbABTvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:51:20 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41196 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABTvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:51:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/2] time: adjtimex: Validate the ADJ_FREQUENCY values
Date: Fri,  2 Jan 2015 11:51:08 -0800
Message-Id: <1420228268-2161-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420228268-2161-1-git-send-email-john.stultz@linaro.org>
References: <1420228268-2161-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

Verify that the frequency value from userspace is valid and makes sense.

Unverified values can cause overflows later on.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
[jstultz: Fix up bug for negative values and drop redunent cap check]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 87a346f..28bf91c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -633,6 +633,13 @@ int ntp_validate_timex(struct timex *txc)
 	if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
 		return -EPERM;
 
+	if (txc->modes & ADJ_FREQUENCY) {
+		if (LONG_MIN / PPM_SCALE > txc->freq)
+			return -EINVAL;
+		if (LONG_MAX / PPM_SCALE < txc->freq)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.9.1

