Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaHEPdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:33:24 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:6720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754777AbaHEPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:33:18 -0400
X-WSS-ID: 0N9UB79-07-3IL-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 20/23] amdkfd: Implement the create/destroy/update queue IOCTLs
Date: Tue, 5 Aug 2014 18:30:48 +0300
Message-ID: <1407252651-3539-21-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51234002)(199002)(189002)(47776003)(87936001)(36756003)(83322001)(44976005)(19580395003)(19580405001)(77982001)(64706001)(20776003)(87286001)(76482001)(80022001)(74662001)(104166001)(33646002)(229853001)(74502001)(86362001)(77096002)(50226001)(21056001)(62966002)(68736004)(101416001)(99396002)(92726001)(84676001)(107046002)(50986999)(31966008)(102836001)(77156001)(97736001)(92566001)(79102001)(48376002)(4396001)(106466001)(83072002)(46102001)(81542001)(85852003)(105586002)(50466002)(88136002)(81342001)(95666004)(89996001)(85306004)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

v3: remove use of internal typedefs
v3: fix debug prints
v3: add checks for parameters
v3: use doorbell address from user

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        | 182 ++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |   8 +
 .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |   5 +-
 include/uapi/linux/kfd_ioctl.h                     |   7 +-
 4 files changed, 196 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index c42f53b..17725f6 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -119,17 +119,193 @@ static int kfd_open(struct inode *inode, struct file *filep)
 
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
+	if (!is_power_of_2(args.ring_size)) {
+		pr_err("kfd: ring size must be between 0 to KFD_MAX_QUEUE_PERCENTAGE\n");
+		return -EINVAL;
+	}
+
+	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(uint32_t))) {
+		pr_err("kfd: can't access read pointer\n");
+		return -EFAULT;
+	}
+
+	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(uint32_t))) {
+		pr_err("kfd: can't access write pointer\n");
+		return -EFAULT;
+	}
+
+	q_properties.is_interop = false;
+	q_properties.queue_percent = args.queue_percentage;
+	q_properties.priority = args.queue_priority;
+	q_properties.queue_address = args.ring_base_address;
+	q_properties.queue_size = args.ring_size;
+	q_properties.read_ptr = (uint32_t *) args.read_pointer_address;
+	q_properties.write_ptr = (uint32_t *) args.write_pointer_address;
+
+
+	pr_debug("kfd: creating queue ioctl\n");
+
+	pr_debug("Queue Percentage (%d, %d)\n",
+			q_properties.queue_percent, args.queue_percentage);
+
+	pr_debug("Queue Priority (%d, %d)\n",
+			q_properties.priority, args.queue_priority);
+
+	pr_debug("Queue Address (0x%llX, 0x%llX)\n",
+			q_properties.queue_address, args.ring_base_address);
+
+	pr_debug("Queue Size (0x%llX, %u)\n",
+			q_properties.queue_size, args.ring_size);
+
+	pr_debug("Queue r/w Pointers (0x%llX, 0x%llX)\n",
+			(uint64_t) q_properties.read_ptr,
+			(uint64_t) q_properties.write_ptr);
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
+	if (!is_power_of_2(args.ring_size)) {
+		pr_err("kfd: ring size must be between 0 to KFD_MAX_QUEUE_PERCENTAGE\n");
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
index 7fc24b3..587b44b 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
@@ -257,7 +257,10 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
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

