Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaG3MYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:24:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36771 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 70/94] PM / sleep: Fix request_firmware() error at resume
Date: Wed, 30 Jul 2014 14:14:59 +0200
Message-Id: <d5f32654455c75265f46e2c2ff1cdcadd3ebbabb.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/power/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 06ec8869dbf1..14f9a8d4725d 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -184,6 +184,7 @@ void thaw_processes(void)
 
 	printk("Restarting tasks ... ");
 
+	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);
-- 
2.0.1

