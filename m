Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3BXJWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 04:22:39 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:43793 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3BXJWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 04:22:37 -0500
From: Artem Savkov <artem.savkov@gmail.com>
To: ibm-acpi-devel@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi@hmh.eng.br,
        matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] thinkpad_acpi: moved hotkey_thread_mutex lock after set_freezable()
Date: Sun, 24 Feb 2013 13:22:02 +0400
Message-Id: <1361697722-4575-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_freezable() checks freezing during which no locks should be held.
hotkey_thread_mutex lock should be moved closer to where it is actually needed.

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 22d8936..ffed96cd 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2463,13 +2463,13 @@ static int hotkey_kthread(void *data)
 	unsigned int poll_freq;
 	bool was_frozen;
 
-	mutex_lock(&hotkey_thread_mutex);
-
 	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
 		goto exit;
 
 	set_freezable();
 
+	mutex_lock(&hotkey_thread_mutex);
+
 	so = 0;
 	si = 1;
 	t = 0;
@@ -2523,8 +2523,8 @@ static int hotkey_kthread(void *data)
 		si ^= 1;
 	}
 
-exit:
 	mutex_unlock(&hotkey_thread_mutex);
+exit:
 	return 0;
 }
 
-- 
1.8.1.4

