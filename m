Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaHEPeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:34:22 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:17744
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755949AbaHEPdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:33:23 -0400
X-WSS-ID: 0N9UB7H-07-3J9-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 22/23] amdkfd: Implement the Get Clock Counters IOCTL
Date: Tue, 5 Aug 2014 18:30:50 +0300
Message-ID: <1407252651-3539-23-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(62966002)(83072002)(76176999)(50986999)(74662001)(20776003)(92726001)(31966008)(85306004)(79102001)(104166001)(81542001)(87936001)(21056001)(19580395003)(88136002)(19580405001)(83322001)(80022001)(89996001)(76482001)(84676001)(85852003)(46102001)(64706001)(77982001)(92566001)(47776003)(74502001)(105586002)(33646002)(86362001)(77156001)(102836001)(77096002)(229853001)(95666004)(107046002)(106466001)(68736004)(99396002)(81342001)(87286001)(50226001)(44976005)(50466002)(4396001)(36756003)(48376002)(101416001)(97736001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB036;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index cc7ac28..eba5b5d 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -364,7 +364,34 @@ out:
 
 static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_get_clock_counters_args args;
+	struct kfd_dev *dev;
+	struct timespec time;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	/* Reading GPU clock counter from KGD */
+	args.gpu_clock_counter = kfd2kgd->get_gpu_clock_counter(dev->kgd);
+
+	/* No access to rdtsc. Using raw monotonic time */
+	getrawmonotonic(&time);
+	args.cpu_clock_counter = (uint64_t)timespec_to_ns(&time);
+
+	get_monotonic_boottime(&time);
+	args.system_clock_counter = (uint64_t)timespec_to_ns(&time);
+
+	/* Since the counter is in nano-seconds we use 1GHz frequency */
+	args.system_clock_freq = 1000000000;
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 0;
 }
 
 
-- 
1.9.1

