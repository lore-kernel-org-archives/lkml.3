Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaGZTCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:02:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaGZTC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.4 22/23] PM / sleep: Fix request_firmware() error at resume
Date: Sat, 26 Jul 2014 12:02:22 -0700
Message-Id: <20140726190150.405131027@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/process.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -185,6 +185,7 @@ void thaw_processes(void)
 
 	printk("Restarting tasks ... ");
 
+	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);


