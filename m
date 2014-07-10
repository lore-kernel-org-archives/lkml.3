Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaGJWFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:05:38 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57080 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaGJV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:03 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 50/83] hsa/radeon: Add module parameter of scheduling policy
Date: Fri, 11 Jul 2014 00:54:06 +0300
Message-Id: <1405029279-6894-22-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adds a new parameter to the KFD module. This parameter enables the
user to select the scheduling policy of the CP. The choices are:

* CP Scheduling with support for over-subscription
* CP Scheduling without support for over-subscription
* Without CP Scheduling

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_module.c |  5 +++
 drivers/gpu/hsa/radeon/kfd_priv.h   | 65 +++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index a03743a..e8bb67c 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/notifier.h>
+#include <linux/moduleparam.h>
 
 #include "kfd_priv.h"
 
@@ -43,6 +44,10 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.resume		= kgd2kfd_resume,
 };
 
+int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
+module_param(sched_policy, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(sched_policy, "Kernel comline parameter define the kfd scheduling policy");
+
 bool kgd2kfd_init(unsigned interface_version,
 		  const struct kfd2kgd_calls *f2g,
 		  const struct kgd2kfd_calls **g2f)
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 3a5cecf..b3889aa 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -70,6 +70,15 @@ struct kfd_scheduler_class;
 /* Macro for allocating structures */
 #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
 
+/* Kernel module parameter to specify the scheduling policy */
+extern int sched_policy;
+
+enum kfd_sched_policy {
+	KFD_SCHED_POLICY_HWS = 0,
+	KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION,
+	KFD_SCHED_POLICY_NO_HWS
+};
+
 /* Large enough to hold the maximum usable pasid + 1.
 ** It must also be able to store the number of doorbells reported by a KFD device. */
 typedef unsigned int pasid_t;
@@ -243,6 +252,51 @@ enum KFD_MQD_TYPE {
 	KFD_MQD_TYPE_MAX
 };
 
+struct scheduling_resources {
+	unsigned int vmid_mask;
+	enum kfd_queue_type type;
+	uint64_t queue_mask;
+	uint64_t gws_mask;
+	uint32_t oac_mask;
+	uint32_t gds_heap_base;
+	uint32_t gds_heap_size;
+};
+
+struct process_queue_manager {
+	/* data */
+	struct kfd_process	*process;
+	unsigned int		num_concurrent_processes;
+	struct list_head	queues;
+	unsigned long		*queue_slot_bitmap;
+};
+
+struct qcm_process_device {
+	/* The Device Queue Manager that owns this data */
+	struct device_queue_manager *dqm;
+	struct process_queue_manager *pqm;
+	/* Device Queue Manager lock */
+	struct mutex *lock;
+	/* Queues list */
+	struct list_head queues_list;
+	struct list_head priv_queue_list;
+
+	unsigned int queue_count;
+	unsigned int vmid;
+	bool is_debug;
+	/*
+	 * All the memory management data should be here too
+	 */
+	uint64_t gds_context_area;
+	uint32_t sh_mem_config;
+	uint32_t sh_mem_bases;
+	uint32_t sh_mem_ape1_base;
+	uint32_t sh_mem_ape1_limit;
+	uint32_t page_table_base;
+	uint32_t gds_size;
+	uint32_t num_gws;
+	uint32_t num_oac;
+};
+
 /* Data that is per-process-per device. */
 struct kfd_process_device {
 	/* List of all per-device data for a process. Starts from kfd_process.per_device_data. */
@@ -374,6 +428,8 @@ void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
 struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev);
+struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type);
+void kernel_queue_uninit(struct kernel_queue *kq);
 
 /* Packet Manager */
 
@@ -391,4 +447,13 @@ struct packet_manager {
 	kfd_mem_obj ib_buffer_obj;
 };
 
+int pm_init(struct packet_manager *pm, struct device_queue_manager *dqm);
+void pm_uninit(struct packet_manager *pm);
+int pm_send_set_resources(struct packet_manager *pm, struct scheduling_resources *res);
+int pm_send_runlist(struct packet_manager *pm, struct list_head *dqm_queues);
+int pm_send_query_status(struct packet_manager *pm, uint64_t fence_address, uint32_t fence_value);
+int pm_send_unmap_queue(struct packet_manager *pm, enum kfd_queue_type type,
+			enum kfd_preempt_type_filter mode, uint32_t filter_param, bool reset);
+void pm_release_ib(struct packet_manager *pm);
+
 #endif
-- 
1.9.1

