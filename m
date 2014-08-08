Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaHHUmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:42:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaHHUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 135/259] PM / sleep: Fix request_firmware() error at resume
Date: Fri,  8 Aug 2014 13:39:18 -0700
Message-Id: <1407530482-4483-136-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4320f6b1d9db4ca912c5eb6ecb328b2e090e1586 upstream.

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

Fixes: 247bc0374254 (PM / Sleep: Mitigate race between the freezer and request_firmware())
Link: https://bugzilla.novell.com/show_bug.cgi?id=873790
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/power/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 06ec886..14f9a8d 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -184,6 +184,7 @@ void thaw_processes(void)
 
 	printk("Restarting tasks ... ");
 
+	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);
-- 
1.9.1

