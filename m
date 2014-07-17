Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaGQNtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:49:06 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:37799
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932179AbaGQNtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:49:04 -0400
X-WSS-ID: 0N8UZ03-08-70U-02
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
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 21/25] amdkfd: Implement the create/destroy/update queue IOCTLs
Date: Thu, 17 Jul 2014 16:29:28 +0300
Message-ID: <1405603773-32688-22-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51234002)(92566001)(106466001)(87286001)(21056001)(105586002)(88136002)(229853001)(104166001)(92726001)(31966008)(89996001)(4396001)(107046002)(50226001)(83072002)(87936001)(79102001)(85852003)(77982001)(102836001)(101416001)(85306003)(86362001)(77096002)(33646002)(575784001)(84676001)(64706001)(93916002)(97736001)(20776003)(76176999)(80022001)(50986999)(99396002)(48376002)(81342001)(81542001)(19580395003)(46102001)(77156001)(62966002)(74502001)(19580405001)(44976005)(68736004)(74662001)(47776003)(95666004)(83322001)(76482001)(50466002)(36756003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 133 +++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |   8 ++
 2 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index d6580a6..a74693a 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -119,17 +119,144 @@ static int kfd_open(struct inode *inode, struct file *filep)
 
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
+	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(qptr_t))) {
+		pr_err("kfd: can't access read pointer");
+		return -EFAULT;
+	}
+
+	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(qptr_t))) {
+		pr_err("kfd: can't access write pointer");
+		return -EFAULT;
+	}
+
+	q_properties.is_interop = false;
+	q_properties.queue_percent = args.queue_percentage;
+	q_properties.priority = args.queue_priority;
+	q_properties.queue_address = args.ring_base_address;
+	q_properties.queue_size = args.ring_size;
+	q_properties.read_ptr = (qptr_t *) args.read_pointer_address;
+	q_properties.write_ptr = (qptr_t *) args.write_pointer_address;
+
+
+	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
+			"Queue Priority (%d, %d)\n"
+			"Queue Address (0x%llX, 0x%llX)\n"
+			"Queue Size (0x%llX, %u)\n"
+			"Queue r/w Pointers (0x%llX, 0x%llX)\n",
+			__func__,
+			q_properties.queue_percent, args.queue_percentage,
+			q_properties.priority, args.queue_priority,
+			q_properties.queue_address, args.ring_base_address,
+			q_properties.queue_size, args.ring_size,
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
+	args.doorbell_address = (uint64_t)q_properties.doorbell_ptr;
+
+	if (copy_to_user(arg, &args, sizeof(args))) {
+		err = -EFAULT;
+		goto err_copy_args_out;
+	}
+
+	mutex_unlock(&p->mutex);
+
+	pr_debug("kfd: queue id %d was created successfully.\n"
+		 "     ring buffer address == 0x%016llX\n"
+		 "     read ptr address    == 0x%016llX\n"
+		 "     write ptr address   == 0x%016llX\n"
+		 "     doorbell address    == 0x%016llX\n",
+			args.queue_id,
+			args.ring_base_address,
+			args.read_pointer_address,
+			args.write_pointer_address,
+			args.doorbell_address);
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
index 8a1de68..7ea0e81 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -418,7 +418,15 @@ struct process_queue_node {
 
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
 
-- 
1.9.1

