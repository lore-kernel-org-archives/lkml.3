Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3KNVhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:37:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57377 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757261Ab3KNVhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:37:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / Hibernate: Do not crash kernel in free_basic_memory_bitmaps()
Date: Thu, 14 Nov 2013 22:49:34 +0100
Message-ID: <86536154.DW1yQsKN97@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I have received a report about the BUG_ON() in free_basic_memory_bitmaps()
triggering mysteriously during an aborted s2disk hibernation attempt.
The only way I can explain that is that /dev/snapshot was first
opened for writing (resume mode), then closed and then opened again
for reading and closed again without freezing tasks.  In that case
the first invocation of snapshot_open() would set the free_bitmaps
flag in snapshot_state, which is a static variable.  That flag
wouldn't be cleared later and the second invocation of snapshot_open()
would just leave it like that, so the subsequent snapshot_release()
would see data->frozen set and free_basic_memory_bitmaps() would be
called unnecessarily.

To prevent that from happening clear data->free_bitmaps in
snapshot_open() when the file is being opened for reading (hibernate
mode).

In addition to that, replace the BUG_ON() in free_basic_memory_bitmaps()
with a WARN_ON() as the kernel can continue just fine if the condition
checked by that macro occurs.

Fixes: aab172891542 (PM / hibernate: Fix user space driven resume regression)
Reported-by: Oliver Lorenz <olli@olorenz.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/snapshot.c |    3 ++-
 kernel/power/user.c     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/kernel/power/user.c
===================================================================
--- linux-pm.orig/kernel/power/user.c
+++ linux-pm/kernel/power/user.c
@@ -70,6 +70,7 @@ static int snapshot_open(struct inode *i
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
+		data->free_bitmaps = false;
 		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (error)
 			pm_notifier_call_chain(PM_POST_HIBERNATION);
Index: linux-pm/kernel/power/snapshot.c
===================================================================
--- linux-pm.orig/kernel/power/snapshot.c
+++ linux-pm/kernel/power/snapshot.c
@@ -792,7 +792,8 @@ void free_basic_memory_bitmaps(void)
 {
 	struct memory_bitmap *bm1, *bm2;
 
-	BUG_ON(!(forbidden_pages_map && free_pages_map));
+	if (WARN_ON(!(forbidden_pages_map && free_pages_map)))
+		return;
 
 	bm1 = forbidden_pages_map;
 	bm2 = free_pages_map;

