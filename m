Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaIXVG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:06:59 -0400
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:19515
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753379AbaIXVFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:07 -0400
X-WSS-ID: 0NCFB78-08-8LZ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 21/23] amdkfd: Implement the Set Memory Policy IOCTL
Date: Wed, 24 Sep 2014 23:45:35 +0300
Message-ID: <1411591537-31636-22-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(92566001)(92726001)(33646002)(90102001)(85852003)(83072002)(102836001)(88136002)(89996001)(36756003)(77156001)(101416001)(120916001)(20776003)(64706001)(31966008)(99396003)(47776003)(10300001)(62966002)(104166001)(97736003)(229853001)(93916002)(87286001)(107046002)(87936001)(85306004)(86362001)(77096002)(106466001)(76176999)(44976005)(83322001)(50466002)(50226001)(4396001)(48376002)(77982003)(19580395003)(50986999)(84676001)(19580405001)(68736004)(105586002)(21056001)(74662003)(80022003)(79102003)(81342003)(74502003)(81542003)(46102003)(76482002)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 03449D5DD1
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
index ac3146d..d1cc6d8 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -35,6 +35,7 @@
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -319,7 +320,55 @@ static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void
 
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

