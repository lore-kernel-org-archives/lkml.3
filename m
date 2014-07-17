Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbaGQNdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:33:36 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:39207
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932893AbaGQNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:30 -0400
X-WSS-ID: 0N8UYZ5-07-C2J-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 16/25] amdkfd: Add module parameter of scheduling policy
Date: Thu, 17 Jul 2014 16:29:23 +0300
Message-ID: <1405603773-32688-17-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(101416001)(84676001)(92566001)(83072002)(20776003)(76176999)(104166001)(102836001)(68736004)(31966008)(76482001)(46102001)(93916002)(33646002)(106466001)(95666004)(97736001)(50986999)(80022001)(92726001)(50226001)(47776003)(62966002)(81342001)(79102001)(21056001)(86362001)(85306003)(77096002)(87286001)(64706001)(74502001)(87936001)(229853001)(36756003)(77156001)(81542001)(77982001)(85852003)(4396001)(48376002)(50466002)(107046002)(19580405001)(83322001)(44976005)(89996001)(19580395003)(105586002)(74662001)(99396002)(88136002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adds a new parameter to the amdkfd driver. This parameter enables the user to select the scheduling policy of the CP. The choices are:

* CP Scheduling with support for over-subscription
* CP Scheduling without support for over-subscription
* Without CP Scheduling

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_module.c | 4 ++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h   | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
index dc08f51..fe5e39d 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
@@ -46,6 +46,10 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.resume		= kgd2kfd_resume,
 };
 
+int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
+module_param(sched_policy, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(sched_policy, "Kernel cmdline parameter define the kfd scheduling policy");
+
 bool kgd2kfd_init(unsigned interface_version,
 		  const struct kfd2kgd_calls *f2g,
 		  const struct kgd2kfd_calls **g2f)
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 25f23c5..8be07a1 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -64,6 +64,15 @@
 /* Macro for allocating structures */
 #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
 
+/* Kernel module parameter to specify the scheduling policy */
+extern int sched_policy;
+
+enum kfd_sched_policy {
+	KFD_SCHED_POLICY_HWS = 0,
+	KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION,
+	KFD_SCHED_POLICY_NO_HWS
+};
+
 /*
  * Large enough to hold the maximum usable pasid + 1.
  * It must also be able to store the number of doorbells
-- 
1.9.1

