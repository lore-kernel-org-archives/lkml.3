Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaCKFDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:03:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbaCKFB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:59 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676444"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        devel@driverdev.osuosl.org, Masanari Iida <standby24x7@gmail.com>,
        Bojan Prtvar <prtvar.b@gmail.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 12/15] driver/staging/android: Use RLIMIT_TO_NICE to replace opened code implementation.
Date: Tue, 11 Mar 2014 12:59:27 +0800
Message-Id: <ede8cdf9e79278aaab8fda678ec480234e376371.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:59:01,
	Serialize complete at 2014/03/11 12:59:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro RLINIT_TO_NICE in linux/sched/prio.h to convert priority in rlimit
to nice value.

This patch replace the opened implementation with RLINIT_TO_NICE.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: devel@driverdev.osuosl.org
cc: Masanari Iida <standby24x7@gmail.com>
cc: Bojan Prtvar <prtvar.b@gmail.com>
cc: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 1432d95..0cf5a49 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -436,12 +436,12 @@ static void binder_set_nice(long nice)
 		set_user_nice(current, nice);
 		return;
 	}
-	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
+	min_nice = RLIMIT_TO_NICE(current->signal->rlim[RLIMIT_NICE].rlim_cur);
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

