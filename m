Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3CHPHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:07:31 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34060 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab3CHPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:07:30 -0500
Message-ID: <5139FEAF.5080200@gmail.com>
Date: Fri, 08 Mar 2013 16:07:27 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: use atomic_inc_unless_negative in sysfs_get_active
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that sysfs has an interesting way of doing the same thing.
This removes the cpu_relax unfortunately, but if it's really needed,
it would be better to add this to include/linux/atomic.h to benefit
all atomic ops users.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
 ---

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..7f968ed 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -165,21 +165,8 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 	if (unlikely(!sd))
 		return NULL;
 
-	while (1) {
-		int v, t;
-
-		v = atomic_read(&sd->s_active);
-		if (unlikely(v < 0))
-			return NULL;
-
-		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
-		if (likely(t == v))
-			break;
-		if (t < 0)
-			return NULL;
-
-		cpu_relax();
-	}
+	if (!atomic_inc_unless_negative(&sd->s_active))
+		return NULL;
 
 	if (likely(!ignore_lockdep(sd)))
 		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);

