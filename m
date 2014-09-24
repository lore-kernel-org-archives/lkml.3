Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaIXVF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:05:26 -0400
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:54624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752813AbaIXVFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:18 -0400
X-WSS-ID: 0NCFB6C-07-T9X-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 15/23] amdkfd: Add module parameter of scheduling policy
Date: Wed, 24 Sep 2014 23:45:29 +0300
Message-ID: <1411591537-31636-16-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(87286001)(44976005)(92726001)(77982003)(64706001)(85306004)(85852003)(81542003)(77156001)(21056001)(84676001)(102836001)(106466001)(83072002)(19580405001)(101416001)(107046002)(62966002)(19580395003)(36756003)(87936001)(93916002)(92566001)(86362001)(81342003)(83322001)(79102003)(46102003)(50466002)(89996001)(90102001)(47776003)(77096002)(68736004)(88136002)(76176999)(97736003)(50986999)(48376002)(95666004)(229853001)(74662003)(76482002)(74502003)(104166001)(80022003)(33646002)(20776003)(120916001)(31966008)(10300001)(4396001)(99396003)(105586002)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adds a new parameter to the amdkfd driver. This parameter enables
the user to select the scheduling policy of the CP. The choices are:

* CP Scheduling with support for over-subscription
* CP Scheduling without support for over-subscription
* Without CP Scheduling

Note that the third option (Without CP scheduling) is only for debug purposes
and bringup of new H/W. As such, it is _not_ guaranteed to work at all times on
all H/W versions.

v3: Fixed description of parameter, changed the permissions to read_only, added
a verification of the value and added documentation

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_module.c | 12 ++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h   | 29 +++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
index a31bf03..5c58031 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
@@ -45,6 +45,11 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.resume		= kgd2kfd_resume,
 };
 
+int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
+module_param(sched_policy, int, 0444);
+MODULE_PARM_DESC(sched_policy,
+	"Kernel cmdline parameter that defines the amdkfd scheduling policy");
+
 int max_num_of_processes = KFD_MAX_NUM_OF_PROCESSES_DEFAULT;
 module_param(max_num_of_processes, int, 0444);
 MODULE_PARM_DESC(max_num_of_processes,
@@ -79,6 +84,13 @@ static int __init kfd_module_init(void)
 	int err;
 
 	/* Verify module parameters */
+	if ((sched_policy < KFD_SCHED_POLICY_HWS) ||
+		(sched_policy > KFD_SCHED_POLICY_NO_HWS)) {
+		pr_err("kfd: sched_policy has invalid value\n");
+		return -1;
+	}
+
+	/* Verify module parameters */
 	if ((max_num_of_processes < 0) ||
 		(max_num_of_processes > KFD_MAX_NUM_OF_PROCESSES)) {
 		pr_err("kfd: max_num_of_processes must be between 0 to KFD_MAX_NUM_OF_PROCESSES\n");
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 66980df..5835d07 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -65,6 +65,35 @@ extern int max_num_of_queues_per_process;
 #define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS_DEFAULT 128
 #define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS 1024
 
+/* Kernel module parameter to specify the scheduling policy */
+extern int sched_policy;
+
+/**
+ * enum kfd_sched_policy
+ *
+ * @KFD_SCHED_POLICY_HWS: H/W scheduling policy known as command processor (cp)
+ * scheduling. In this scheduling mode we're using the firmware code to schedule
+ * the user mode queues and kernel queues such as HIQ and DIQ.
+ * the HIQ queue is used as a special queue that dispatches the configuration to
+ * the cp and the user mode queues list that are currently running.
+ * the DIQ queue is a debugging queue that dispatches debugging commands to the
+ * firmware.
+ * in this scheduling mode user mode queues over subscription feature is enabled.
+ *
+ * @KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION: The same as above but the over
+ * subscription feature disabled.
+ *
+ * @KFD_SCHED_POLICY_NO_HWS: no H/W scheduling policy is a mode which directly
+ * set the command processor registers and sets the queues "manually". This mode
+ * is used *ONLY* for debugging proposes.
+ *
+ */
+enum kfd_sched_policy {
+	KFD_SCHED_POLICY_HWS = 0,
+	KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION,
+	KFD_SCHED_POLICY_NO_HWS
+};
+
 enum cache_policy {
 	cache_policy_coherent,
 	cache_policy_noncoherent
-- 
1.9.1

