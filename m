Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBKRKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:10:50 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25038 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752025AbaBKRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:44 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 01/12] misc: vexpress-syscfg: Add udelay-based delay
Date: Tue, 11 Feb 2014 17:10:25 +0000
Message-Id: <1392138636-29240-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is normally preferable to yield the task
waiting for syscfg operations (that can take
up to dozens of milliseconds), but when the
system is shutting down it may not be possible.

This patch adds a udelay-based version of the
code to be used in such circumstances.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/misc/vexpress-syscfg.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index 4d661ef..82f8229 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -53,6 +53,37 @@ struct vexpress_syscfg_func {
 };
 
 
+static int vexpress_syscfg_delay_schedule(unsigned int us)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(usecs_to_jiffies(us));
+	if (signal_pending(current))
+		return -EINTR;
+
+	return 0;
+}
+
+static int vexpress_syscfg_delay_loop(unsigned int us)
+{
+	udelay(us);
+
+	return 0;
+}
+
+static int (*vexpress_syscfg_delay)(unsigned int us) =
+		vexpress_syscfg_delay_schedule;
+
+static void vexpress_syscfg_shutdown(void)
+{
+	/* Can't relay on the scheduler when the system is going down */
+	vexpress_syscfg_delay = vexpress_syscfg_delay_loop;
+}
+
+static struct syscore_ops vexpress_syscfg_syscore_ops = {
+	.shutdown = vexpress_syscfg_shutdown,
+};
+
+
 static int vexpress_syscfg_exec(struct vexpress_syscfg_func *func,
 		int index, bool write, u32 *data)
 {
@@ -87,10 +118,9 @@ static int vexpress_syscfg_exec(struct vexpress_syscfg_func *func,
 	tries = 100;
 	timeout = 100;
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(usecs_to_jiffies(timeout));
-		if (signal_pending(current))
-			return -EINTR;
+		int err = vexpress_syscfg_delay(timeout);
+		if (err)
+			return err;
 
 		status = readl(syscfg->base + SYS_CFGSTAT);
 		if (status & SYS_CFGSTAT_ERR)
@@ -299,6 +329,8 @@ int vexpress_syscfg_probe(struct platform_device *pdev)
 	if (!pdev->dev.of_node)
 		vexpress_syscfg_bridge = bridge;
 
+	register_syscore_ops(&vexpress_syscfg_syscore_ops);
+
 	return 0;
 }
 
-- 
1.8.3.2

