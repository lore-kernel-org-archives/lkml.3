Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBGOkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:40:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaBGOkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:40:40 -0500
Date: Fri, 7 Feb 2014 06:40:16 -0800
From: tip-bot for Shaibal Dutta <tipbot@zytor.com>
Message-ID: <tip-e8b175946c16d7001b22620f52d78ab497efc9d0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shaibal.dutta@linaro.org, zoran.markovic@linaro.org,
        john.stultz@linaro.org, shaibal.dutta@broadcom.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shaibal.dutta@linaro.org, zoran.markovic@linaro.org,
        john.stultz@linaro.org, shaibal.dutta@broadcom.com, tglx@linutronix.de
In-Reply-To: <1391195904-12497-1-git-send-email-zoran.markovic@linaro.org>
References: <1391195904-12497-1-git-send-email-zoran.markovic@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Move clock sync work to power efficient workqueue
Git-Commit-ID: e8b175946c16d7001b22620f52d78ab497efc9d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 07 Feb 2014 06:40:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8b175946c16d7001b22620f52d78ab497efc9d0
Gitweb:     http://git.kernel.org/tip/e8b175946c16d7001b22620f52d78ab497efc9d0
Author:     Shaibal Dutta <shaibal.dutta@linaro.org>
AuthorDate: Fri, 31 Jan 2014 11:18:24 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 7 Feb 2014 15:34:28 +0100

timekeeping: Move clock sync work to power efficient workqueue

For better use of CPU idle time, allow the scheduler to select the CPU
on which the CMOS clock sync work would be scheduled. This improves
idle residency time and conserver power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Added commit message. Aligned code.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1391195904-12497-1-git-send-email-zoran.markovic@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index af8d1d4..419a52c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -514,12 +514,13 @@ static void sync_cmos_clock(struct work_struct *work)
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
+	queue_delayed_work(system_power_efficient_wq,
+			   &sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 void ntp_notify_cmos_timer(void)
 {
-	schedule_delayed_work(&sync_cmos_work, 0);
+	queue_delayed_work(system_power_efficient_wq, &sync_cmos_work, 0);
 }
 
 #else
