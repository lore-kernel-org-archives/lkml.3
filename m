Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaIXVFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:05:47 -0400
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:46336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792AbaIXVFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:42 -0400
X-WSS-ID: 0NCFB75-08-8LU-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-api@vger.kernel.org>
Subject: [PATCH v4 20/23] amdkfd: Implement the create/destroy/update queue IOCTLs
Date: Wed, 24 Sep 2014 23:45:34 +0300
Message-ID: <1411591537-31636-21-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51234002)(189002)(199003)(92566001)(92726001)(33646002)(90102001)(85852003)(83072002)(102836001)(88136002)(89996001)(36756003)(77156001)(101416001)(120916001)(20776003)(64706001)(31966008)(99396003)(47776003)(10300001)(62966002)(104166001)(97736003)(229853001)(93916002)(87286001)(107046002)(87936001)(85306004)(86362001)(77096002)(106466001)(76176999)(44976005)(83322001)(50466002)(50226001)(4396001)(48376002)(77982003)(19580395003)(50986999)(84676001)(19580405001)(68736004)(105586002)(21056001)(74662003)(80022003)(79102003)(81342003)(74502003)(81542003)(46102003)(76482002)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

v3: Removed the use of internal typedefs, fixed debug prints, added checks
for parameters and moved to using doorbell address from user

v4: Extracted some of the code in the create queue ioctl to a different
function that may be also called from other ioctls in the future. Also fixed
the check of the ring size argument.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        | 191 ++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |   8 +
 .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |   5 +-
 include/uapi/linux/kfd_ioctl.h                     |   7 +-
 4 files changed, 205 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index c42f53b..ac3146d 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -117,19 +117,204 @@ static int kfd_open(struct inode *inode, struct file *filep)
 	return 0;
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
+	return 0;
+}
+
 static long kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *arg)
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
+	err = pqm_create_queue(&p->pqm, dev, filep, &q_properties, 0, KFD_QUEUE_TYPE_COMPUTE, &queue_id);
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
 
 static int kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *arg)
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
 
 static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void __user *arg)
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
+	pr_debug("kfd: updating queue id %d for PASID %d\n", args.queue_id, p->pasid);
+
+	mutex_lock(&p->mutex);
+
+	retval = pqm_update_queue(&p->pqm, args.queue_id, &properties);
+
+	mutex_unlock(&p->mutex);
+
+	return retval;
 }
 
 static long kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 6c656d8..0e3e18f 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -513,7 +513,15 @@ struct process_queue_node {
 
 int pqm_init(struct process_queue_manager *pqm, struct kfd_process *p);
 void pqm_uninit(struct process_queue_manager *pqm);
+int pqm_create_queue(struct process_queue_manager *pqm,
+			    struct kfd_dev *dev,
+			    struct file *f,
+			    struct queue_properties *properties,
+			    unsigned int flags,
+			    enum kfd_queue_type type,
+			    unsigned int *qid);
 int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid);
+int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct queue_properties *p);
 
 /* Packet Manager */
 
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
index 5bd6a5d..780c749 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
@@ -264,7 +264,10 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 	pr_debug("kfd: In Func %s\n", __func__);
 
 	pqn = get_queue_by_qid(pqm, qid);
-	BUG_ON(!pqn);
+	if (pqn == NULL) {
+		pr_err("kfd: queue id does not match any known queue\n");
+		return -EINVAL;
+	}
 
 	dev = NULL;
 	if (pqn->kq)
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index a06e021..1ce8302 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -34,8 +34,11 @@ struct kfd_ioctl_get_version_args {
 };
 
 /* For kfd_ioctl_create_queue_args.queue_type. */
-#define KFD_IOC_QUEUE_TYPE_COMPUTE   0
-#define KFD_IOC_QUEUE_TYPE_SDMA      1
+#define KFD_IOC_QUEUE_TYPE_COMPUTE	0
+#define KFD_IOC_QUEUE_TYPE_SDMA		1
+
+#define KFD_MAX_QUEUE_PERCENTAGE	100
+#define KFD_MAX_QUEUE_PRIORITY		15
 
 struct kfd_ioctl_create_queue_args {
 	uint64_t ring_base_address;	/* to KFD */
-- 
1.9.1

