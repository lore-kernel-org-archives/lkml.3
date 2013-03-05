Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3CERey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:34:54 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53112 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3CERew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:34:52 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Date: Tue,  5 Mar 2013 09:34:43 -0800
Message-Id: <1362504883-9180-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <201303042055.38040.maciej.rutecki@gmail.com>
References: <201303042055.38040.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following lockdep error:

[ BUG: ktpacpi_nvramd/446 still has locks held! ]

hotkey_kthread() calls set_freezable() after acquiring the
hotkey_kthread_mutex(). set_freezable() calls try_to_freeze().
This could block suspend if we were to freeze at this point
and another task were to block on the mutex, potentially via
writing to one of the sysfs attrs. This race is unlikely but
can be easily fixed by moving the set_freezable() call.

Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Aaron Lu <aaron.lu@intel.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 9a90756..69870a841 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2462,13 +2462,13 @@ static int hotkey_kthread(void *data)
 	unsigned int poll_freq;
 	bool was_frozen;
 
+	set_freezable();
+
 	mutex_lock(&hotkey_thread_mutex);
 
 	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
 		goto exit;
 
-	set_freezable();
-
 	so = 0;
 	si = 1;
 	t = 0;
-- 
1.7.12.4

