Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3AWHTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:19:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3AWHTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634046"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 rebased 2/8] start vm after resetting it
Date: Wed, 23 Jan 2013 15:19:23 +0800
Message-Id: <19fae3171e31ae90c208895d90ad912291936794.1358920534.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1358920534.git.hutao@cn.fujitsu.com>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:37,
	Serialize complete at 2013/01/23 15:18:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The guest should run after resetting it, but it does not run if its
old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.

We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 include/block/block.h | 2 ++
 qmp.c                 | 2 +-
 vl.c                  | 7 ++++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/block/block.h b/include/block/block.h
index ffd1936..5e82ccb 100644
--- a/include/block/block.h
+++ b/include/block/block.h
@@ -366,6 +366,8 @@ void bdrv_disable_copy_on_read(BlockDriverState *bs);
 void bdrv_set_in_use(BlockDriverState *bs, int in_use);
 int bdrv_in_use(BlockDriverState *bs);
 
+void iostatus_bdrv_it(void *opaque, BlockDriverState *bs);
+
 #ifdef CONFIG_LINUX_AIO
 int raw_get_aio_fd(BlockDriverState *bs);
 #else
diff --git a/qmp.c b/qmp.c
index 55b056b..5f1bed1 100644
--- a/qmp.c
+++ b/qmp.c
@@ -130,7 +130,7 @@ SpiceInfo *qmp_query_spice(Error **errp)
 };
 #endif
 
-static void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
+void iostatus_bdrv_it(void *opaque, BlockDriverState *bs)
 {
     bdrv_iostatus_reset(bs);
 }
diff --git a/vl.c b/vl.c
index b0bcf1e..1d2edaa 100644
--- a/vl.c
+++ b/vl.c
@@ -534,7 +534,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_INMIGRATE, RUN_STATE_PAUSED },
 
-    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_PAUSED },
+    { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_IO_ERROR, RUN_STATE_RUNNING },
@@ -569,7 +569,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
-    { RUN_STATE_SHUTDOWN, RUN_STATE_PAUSED },
+    { RUN_STATE_SHUTDOWN, RUN_STATE_RUNNING },
     { RUN_STATE_SHUTDOWN, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_DEBUG, RUN_STATE_SUSPENDED },
@@ -1951,7 +1951,8 @@ static bool main_loop_should_exit(void)
         resume_all_vcpus();
         if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
             runstate_check(RUN_STATE_SHUTDOWN)) {
-            runstate_set(RUN_STATE_PAUSED);
+            bdrv_iterate(iostatus_bdrv_it, NULL);
+            vm_start();
         }
     }
     if (qemu_wakeup_requested()) {
-- 
1.8.0.1.240.ge8a1f5a

