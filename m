Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHDQx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:53:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56650 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "David Vrabel" <david.vrabel@citrix.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.274536002@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/94] xen/manage: fix potential deadlock when
 resuming the console
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 1b6478231c6f5f844185acb32045cf195028cfce upstream.

Calling xen_console_resume() in xen_suspend() causes a warning because
it locks irq_mapping_update_lock (a mutex) and this may sleep.  If a
userspace process is using the evtchn device then this mutex may be
locked at the point of the stop_machine() call and
xen_console_resume() would then deadlock.

Resuming the console after stop_machine() returns avoids this
deadlock.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/manage.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -93,7 +93,6 @@ static int xen_suspend(void *data)
 
 	if (!si->cancelled) {
 		xen_irq_resume();
-		xen_console_resume();
 		xen_timer_resume();
 	}
 
@@ -149,6 +148,10 @@ static void do_suspend(void)
 
 	err = stop_machine(xen_suspend, &si, cpumask_of(0));
 
+	/* Resume console as early as possible. */
+	if (!si.cancelled)
+		xen_console_resume();
+
 	dpm_resume_noirq(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 	if (err) {

