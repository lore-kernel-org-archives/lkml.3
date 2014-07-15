Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbaGOGvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:51:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719AbaGOGv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:51:29 -0400
From: Takashi Iwai <tiwai@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PM / sleep: Fix request_firmware() error at resume
Date: Tue, 15 Jul 2014 08:51:27 +0200
Message-Id: <1405407087-19493-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit [247bc037: PM / Sleep: Mitigate race between the freezer
and request_firmware()] introduced the finer state control, but it
also leads to a new bug; for example, a bug report regarding the
firmware loading of intel BT device at suspend/resume:
  https://bugzilla.novell.com/show_bug.cgi?id=873790

The root cause seems to be a small window between the process resume
and the clear of usermodehelper lock.  The request_firmware() function
checks the UMH lock and gives up when it's in UMH_DISABLE state.  This
is for avoiding the invalid  f/w loading during suspend/resume phase.
The problem is, however, that usermodehelper_enable() is called at the
end of thaw_processes().  Thus, a thawed process in between can kick
off the f/w loader code path (in this case, via btusb_setup_intel())
even before the call of usermodehelper_enable().  Then
usermodehelper_read_trylock() returns an error and request_firmware()
spews WARN_ON() in the end.

This oneliner patch fixes the issue just by setting to UMH_FREEZING
state again before restarting tasks, so that the call of
request_firmware() will be blocked until the end of this function
instead of returning an error.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=873790
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 kernel/power/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0ca8d83e2369..4ee194eb524b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -186,6 +186,7 @@ void thaw_processes(void)
 
 	printk("Restarting tasks ... ");
 
+	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);
-- 
2.0.1

