Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3AWHVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:21:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab3AWHTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634047"
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
Subject: [PATCH v12 rebased 4/8] add a new runstate: RUN_STATE_GUEST_PANICKED
Date: Wed, 23 Jan 2013 15:19:25 +0800
Message-Id: <d54a61edf06ab99dd2ad91aa858fe6a5c479ddca.1358920534.git.hutao@cn.fujitsu.com>
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

The guest will be in this state when it is panicked.

If guest is panicked during live migration, the runstate
RUN_STATE_GUEST_PANICKED will be transferred to dest machine.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 migration.c      |  1 +
 qapi-schema.json |  6 +++++-
 qmp.c            |  3 ++-
 vl.c             | 11 ++++++++++-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/migration.c b/migration.c
index f96cfd6..2b51913 100644
--- a/migration.c
+++ b/migration.c
@@ -705,6 +705,7 @@ static void *buffered_file_thread(void *opaque)
                 int64_t start_time, end_time;
 
                 DPRINTF("done iterating\n");
+                save_run_state();
                 start_time = qemu_get_clock_ms(rt_clock);
                 qemu_system_wakeup_request(QEMU_WAKEUP_REASON_OTHER);
                 if (old_vm_running) {
diff --git a/qapi-schema.json b/qapi-schema.json
index 6d7252b..b49094b 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -174,11 +174,15 @@
 # @suspended: guest is suspended (ACPI S3)
 #
 # @watchdog: the watchdog action is configured to pause and has been triggered
+#
+# @guest-panicked: the panicked action is configured to pause and has been
+# triggered.
 ##
 { 'enum': 'RunState',
   'data': [ 'debug', 'inmigrate', 'internal-error', 'io-error', 'paused',
             'postmigrate', 'prelaunch', 'finish-migrate', 'restore-vm',
-            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog' ] }
+            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog',
+            'guest-panicked' ] }
 
 ##
 # @SnapshotInfo
diff --git a/qmp.c b/qmp.c
index 5f1bed1..f5027f6 100644
--- a/qmp.c
+++ b/qmp.c
@@ -150,7 +150,8 @@ void qmp_cont(Error **errp)
     Error *local_err = NULL;
 
     if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-               runstate_check(RUN_STATE_SHUTDOWN)) {
+            runstate_check(RUN_STATE_SHUTDOWN) ||
+            runstate_check(RUN_STATE_GUEST_PANICKED)) {
         error_set(errp, QERR_RESET_REQUIRED);
         return;
     } else if (runstate_check(RUN_STATE_SUSPENDED)) {
diff --git a/vl.c b/vl.c
index 1d2edaa..5aae03f 100644
--- a/vl.c
+++ b/vl.c
@@ -533,6 +533,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_INMIGRATE, RUN_STATE_PAUSED },
+    { RUN_STATE_INMIGRATE, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
@@ -546,6 +547,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_POSTMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_POSTMIGRATE, RUN_STATE_PAUSED },
     { RUN_STATE_POSTMIGRATE, RUN_STATE_FINISH_MIGRATE },
+    { RUN_STATE_POSTMIGRATE, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_PRELAUNCH, RUN_STATE_RUNNING },
     { RUN_STATE_PRELAUNCH, RUN_STATE_FINISH_MIGRATE },
@@ -556,6 +558,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_RESTORE_VM, RUN_STATE_RUNNING },
     { RUN_STATE_RESTORE_VM, RUN_STATE_PAUSED },
+    { RUN_STATE_RESTORE_VM, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_RUNNING, RUN_STATE_DEBUG },
     { RUN_STATE_RUNNING, RUN_STATE_INTERNAL_ERROR },
@@ -566,6 +569,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
@@ -580,6 +584,10 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_WATCHDOG, RUN_STATE_RUNNING },
     { RUN_STATE_WATCHDOG, RUN_STATE_FINISH_MIGRATE },
 
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_RUNNING },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_PAUSED },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_FINISH_MIGRATE },
+
     { RUN_STATE_MAX, RUN_STATE_MAX },
 };
 
@@ -1950,7 +1958,8 @@ static bool main_loop_should_exit(void)
         qemu_system_reset(VMRESET_REPORT);
         resume_all_vcpus();
         if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
-            runstate_check(RUN_STATE_SHUTDOWN)) {
+            runstate_check(RUN_STATE_SHUTDOWN) ||
+            runstate_check(RUN_STATE_GUEST_PANICKED)) {
             bdrv_iterate(iostatus_bdrv_it, NULL);
             vm_start();
         }
-- 
1.8.0.1.240.ge8a1f5a

