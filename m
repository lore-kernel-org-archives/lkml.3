Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKHSuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:50:40 -0500
Received: from mail-bn1bn0102.outbound.protection.outlook.com ([157.56.110.102]:4873
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591AbaKHSuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:50:39 -0500
X-WSS-ID: 0NEQHOA-07-RIP-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 21/24] amdkfd: Implement the Set Memory Policy IOCTL
Date: Sat, 8 Nov 2014 20:50:04 +0200
Message-ID: <1415472608-3537-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(36756003)(104166001)(92726001)(48376002)(97736003)(50466002)(101416001)(92566001)(21056001)(44976005)(19580405001)(19580395003)(68736004)(102836001)(99396003)(76176999)(120916001)(50986999)(46102003)(31966008)(84676001)(89996001)(88136002)(64706001)(87936001)(87286001)(33646002)(77156002)(62966003)(77096003)(105586002)(229853001)(95666004)(106466001)(107046002)(20776003)(47776003)(4396001)(50226001)(93916002)(53416004)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 52 +++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index d342035..1020faf 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -35,6 +35,7 @@
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -345,7 +346,56 @@ static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p,
 static long kfd_ioctl_set_memory_policy(struct file *filep,
 				struct kfd_process *p, void __user *arg)
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
+	alternate_policy =
+		(args.alternate_policy == KFD_IOC_CACHE_POLICY_COHERENT)
+		   ? cache_policy_coherent : cache_policy_noncoherent;
+
+	if (!dev->dqm->set_cache_memory_policy(dev->dqm,
+				&pdd->qpd,
+				default_policy,
+				alternate_policy,
+				(void __user *)args.alternate_aperture_base,
+				args.alternate_aperture_size))
+		err = -EINVAL;
+
+out:
+	mutex_unlock(&p->mutex);
+
+	return err;
 }
 
 static long kfd_ioctl_get_clock_counters(struct file *filep,
-- 
2.1.0

