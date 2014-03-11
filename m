Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaCKJX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:23:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbaCKJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677987"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        devel@driverdev.osuosl.org, Masanari Iida <standby24x7@gmail.com>,
        Bojan Prtvar <prtvar.b@gmail.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 13/16] driver/staging/android: Use rlimit_to_nice to replace opened code implementation.
Date: Tue, 11 Mar 2014 17:20:34 +0800
Message-Id: <4748d2da179215c9563d84a304c02e677eaa4222.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:16,
	Serialize complete at 2014/03/11 17:20:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro rlimit_to_nice in linux/sched/prio.h to convert priority in rlimit
to nice value.

This patch replace the opened implementation with rlimit_to_nice.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: devel@driverdev.osuosl.org
cc: Masanari Iida <standby24x7@gmail.com>
cc: Bojan Prtvar <prtvar.b@gmail.com>
cc: Serban Constantinescu <serban.constantinescu@arm.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 drivers/staging/android/binder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 1432d95..19e844b 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -436,12 +436,12 @@ static void binder_set_nice(long nice)
 		set_user_nice(current, nice);
 		return;
 	}
-	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
+	min_nice = rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur);
 	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
 		     "%d: nice value %ld not allowed use %ld instead\n",
 		      current->pid, nice, min_nice);
 	set_user_nice(current, min_nice);
-	if (min_nice < 20)
+	if (min_nice <= MAX_NICE)
 		return;
 	binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
 }
-- 
1.8.2.1

