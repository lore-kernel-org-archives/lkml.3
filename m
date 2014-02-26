Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBZACN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:02:13 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41910 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBZACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:02:08 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Russ Dill <Russ.Dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 1/3] Fix hibernation restore hang in freeze_processes
Date: Tue, 25 Feb 2014 16:01:58 -0800
Message-Id: <1393372920-3896-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393372920-3896-1-git-send-email-sebastian.capella@linaro.org>
References: <1393372920-3896-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During restore, pm_notifier chain are called with
PM_RESTORE_PREPARE.  The firmware_class driver handler
fw_pm_notify does not have a handler for this.  As a result,
it keeps a reader on the kmod.c umhelper_sem.  During
freeze_processes, the call to __usermodehelper_disable tries to
take a write lock on this semaphore and hangs waiting.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Acked-by: Ming Lei <ming.lei@canonical.com>
Cc: Russ Dill <Russ.Dill@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index eb8fb94..e2b51f8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1541,6 +1541,7 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
 		kill_requests_without_uevent();
 		device_cache_fw_images();
 		break;
-- 
1.7.9.5

