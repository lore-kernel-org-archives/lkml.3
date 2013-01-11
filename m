Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3AKK7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:59:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3AKK7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:59:05 -0500
From: Miroslav Lichvar <mlichvar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv2] posix-timers: Fix clock_adjtime to always return timex data on success
Date: Fri, 11 Jan 2013 11:58:58 +0100
Message-Id: <1357901938-3098-1-git-send-email-mlichvar@redhat.com>
In-Reply-To: <50EF2441.7020507@linaro.org>
References: <50EF2441.7020507@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock_adj call returns the clock state on success, which may be a
non-zero value (e.g. TIME_INS), but the modified timex data is copied
back to the user only when zero value (TIME_OK) was returned. Fix the
condition to copy the data also with positive return values.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 kernel/posix-timers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..10349d5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -997,7 +997,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
+	if (err >= 0 && copy_to_user(utx, &ktx, sizeof(ktx)))
 		return -EFAULT;
 
 	return err;
-- 
1.7.11.7

