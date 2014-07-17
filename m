Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaGQNdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:33:54 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:27702
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932720AbaGQNdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:51 -0400
X-WSS-ID: 0N8UZ0A-07-C4C-02
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
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 22/25] amdkfd: Implement the Set Memory Policy IOCTL
Date: Thu, 17 Jul 2014 16:29:29 +0300
Message-ID: <1405603773-32688-23-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(44976005)(31966008)(85306003)(48376002)(64706001)(95666004)(81542001)(68736004)(77156001)(99396002)(47776003)(20776003)(92566001)(101416001)(77096002)(80022001)(36756003)(77982001)(50466002)(105586002)(4396001)(85852003)(92726001)(89996001)(74502001)(81342001)(76482001)(97736001)(19580395003)(74662001)(83322001)(19580405001)(104166001)(106466001)(87936001)(87286001)(229853001)(76176999)(21056001)(50986999)(83072002)(107046002)(50226001)(84676001)(33646002)(62966002)(46102001)(86362001)(102836001)(79102001)(93916002)(88136002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
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
index a74693a..085bd91 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -35,6 +35,7 @@
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -261,7 +262,55 @@ static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void
 
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

