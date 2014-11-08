Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaKHSn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:43:57 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:8000
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbaKHSnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:43:55 -0500
X-WSS-ID: 0NEQHD4-07-RG8-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        "Andrew Lewycky" <Andrew.Lewycky@amd.com>
Subject: [PATCH v5 15/24] amdkfd: Add module parameter of scheduling policy
Date: Sat, 8 Nov 2014 20:37:36 +0200
Message-ID: <1415471865-1893-16-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(21056001)(48376002)(101416001)(102836001)(105586002)(53416004)(50466002)(31966008)(99396003)(95666004)(4396001)(77096003)(77156002)(229853001)(106466001)(50226001)(107046002)(62966003)(36756003)(87936001)(87286001)(89996001)(104166001)(46102003)(120916001)(97736003)(88136002)(20776003)(84676001)(76176999)(47776003)(68736004)(50986999)(33646002)(86362001)(93916002)(92726001)(92566001)(19580405001)(19580395003)(44976005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
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

v5: Set default sched_policy to HWS as it is now supported by firmware

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c | 18 +++++++++++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h   | 30 ++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
index 56a71d8..0858dce 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -29,10 +29,10 @@
 #define KFD_DRIVER_AUTHOR	"AMD Inc. and others"
 
 #define KFD_DRIVER_DESC		"Standalone HSA driver for AMD's GPUs"
-#define KFD_DRIVER_DATE		"20140804"
+#define KFD_DRIVER_DATE		"20140807"
 #define KFD_DRIVER_MAJOR	0
-#define KFD_DRIVER_MINOR	6
-#define KFD_DRIVER_PATCHLEVEL	4
+#define KFD_DRIVER_MINOR	8
+#define KFD_DRIVER_PATCHLEVEL	0
 
 const struct kfd2kgd_calls *kfd2kgd;
 static const struct kgd2kfd_calls kgd2kfd = {
@@ -45,6 +45,11 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.resume		= kgd2kfd_resume,
 };
 
+int sched_policy = KFD_SCHED_POLICY_HWS;
+module_param(sched_policy, int, 0444);
+MODULE_PARM_DESC(sched_policy,
+	"Kernel cmdline parameter that defines the amdkfd scheduling policy");
+
 int max_num_of_processes = KFD_MAX_NUM_OF_PROCESSES_DEFAULT;
 module_param(max_num_of_processes, int, 0444);
 MODULE_PARM_DESC(max_num_of_processes,
@@ -88,6 +93,13 @@ static int __init kfd_module_init(void)
 	kfd2kgd = NULL;
 
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
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index bba3c2a..32bca8a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -69,6 +69,36 @@ extern int max_num_of_queues_per_process;
 
 #define KFD_KERNEL_QUEUE_SIZE 2048
 
+/* Kernel module parameter to specify the scheduling policy */
+extern int sched_policy;
+
+/**
+ * enum kfd_sched_policy
+ *
+ * @KFD_SCHED_POLICY_HWS: H/W scheduling policy known as command processor (cp)
+ * scheduling. In this scheduling mode we're using the firmware code to
+ * schedule the user mode queues and kernel queues such as HIQ and DIQ.
+ * the HIQ queue is used as a special queue that dispatches the configuration
+ * to the cp and the user mode queues list that are currently running.
+ * the DIQ queue is a debugging queue that dispatches debugging commands to the
+ * firmware.
+ * in this scheduling mode user mode queues over subscription feature is
+ * enabled.
+ *
+ * @KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION: The same as above but the over
+ * subscription feature disabled.
+ *
+ * @KFD_SCHED_POLICY_NO_HWS: no H/W scheduling policy is a mode which directly
+ * set the command processor registers and sets the queues "manually". This
+ * mode is used *ONLY* for debugging proposes.
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
2.1.0

