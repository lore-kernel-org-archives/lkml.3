Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaHEPd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:33:26 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:29516
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754830AbaHEPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:33:18 -0400
X-WSS-ID: 0N9UB7C-08-R58-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 21/23] amdkfd: Implement the Set Memory Policy IOCTL
Date: Tue, 5 Aug 2014 18:30:49 +0300
Message-ID: <1407252651-3539-22-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(19580395003)(83072002)(86362001)(104166001)(229853001)(81542001)(81342001)(87286001)(84676001)(44976005)(92726001)(97736001)(83322001)(68736004)(92566001)(85852003)(85306004)(19580405001)(88136002)(87936001)(89996001)(106466001)(95666004)(99396002)(105586002)(76176999)(50986999)(20776003)(101416001)(102836001)(64706001)(62966002)(74662001)(74502001)(79102001)(50466002)(46102001)(107046002)(77156001)(4396001)(21056001)(50226001)(33646002)(77096002)(47776003)(77982001)(76482001)(36756003)(31966008)(80022001)(48376002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 51 ++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index 17725f6..cc7ac28 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -35,6 +35,7 @@
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -310,7 +311,55 @@ static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void
 
 static long kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_set_memory_policy_args args;
+	struct kfd_dev *dev;
+	int err = 0;
+	struct kfd_process_device *pdd;
+	enum cache_policy default_policy, alternate_policy;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.default_policy != KFD_IOC_CACHE_POLICY_COHERENT
+	    && args.default_policy != KFD_IOC_CACHE_POLICY_NONCOHERENT) {
+		return -EINVAL;
+	}
+
+	if (args.alternate_policy != KFD_IOC_CACHE_POLICY_COHERENT
+	    && args.alternate_policy != KFD_IOC_CACHE_POLICY_NONCOHERENT) {
+		return -EINVAL;
+	}
+
+	dev = kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&p->mutex);
+
+	pdd = kfd_bind_process_to_device(dev, p);
+	if (IS_ERR(pdd) < 0) {
+		err = PTR_ERR(pdd);
+		goto out;
+	}
+
+	default_policy = (args.default_policy == KFD_IOC_CACHE_POLICY_COHERENT)
+			 ? cache_policy_coherent : cache_policy_noncoherent;
+
+	alternate_policy = (args.alternate_policy == KFD_IOC_CACHE_POLICY_COHERENT)
+			   ? cache_policy_coherent : cache_policy_noncoherent;
+
+	if (!dev->dqm->set_cache_memory_policy(dev->dqm,
+					 &pdd->qpd,
+					 default_policy,
+					 alternate_policy,
+					 (void __user *)args.alternate_aperture_base,
+					 args.alternate_aperture_size))
+		err = -EINVAL;
+
+out:
+	mutex_unlock(&p->mutex);
+
+	return err;
 }
 
 static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __user *arg)
-- 
1.9.1

