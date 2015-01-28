Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbbA2KhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:37:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755584AbbA2JAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 151/176] time: adjtimex: Validate the ADJ_FREQUENCY values
Date: Wed, 28 Jan 2015 15:29:41 +0100
Message-Id: <64678c15381f8efa6beeb565ada1021e45f50c7a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5e5aeb4367b450a28f447f6d5ab57d8f2ab16a5f upstream.

Verify that the frequency value from userspace is valid and makes sense.

Unverified values can cause overflows later on.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
[jstultz: Fix up bug for negative values and drop redunent cap check]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/time/ntp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index af8d1d4f3d55..28db9bedc857 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -631,6 +631,13 @@ int ntp_validate_timex(struct timex *txc)
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
2.2.2

