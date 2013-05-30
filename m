Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3E3UC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:02:56 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44862 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab3E3UCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:02:48 -0400
From: Julius Werner <jwerner@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] PM / Sleep: Print last wakeup source on failed wakeup_count write
Date: Thu, 30 May 2013 13:02:17 -0700
Message-Id: <1369944137-30948-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a938da06 introduced a useful little log message to tell
users/debuggers which wakeup source aborted a suspend. However, this
message is only printed if the abort happens during the in-kernel
suspend path (after writing /sys/power/state).

The full specification of the /sys/power/wakeup_count facility allows
user-space power managers to double-check if wakeups have already
happened before it actually tries to suspend (e.g. while it was running
user-space pre-suspend hooks), by writing the last known wakeup_count
value to /sys/power/wakeup_count. This patch changes the sysfs handler
for that node to also print said log message if that write fails, so
that we can figure out the offending wakeup source for both kinds of
suspend aborts.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/base/power/wakeup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 79715e7..b0b7886 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -772,6 +772,8 @@ bool pm_save_wakeup_count(unsigned int count)
 		events_check_enabled = true;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
+	if (!events_check_enabled)
+		print_active_wakeup_sources();
 	return events_check_enabled;
 }
 
-- 
1.7.12.4

