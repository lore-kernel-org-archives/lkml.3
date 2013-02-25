Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab3BYW1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:27:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3BYWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [ 30/58] KVM: s390: Handle hosts not supporting s390-virtio.
Date: Mon, 25 Feb 2013 14:19:26 -0800
Message-Id: <20130225221642.611671491@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/kvm/kvm_virtio.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -422,6 +422,26 @@ static void kvm_extint_handler(struct ex
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
@@ -432,21 +452,23 @@ static int __init kvm_devices_init(void)
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


