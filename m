Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaIXVE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:04:27 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:44201
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576AbaIXVET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:04:19 -0400
X-WSS-ID: 0NCFB7C-08-8M8-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 22/23] amdkfd: Implement the Get Clock Counters IOCTL
Date: Wed, 24 Sep 2014 23:45:36 +0300
Message-ID: <1411591537-31636-23-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(106466001)(90102001)(21056001)(105586002)(47776003)(76482002)(64706001)(101416001)(50986999)(4396001)(107046002)(229853001)(99396003)(87936001)(62966002)(92566001)(102836001)(50226001)(19580405001)(104166001)(20776003)(31966008)(74502003)(77982003)(92726001)(50466002)(89996001)(86362001)(36756003)(77156001)(80022003)(68736004)(79102003)(84676001)(81542003)(48376002)(85306004)(95666004)(33646002)(93916002)(85852003)(81342003)(87286001)(97736003)(44976005)(19580395003)(74662003)(88136002)(83322001)(76176999)(83072002)(120916001)(77096002)(10300001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB189;
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
index d1cc6d8..1e4b731 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -373,7 +373,34 @@ out:
 
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

