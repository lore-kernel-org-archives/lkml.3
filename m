Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaGZTjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:39:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaGZTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3.15 020/109] xen/manage: fix potential deadlock when resuming the console
Date: Sat, 26 Jul 2014 12:01:42 -0700
Message-Id: <20140726190224.447218240@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/manage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -109,7 +109,6 @@ static int xen_suspend(void *data)
 
 	if (!si->cancelled) {
 		xen_irq_resume();
-		xen_console_resume();
 		xen_timer_resume();
 	}
 
@@ -166,6 +165,10 @@ static void do_suspend(void)
 
 	err = stop_machine(xen_suspend, &si, cpumask_of(0));
 
+	/* Resume console as early as possible. */
+	if (!si.cancelled)
+		xen_console_resume();
+
 	raw_notifier_call_chain(&xen_resume_notifier, 0, NULL);
 
 	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);


