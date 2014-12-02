Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaLBEE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:04:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbaLBEE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: make sure tz_minuteswest is set to a valid value when setting time
Date: Mon,  1 Dec 2014 23:04:06 -0500
Message-Id: <1417493050-13594-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid values may overflow later, leading to undefined behaviour when
multiplied by 60 to get the amount of seconds.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/time/time.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 7399a73..9ec4fa5 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -173,6 +173,10 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 		return error;
 
 	if (tz) {
+		/* Verify we're witin the +-15 hrs range */
+		if (tz->tz_minuteswest > 15*60 || tz->tz_minuteswest < -15*60)
+			return -EINVAL;
+
 		sys_tz = *tz;
 		update_vsyscall_tz();
 		if (firsttime) {
-- 
1.7.10.4

