Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3B1MNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:13:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab3B1MNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:13:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355068800"; 
   d="scan'208";a="6787329"
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
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v13 4/8] add a new runstate: RUN_STATE_GUEST_PANICKED
Date: Thu, 28 Feb 2013 20:13:15 +0800
Message-Id: <ab47cb1ef5a962848b2390d5b602b36aca1f149a.1362051582.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1362051581.git.hutao@cn.fujitsu.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:20,
	Serialize complete at 2013/02/28 20:12:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guest will be in this state when it is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 migration.c      |  1 +
 qapi-schema.json |  6 +++++-
 qmp.c            |  3 ++-
 vl.c             | 11 ++++++++++-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/migration.c b/migration.c
index c29830e..fa17b82 100644
--- a/migration.c
+++ b/migration.c
@@ -698,6 +698,7 @@ static void *buffered_file_thread(void *opaque)
                 int64_t start_time, end_time;
 
                 DPRINTF("done iterating\n");
+                save_run_state();
                 start_time = qemu_get_clock_ms(rt_clock);
                 qemu_system_wakeup_request(QEMU_WAKEUP_REASON_OTHER);
                 if (old_vm_running) {
diff --git a/qapi-schema.json b/qapi-schema.json
index 28b070f..8f1d138 100644
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
index 3d08e1a..51d4922 100644
--- a/vl.c
+++ b/vl.c
@@ -536,6 +536,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_INMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_INMIGRATE, RUN_STATE_PAUSED },
+    { RUN_STATE_INMIGRATE, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_RUNNING },
     { RUN_STATE_INTERNAL_ERROR, RUN_STATE_FINISH_MIGRATE },
@@ -549,6 +550,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_POSTMIGRATE, RUN_STATE_RUNNING },
     { RUN_STATE_POSTMIGRATE, RUN_STATE_PAUSED },
     { RUN_STATE_POSTMIGRATE, RUN_STATE_FINISH_MIGRATE },
+    { RUN_STATE_POSTMIGRATE, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_PRELAUNCH, RUN_STATE_RUNNING },
     { RUN_STATE_PRELAUNCH, RUN_STATE_FINISH_MIGRATE },
@@ -559,6 +561,7 @@ static const RunStateTransition runstate_transitions_def[] = {
 
     { RUN_STATE_RESTORE_VM, RUN_STATE_RUNNING },
     { RUN_STATE_RESTORE_VM, RUN_STATE_PAUSED },
+    { RUN_STATE_RESTORE_VM, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_RUNNING, RUN_STATE_DEBUG },
     { RUN_STATE_RUNNING, RUN_STATE_INTERNAL_ERROR },
@@ -569,6 +572,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
     { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
     { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
+    { RUN_STATE_RUNNING, RUN_STATE_GUEST_PANICKED },
 
     { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
 
@@ -583,6 +587,10 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_WATCHDOG, RUN_STATE_RUNNING },
     { RUN_STATE_WATCHDOG, RUN_STATE_FINISH_MIGRATE },
 
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_RUNNING },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_PAUSED },
+    { RUN_STATE_GUEST_PANICKED, RUN_STATE_FINISH_MIGRATE },
+
     { RUN_STATE_MAX, RUN_STATE_MAX },
 };
 
@@ -2001,7 +2009,8 @@ static bool main_loop_should_exit(void)
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
1.8.1.4

