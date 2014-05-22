Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaEVU4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:56:43 -0400
Received: from mout.gmx.net ([212.227.17.22]:63403 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaEVU4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:56:41 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] acpi: Use time_before() for time comparison
Date: Thu, 22 May 2014 22:56:36 +0200
Message-Id: <1400792196-28477-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:xV6zoTsu47Jn8ahJcum/HIrOP/JEwbWriCNPGQ73x5WNlKO67WF
 mI17I+ISIc/fIGr0+Fyz4aojSrGIJKvMLoVE81R/15rhCz5TmLff6U4dDkv5r9TTogct53o
 4Rl9UZfL92DUzZLBRcfkV+JLqXfx1OJCwm//Y6BB//FC/drA1fmBmQCWx7+KeyKMKeK1B7U
 X7tiSsrqb5YqibHo3CepA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/acpi/acpi_pad.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 37d7302..0a3bbf5 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -156,12 +156,13 @@ static int power_saving_thread(void *data)
 
 	while (!kthread_should_stop()) {
 		int cpu;
-		u64 expire_time;
+		unsigned long expire_time;
 
 		try_to_freeze();
 
 		/* round robin to cpus */
-		if (last_jiffies + round_robin_time * HZ < jiffies) {
+		expire_time = last_jiffies + round_robin_time * HZ;
+		if (time_before(expire_time, jiffies)) {
 			last_jiffies = jiffies;
 			round_robin_cpu(tsk_index);
 		}
@@ -200,7 +201,7 @@ static int power_saving_thread(void *data)
 					CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
 			local_irq_enable();
 
-			if (jiffies > expire_time) {
+			if (time_before(expire_time, jiffies)) {
 				do_sleep = 1;
 				break;
 			}
-- 
1.7.10.4

