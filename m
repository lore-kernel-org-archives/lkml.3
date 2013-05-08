Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3EHQKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:10:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34883 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381Ab3EHQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:10:21 -0400
Message-ID: <518A78CC.2000501@linux.vnet.ibm.com>
Date: Wed, 08 May 2013 11:09:48 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base: Use attribute groups to create sysfs memory
 files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050816-9360-0000-0000-00001215F771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the sysfs memory code to create/delete files at the time of device
and subsystem registration.

The current code creates files in the root memory directory explicitly through
the use of init_* routines. The files for each memory block are created and
deleted explicitly using the mem_[create|delete]_simple_file macros.

This patch creates attribute groups for the memory root files and files in
each memory block directory so that they are created and deleted implicitly
at subsys and device register and unregister time.
 
This did necessitate moving the register_memory() and unregister_memory()
routines in the file. There are no changes to unregister_memory, the
register_memory routine is only updated to set the dev.groups field.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Please cc me on responses/comments.
---
 drivers/base/memory.c |  163 ++++++++++++++++++++++----------------------------
 1 file changed, 72 insertions(+), 91 deletions(-)

Index: driver-core/drivers/base/memory.c
===================================================================
--- driver-core.orig/drivers/base/memory.c	2013-05-08 08:34:05.000000000 -0500
+++ driver-core/drivers/base/memory.c	2013-05-08 09:43:48.000000000 -0500
@@ -77,32 +77,6 @@
 	kfree(mem);
 }
 
-/*
- * register_memory - Setup a sysfs device for a memory block
- */
-static
-int register_memory(struct memory_block *memory)
-{
-	int error;
-
-	memory->dev.bus = &memory_subsys;
-	memory->dev.id = memory->start_section_nr / sections_per_block;
-	memory->dev.release = memory_block_release;
-
-	error = device_register(&memory->dev);
-	return error;
-}
-
-static void
-unregister_memory(struct memory_block *memory)
-{
-	BUG_ON(memory->dev.bus != &memory_subsys);
-
-	/* drop the ref. we got in remove_memory_block() */
-	kobject_put(&memory->dev.kobj);
-	device_unregister(&memory->dev);
-}
-
 unsigned long __weak memory_block_size_bytes(void)
 {
 	return MIN_MEMORY_BLOCK_SIZE;
@@ -382,11 +356,6 @@
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
 
-#define mem_create_simple_file(mem, attr_name)	\
-	device_create_file(&mem->dev, &dev_attr_##attr_name)
-#define mem_remove_simple_file(mem, attr_name)	\
-	device_remove_file(&mem->dev, &dev_attr_##attr_name)
-
 /*
  * Block size attribute stuff
  */
@@ -399,12 +368,6 @@
 
 static DEVICE_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
-static int block_size_init(void)
-{
-	return device_create_file(memory_subsys.dev_root,
-				  &dev_attr_block_size_bytes);
-}
-
 /*
  * Some architectures will have custom drivers to do this, and
  * will not need to do it from userspace.  The fake hot-add code
@@ -440,17 +403,8 @@
 out:
 	return ret;
 }
-static DEVICE_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
-static int memory_probe_init(void)
-{
-	return device_create_file(memory_subsys.dev_root, &dev_attr_probe);
-}
-#else
-static inline int memory_probe_init(void)
-{
-	return 0;
-}
+static DEVICE_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 #endif
 
 #ifdef CONFIG_MEMORY_FAILURE
@@ -496,23 +450,6 @@
 
 static DEVICE_ATTR(soft_offline_page, S_IWUSR, NULL, store_soft_offline_page);
 static DEVICE_ATTR(hard_offline_page, S_IWUSR, NULL, store_hard_offline_page);
-
-static __init int memory_fail_init(void)
-{
-	int err;
-
-	err = device_create_file(memory_subsys.dev_root,
-				&dev_attr_soft_offline_page);
-	if (!err)
-		err = device_create_file(memory_subsys.dev_root,
-				&dev_attr_hard_offline_page);
-	return err;
-}
-#else
-static inline int memory_fail_init(void)
-{
-	return 0;
-}
 #endif
 
 /*
@@ -557,6 +494,51 @@
 	return find_memory_block_hinted(section, NULL);
 }
 
+static struct attribute *memory_memblk_attrs[] = {
+	&dev_attr_phys_index.attr,
+	&dev_attr_end_phys_index.attr,
+	&dev_attr_state.attr,
+	&dev_attr_phys_device.attr,
+	&dev_attr_removable.attr,
+	NULL
+};
+
+static struct attribute_group memory_memblk_attr_group = {
+	.attrs = memory_memblk_attrs,
+};
+
+static const struct attribute_group *memory_memblk_attr_groups[] = {
+	&memory_memblk_attr_group,
+	NULL,
+};
+
+/*
+ * register_memory - Setup a sysfs device for a memory block
+ */
+static
+int register_memory(struct memory_block *memory)
+{
+	int error;
+
+	memory->dev.bus = &memory_subsys;
+	memory->dev.id = memory->start_section_nr / sections_per_block;
+	memory->dev.release = memory_block_release;
+	memory->dev.groups = memory_memblk_attr_groups;
+
+	error = device_register(&memory->dev);
+	return error;
+}
+
+static void
+unregister_memory(struct memory_block *memory)
+{
+	BUG_ON(memory->dev.bus != &memory_subsys);
+
+	/* drop the ref. we got in remove_memory_block() */
+	kobject_put(&memory->dev.kobj);
+	device_unregister(&memory->dev);
+}
+
 static int init_memory_block(struct memory_block **memory,
 			     struct mem_section *section, unsigned long state)
 {
@@ -580,16 +562,6 @@
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 
 	ret = register_memory(mem);
-	if (!ret)
-		ret = mem_create_simple_file(mem, phys_index);
-	if (!ret)
-		ret = mem_create_simple_file(mem, end_phys_index);
-	if (!ret)
-		ret = mem_create_simple_file(mem, state);
-	if (!ret)
-		ret = mem_create_simple_file(mem, phys_device);
-	if (!ret)
-		ret = mem_create_simple_file(mem, removable);
 
 	*memory = mem;
 	return ret;
@@ -647,14 +619,9 @@
 	unregister_mem_sect_under_nodes(mem, __section_nr(section));
 
 	mem->section_count--;
-	if (mem->section_count == 0) {
-		mem_remove_simple_file(mem, phys_index);
-		mem_remove_simple_file(mem, end_phys_index);
-		mem_remove_simple_file(mem, state);
-		mem_remove_simple_file(mem, phys_device);
-		mem_remove_simple_file(mem, removable);
+	if (mem->section_count == 0)
 		unregister_memory(mem);
-	} else
+	else
 		kobject_put(&mem->dev.kobj);
 
 	mutex_unlock(&mem_sysfs_mutex);
@@ -699,6 +666,29 @@
 	return mem->state == MEM_OFFLINE;
 }
 
+static struct attribute *memory_root_attrs[] = {
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+	&dev_attr_probe.attr,
+#endif
+
+#ifdef CONFIG_MEMORY_FAILURE
+	&dev_attr_soft_offline_page.attr,
+	&dev_attr_hard_offline_page.attr,
+#endif
+
+	&dev_attr_block_size_bytes.attr,
+	NULL
+};
+
+static struct attribute_group memory_root_attr_group = {
+	.attrs = memory_root_attrs,
+};
+
+static const struct attribute_group *memory_root_attr_groups[] = {
+	&memory_root_attr_group,
+	NULL,
+};
+
 /*
  * Initialize the sysfs support for memory devices...
  */
@@ -710,7 +700,7 @@
 	unsigned long block_sz;
 	struct memory_block *mem = NULL;
 
-	ret = subsys_system_register(&memory_subsys, NULL);
+	ret = subsys_system_register(&memory_subsys, memory_root_attr_groups);
 	if (ret)
 		goto out;
 
@@ -733,15 +723,6 @@
 			ret = err;
 	}
 
-	err = memory_probe_init();
-	if (!ret)
-		ret = err;
-	err = memory_fail_init();
-	if (!ret)
-		ret = err;
-	err = block_size_init();
-	if (!ret)
-		ret = err;
 out:
 	if (ret)
 		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);

