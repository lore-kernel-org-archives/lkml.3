Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3LBUBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:01:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3LBTR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Lorenz <olli@olorenz.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 098/212] PM / Hibernate: Do not crash kernel in free_basic_memory_bitmaps()
Date: Mon,  2 Dec 2013 11:14:49 -0800
Message-Id: <20131202191258.369635385@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 6a0c7cd33075f6b7f1d80145bb19812beb3fc5c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/snapshot.c |    3 ++-
 kernel/power/user.c     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -792,7 +792,8 @@ void free_basic_memory_bitmaps(void)
 {
 	struct memory_bitmap *bm1, *bm2;
 
-	BUG_ON(!(forbidden_pages_map && free_pages_map));
+	if (WARN_ON(!(forbidden_pages_map && free_pages_map)))
+		return;
 
 	bm1 = forbidden_pages_map;
 	bm2 = free_pages_map;
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -70,6 +70,7 @@ static int snapshot_open(struct inode *i
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
+		data->free_bitmaps = false;
 		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (error)
 			pm_notifier_call_chain(PM_POST_HIBERNATION);


