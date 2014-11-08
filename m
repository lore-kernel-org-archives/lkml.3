Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaKHSpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:45:30 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:45024
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753872AbaKHSpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:45:25 -0500
X-WSS-ID: 0NEQHFK-07-RGW-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 20/24] amdkfd: Implement the create/destroy/update queue IOCTLs
Date: Sat, 8 Nov 2014 20:37:41 +0200
Message-ID: <1415471865-1893-21-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(51234002)(53416004)(19580405001)(19580395003)(44976005)(93916002)(68736004)(50986999)(76176999)(46102003)(50226001)(4396001)(36756003)(95666004)(84676001)(31966008)(92566001)(89996001)(105586002)(99396003)(106466001)(86362001)(88136002)(92726001)(77096003)(107046002)(50466002)(101416001)(102836001)(48376002)(77156002)(47776003)(64706001)(21056001)(20776003)(87936001)(97736003)(87286001)(120916001)(104166001)(229853001)(62966003)(33646002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0201MB1008;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1008;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1008;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1008;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: Removed the use of internal typedefs, fixed debug prints, added checks
    for parameters and moved to using doorbell address from user

v4: Extracted some of the code in the create queue ioctl to a different
    function that may be also called from other ioctls in the future.
    Also fixed the check of the ring size argument.

v5:

Add support for AQL queues creation to enable working with open-source HSA
runtime

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 205 ++++++++++++++++++++++++++++++-
 1 file changed, 202 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 58441cd..d342035 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -125,22 +125,221 @@ static long kfd_ioctl_get_version(struct file *filep, struct kfd_process *p,
 	return -ENODEV;
 }
 
+static int set_queue_properties_from_user(struct queue_properties *q_properties,
+				struct kfd_ioctl_create_queue_args *args)
+{
+	if (args->queue_percentage > KFD_MAX_QUEUE_PERCENTAGE) {
+		pr_err("kfd: queue percentage must be between 0 to KFD_MAX_QUEUE_PERCENTAGE\n");
+		return -EINVAL;
+	}
+
+	if (args->queue_priority > KFD_MAX_QUEUE_PRIORITY) {
+		pr_err("kfd: queue priority must be between 0 to KFD_MAX_QUEUE_PRIORITY\n");
+		return -EINVAL;
+	}
+
+	if ((args->ring_base_address) &&
+		(!access_ok(VERIFY_WRITE, args->ring_base_address, sizeof(uint64_t)))) {
+		pr_err("kfd: can't access ring base address\n");
+		return -EFAULT;
+	}
+
+	if (!is_power_of_2(args->ring_size) && (args->ring_size != 0)) {
+		pr_err("kfd: ring size must be a power of 2 or 0\n");
+		return -EINVAL;
+	}
+
+	if (!access_ok(VERIFY_WRITE, args->read_pointer_address, sizeof(uint32_t))) {
+		pr_err("kfd: can't access read pointer\n");
+		return -EFAULT;
+	}
+
+	if (!access_ok(VERIFY_WRITE, args->write_pointer_address, sizeof(uint32_t))) {
+		pr_err("kfd: can't access write pointer\n");
+		return -EFAULT;
+	}
+
+	q_properties->is_interop = false;
+	q_properties->queue_percent = args->queue_percentage;
+	q_properties->priority = args->queue_priority;
+	q_properties->queue_address = args->ring_base_address;
+	q_properties->queue_size = args->ring_size;
+	q_properties->read_ptr = (uint32_t *) args->read_pointer_address;
+	q_properties->write_ptr = (uint32_t *) args->write_pointer_address;
+	if (args->queue_type == KFD_IOC_QUEUE_TYPE_COMPUTE ||
+		args->queue_type == KFD_IOC_QUEUE_TYPE_COMPUTE_AQL)
+		q_properties->type = KFD_QUEUE_TYPE_COMPUTE;
+	else
+		return -ENOTSUPP;
+
+	if (args->queue_type == KFD_IOC_QUEUE_TYPE_COMPUTE_AQL)
+		q_properties->format = KFD_QUEUE_FORMAT_AQL;
+	else
+		q_properties->format = KFD_QUEUE_FORMAT_PM4;
+
+	pr_debug("Queue Percentage (%d, %d)\n",
+			q_properties->queue_percent, args->queue_percentage);
+
+	pr_debug("Queue Priority (%d, %d)\n",
+			q_properties->priority, args->queue_priority);
+
+	pr_debug("Queue Address (0x%llX, 0x%llX)\n",
+			q_properties->queue_address, args->ring_base_address);
+
+	pr_debug("Queue Size (0x%llX, %u)\n",
+			q_properties->queue_size, args->ring_size);
+
+	pr_debug("Queue r/w Pointers (0x%llX, 0x%llX)\n",
+			(uint64_t) q_properties->read_ptr,
+			(uint64_t) q_properties->write_ptr);
+
+	pr_debug("Queue Format (%d)\n", q_properties->format);
+
+	return 0;
+}
+
 static long kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 					void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_create_queue_args args;
+	struct kfd_dev *dev;
+	int err = 0;
+	unsigned int queue_id;
+	struct kfd_process_device *pdd;
+	struct queue_properties q_properties;
+
+	memset(&q_properties, 0, sizeof(struct queue_properties));
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	pr_debug("kfd: creating queue ioctl\n");
+
+	err = set_queue_properties_from_user(&q_properties, &args);
+	if (err)
+		return err;
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
+		goto err_bind_process;
+	}
+
+	pr_debug("kfd: creating queue for PASID %d on GPU 0x%x\n",
+			p->pasid,
+			dev->id);
+
+	err = pqm_create_queue(&p->pqm, dev, filep, &q_properties, 0,
+				KFD_QUEUE_TYPE_COMPUTE, &queue_id);
+	if (err != 0)
+		goto err_create_queue;
+
+	args.queue_id = queue_id;
+
+	/* Return gpu_id as doorbell offset for mmap usage */
+	args.doorbell_offset = args.gpu_id << PAGE_SHIFT;
+
+	if (copy_to_user(arg, &args, sizeof(args))) {
+		err = -EFAULT;
+		goto err_copy_args_out;
+	}
+
+	mutex_unlock(&p->mutex);
+
+	pr_debug("kfd: queue id %d was created successfully\n", args.queue_id);
+
+	pr_debug("ring buffer address == 0x%016llX\n",
+			args.ring_base_address);
+
+	pr_debug("read ptr address    == 0x%016llX\n",
+			args.read_pointer_address);
+
+	pr_debug("write ptr address   == 0x%016llX\n",
+			args.write_pointer_address);
+
+	return 0;
+
+err_copy_args_out:
+	pqm_destroy_queue(&p->pqm, queue_id);
+err_create_queue:
+err_bind_process:
+	mutex_unlock(&p->mutex);
+	return err;
 }
 
 static int kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p,
 					void __user *arg)
 {
-	return -ENODEV;
+	int retval;
+	struct kfd_ioctl_destroy_queue_args args;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	pr_debug("kfd: destroying queue id %d for PASID %d\n",
+				args.queue_id,
+				p->pasid);
+
+	mutex_lock(&p->mutex);
+
+	retval = pqm_destroy_queue(&p->pqm, args.queue_id);
+
+	mutex_unlock(&p->mutex);
+	return retval;
 }
 
 static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p,
 					void __user *arg)
 {
-	return -ENODEV;
+	int retval;
+	struct kfd_ioctl_update_queue_args args;
+	struct queue_properties properties;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.queue_percentage > KFD_MAX_QUEUE_PERCENTAGE) {
+		pr_err("kfd: queue percentage must be between 0 to KFD_MAX_QUEUE_PERCENTAGE\n");
+		return -EINVAL;
+	}
+
+	if (args.queue_priority > KFD_MAX_QUEUE_PRIORITY) {
+		pr_err("kfd: queue priority must be between 0 to KFD_MAX_QUEUE_PRIORITY\n");
+		return -EINVAL;
+	}
+
+	if ((args.ring_base_address) &&
+		(!access_ok(VERIFY_WRITE, args.ring_base_address, sizeof(uint64_t)))) {
+		pr_err("kfd: can't access ring base address\n");
+		return -EFAULT;
+	}
+
+	if (!is_power_of_2(args.ring_size) && (args.ring_size != 0)) {
+		pr_err("kfd: ring size must be a power of 2 or 0\n");
+		return -EINVAL;
+	}
+
+	properties.queue_address = args.ring_base_address;
+	properties.queue_size = args.ring_size;
+	properties.queue_percent = args.queue_percentage;
+	properties.priority = args.queue_priority;
+
+	pr_debug("kfd: updating queue id %d for PASID %d\n",
+			args.queue_id, p->pasid);
+
+	mutex_lock(&p->mutex);
+
+	retval = pqm_update_queue(&p->pqm, args.queue_id, &properties);
+
+	mutex_unlock(&p->mutex);
+
+	return retval;
 }
 
 static long kfd_ioctl_set_memory_policy(struct file *filep,
-- 
2.1.0

