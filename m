Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaKHSyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:54:50 -0500
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:3045
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbaKHSyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:54:49 -0500
X-WSS-ID: 0NEQHV7-07-RKC-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 22/24] amdkfd: Implement the Get Clock Counters IOCTL
Date: Sat, 8 Nov 2014 20:54:31 +0200
Message-ID: <1415472874-4222-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(36756003)(102836001)(46102003)(48376002)(4396001)(107046002)(62966003)(92566001)(88136002)(53416004)(89996001)(120916001)(19580405001)(68736004)(93916002)(19580395003)(101416001)(77096003)(77156002)(50466002)(64706001)(50226001)(20776003)(33646002)(84676001)(105586002)(50986999)(86362001)(44976005)(104166001)(92726001)(21056001)(47776003)(31966008)(87936001)(229853001)(99396003)(97736003)(76176999)(87286001)(106466001)(95666004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 1020faf..473f8e1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -401,7 +401,34 @@ out:
 static long kfd_ioctl_get_clock_counters(struct file *filep,
 				struct kfd_process *p, void __user *arg)
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
2.1.0

