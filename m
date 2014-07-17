Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbaGQNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:33:57 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:39852
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932720AbaGQNdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:54 -0400
X-WSS-ID: 0N8UZ0E-07-C4M-02
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
        "Evgeny Pinchuk" <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 23/25] amdkfd: Implement the Get Clock Counters IOCTL
Date: Thu, 17 Jul 2014 16:29:30 +0300
Message-ID: <1405603773-32688-24-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(62966002)(19580395003)(36756003)(101416001)(77096002)(86362001)(46102001)(77156001)(50466002)(87936001)(74502001)(85306003)(33646002)(20776003)(21056001)(84676001)(19580405001)(4396001)(50226001)(87286001)(48376002)(106466001)(76176999)(95666004)(89996001)(80022001)(229853001)(92726001)(64706001)(81342001)(83322001)(68736004)(31966008)(107046002)(88136002)(79102001)(85852003)(104166001)(102836001)(76482001)(83072002)(81542001)(74662001)(97736001)(50986999)(77982001)(47776003)(93916002)(105586002)(92566001)(44976005)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
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
index 085bd91..72d8e79 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -315,7 +315,34 @@ out:
 
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

