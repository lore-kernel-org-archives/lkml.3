Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbbA1Bi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052AbbA1BiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.14 17/77] time: adjtimex: Validate the ADJ_FREQUENCY values
Date: Tue, 27 Jan 2015 17:26:55 -0800
Message-Id: <20150128012746.480339545@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 5e5aeb4367b450a28f447f6d5ab57d8f2ab16a5f upstream.

Verify that the frequency value from userspace is valid and makes sense.

Unverified values can cause overflows later on.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
[jstultz: Fix up bug for negative values and drop redunent cap check]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/ntp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -631,6 +631,13 @@ int ntp_validate_timex(struct timex *txc
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
 


