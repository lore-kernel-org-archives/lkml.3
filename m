Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaLTUqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:46:50 -0500
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:26148
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751639AbaLTUqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:46:47 -0500
X-WSS-ID: 0NGWF1Q-08-D74-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, <linux-kernel@vger.kernel.org>,
        "John Bridgman" <John.Bridgman@amd.com>, <Alexander.Deucher@amd.com>
Subject: [PATCH 2/3] amdkfd: Track when amdkfd init is complete
Date: Sat, 20 Dec 2014 22:46:13 +0200
Message-ID: <1419108374-7020-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(89996001)(76176999)(106466001)(101416001)(21056001)(105586002)(19580395003)(87936001)(62966003)(77096005)(19580405001)(99396003)(84676001)(31966008)(50986999)(97736003)(46102003)(229853001)(64706001)(4396001)(107046002)(47776003)(2351001)(50466002)(86362001)(20776003)(92566001)(53416004)(50226001)(33646002)(36756003)(2950100001)(120916001)(68736005)(110136001)(48376002)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0201MB1087;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1087;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0201MB1087;
X-Forefront-PRVS: 0431F981D8
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1087;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new function to amdkfd, which returns 1 if the amdkfd
initialization function has completed, and 0 otherwise.

This is necessary for the case when amdkfd and radeon are both compiled inside
the kernel image (not as modules). In that case, radeon probes the existing GPU
before amdkfd is even loaded. When radeon encounters an AMD GPU, it will pass
that information to amdkfd. However, if amdkfd is not loaded than that call
will fail and when amdkfd is eventually loaded, it won't know about that GPU.

Even if that call is delayed to a later stage, we will still need to know
whether amdkfd has already been initialized.

Note that when the two modules are compiled as modules, this situation can't
occur as the kernel enforces the order of loading.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c | 9 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h   | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
index 236562f..848ebed 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -60,6 +60,13 @@ module_param(max_num_of_queues_per_process, int, 0444);
 MODULE_PARM_DESC(max_num_of_queues_per_process,
 	"Kernel cmdline parameter that defines the amdkfd maximum number of supported queues per process");
 
+static int amdkfd_init_completed;
+
+int amdkfd_is_init_completed(void)
+{
+	return amdkfd_init_completed;
+}
+
 bool kgd2kfd_init(unsigned interface_version,
 		  const struct kfd2kgd_calls *f2g,
 		  const struct kgd2kfd_calls **g2f)
@@ -128,6 +135,8 @@ static int __init kfd_module_init(void)
 
 	dev_info(kfd_device, "Initialized module\n");
 
+	amdkfd_init_completed = 1;
+
 	return 0;
 
 err_topology:
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index f9fb81e..01df7e6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -153,6 +153,8 @@ struct kfd_dev {
 	bool interrupts_active;
 };
 
+int amdkfd_is_init_completed(void);
+
 /* KGD2KFD callbacks */
 void kgd2kfd_exit(void);
 struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev);
-- 
2.1.0

