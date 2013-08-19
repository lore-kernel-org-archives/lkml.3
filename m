Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3HSU5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:57:00 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3HSU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:56:59 -0400
From: Richard Weinberger <richard@nod.at>
To: xfs@oss.sgi.com
Cc: bpm@sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] xfs: Register hotcpu notifier after initialization
Date: Mon, 19 Aug 2013 22:56:44 +0200
Message-Id: <1376945804-29508-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the code initializizes mp->m_icsb_mutex and other things
_after_ register_hotcpu_notifier().
As the notifier takes mp->m_icsb_mutex it can happen
that it takes the lock before it's initialization.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/xfs/xfs_mount.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..986f9cf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -2260,12 +2260,6 @@ xfs_icsb_init_counters(
 	if (mp->m_sb_cnts == NULL)
 		return -ENOMEM;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
-	mp->m_icsb_notifier.priority = 0;
-	register_hotcpu_notifier(&mp->m_icsb_notifier);
-#endif /* CONFIG_HOTPLUG_CPU */
-
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
@@ -2278,6 +2272,13 @@ xfs_icsb_init_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
+	mp->m_icsb_notifier.priority = 0;
+	register_hotcpu_notifier(&mp->m_icsb_notifier);
+#endif /* CONFIG_HOTPLUG_CPU */
+
 	return 0;
 }
 
-- 
1.8.3.1

