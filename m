Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3B1Opv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:45:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3B1Opt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:45:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Gleb Natapov <gleb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 002/139] KVM: s390: Handle hosts not supporting s390-virtio.
Date: Thu, 28 Feb 2013 14:42:32 +0000
Message-Id: <1362062689-2567-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cornelia Huck <cornelia.huck@de.ibm.com>

commit 55c171a6d90dc0574021f9c836127cfd1a7d2e30 upstream.

Running under a kvm host does not necessarily imply the presence of
a page mapped above the main memory with the virtio information;
however, the code includes a hard coded access to that page.

Instead, check for the presence of the page and exit gracefully
before we hit an addressing exception if it does not exist.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Reviewed-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/kvm/kvm_virtio.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index d74e9ae..f97b2aa 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -418,6 +418,26 @@ static void kvm_extint_handler(struct ext_code ext_code,
 }
 
 /*
+ * For s390-virtio, we expect a page above main storage containing
+ * the virtio configuration. Try to actually load from this area
+ * in order to figure out if the host provides this page.
+ */
+static int __init test_devices_support(unsigned long addr)
+{
+	int ret = -EIO;
+
+	asm volatile(
+		"0:	lura	0,%1\n"
+		"1:	xgr	%0,%0\n"
+		"2:\n"
+		EX_TABLE(0b,2b)
+		EX_TABLE(1b,2b)
+		: "+d" (ret)
+		: "a" (addr)
+		: "0", "cc");
+	return ret;
+}
+/*
  * Init function for virtio
  * devices are in a single page above top of "normal" mem
  */
@@ -428,21 +448,23 @@ static int __init kvm_devices_init(void)
 	if (!MACHINE_IS_KVM)
 		return -ENODEV;
 
+	if (test_devices_support(real_memory_size) < 0)
+		return -ENODEV;
+
+	rc = vmem_add_mapping(real_memory_size, PAGE_SIZE);
+	if (rc)
+		return rc;
+
+	kvm_devices = (void *) real_memory_size;
+
 	kvm_root = root_device_register("kvm_s390");
 	if (IS_ERR(kvm_root)) {
 		rc = PTR_ERR(kvm_root);
 		printk(KERN_ERR "Could not register kvm_s390 root device");
+		vmem_remove_mapping(real_memory_size, PAGE_SIZE);
 		return rc;
 	}
 
-	rc = vmem_add_mapping(real_memory_size, PAGE_SIZE);
-	if (rc) {
-		root_device_unregister(kvm_root);
-		return rc;
-	}
-
-	kvm_devices = (void *) real_memory_size;
-
 	INIT_WORK(&hotplug_work, hotplug_devices);
 
 	service_subclass_irq_register();
-- 
1.8.1.2

