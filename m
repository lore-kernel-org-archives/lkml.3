Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbaLBEEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:04:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34600 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbaLBEEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: settimeofday: validate the values of tv fomr user
Date: Mon,  1 Dec 2014 23:04:09 -0500
Message-Id: <1417493050-13594-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unvalidated user input is multiplied by a constant, which can result in
an undefined behaviour for large values. While this is validated later,
we should avoid triggering undefined behaviour.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/time/time.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 9ec4fa5..6f53df7 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -200,6 +200,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
 	if (tv) {
 		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
 			return -EFAULT;
+
+		if (user_tv.tv_usec > USEC_PER_SEC || user_tv.tv_usec < 0)
+			return -EINVAL;
+
 		new_ts.tv_sec = user_tv.tv_sec;
 		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
 	}
-- 
1.7.10.4

