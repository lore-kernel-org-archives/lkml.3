Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3KYItu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:49:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3KYIsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:48:50 -0500
Message-Id: <20131125084810.255155883@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:47:08 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject-Prefi: [patch @num@/@total@ v4]
Subject: x86: export x86 boot_params to sysfs
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=09-add-sysfs-boot-param.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec-tools use boot_params for getting the 1st kernel hardware_subarch,
the kexec kernel efi runtime support also need read the old efi_info from
boot_params. Currently it exists in debugfs which is not a good place for
such infomation. Per HPA, we should avoid of "sploit debugfs".

In this patch /sys/kernel/boot_params are exported, also the setup_data
is exported as a subdirectory. For original debugfs since it's already
there for long time and kexec-tools is using it for hardware_subarch so
let's do not remove them for now.

Structure are like below:

/sys/kernel/boot_params
├── data		/* binary data for boot_params */
├── setup_data  	/* subdirectory for setup_data if there's any */
│   ├── 0		/* the first setup_data node */
│   │   ├── data	/* binary data for setup_data node 0 */
│   │   └── type	/* setup_data type of setup_data node 0, hex string */
|   [snip]		/* other setup_data nodes ... */
└── version		/* hex string for boot protocal version */

Changelog:
Greg: use __ATTR_RO() and group attr.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/ABI/testing/sysfs-kernel-boot_params |   40 ++
 arch/x86/kernel/Makefile                           |    2 
 arch/x86/kernel/ksysfs.c                           |  339 +++++++++++++++++++++
 3 files changed, 380 insertions(+), 1 deletion(-)

--- /dev/null
+++ efi/Documentation/ABI/testing/sysfs-kernel-boot_params
@@ -0,0 +1,40 @@
+What:		/sys/kernel/boot_params
+Date:		November 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		The /sys/kernel/boot_params directory contains two
+		files: "data" and "version" and one subdirectory "setup_data".
+		It is used to export the kernel boot parameters of x86
+		platform to user space for kexec and debugging purpose.
+
+		If there's no setup_data in boot_params the subdirectory will
+		not be created.
+
+		"data" file is the binary representation of struct boot_params.
+
+		"version" file is the string representation of boot
+		protocol version.
+
+		"setup_data" subdirectory contains the setup_data data
+		structure in boot_params. setup_data is maintained in kernel
+		as a link list. In "setup_data" subdirectory there's one
+		subdirectory for each link list node named with the number
+		of the list nodes. The list node subdirectory contains two
+		files "type" and "data". "type" file is the string
+		representation of setup_data type. "data" file is the binary
+		representation of setup_data payload.
+
+		The whole boot_params directory structure is like below:
+		/sys/kernel/boot_params
+		├── data
+		├── setup_data
+		│   ├── 0
+		│   │   ├── data
+		│   │   └── type
+		│   └── 1
+		│       ├── data
+		│       └── type
+		└── version
+
+Users:
+		Kexec Mailing List <kexec@lists.infradead.org>
--- efi.orig/arch/x86/kernel/Makefile
+++ efi/arch/x86/kernel/Makefile
@@ -35,7 +35,7 @@ obj-y			+= alternative.o i8253.o pci-nom
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
-
+obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
--- /dev/null
+++ efi/arch/x86/kernel/ksysfs.c
@@ -0,0 +1,339 @@
+/*
+ * Architecture specific sysfs attributes in /sys/kernel
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *      Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2013, 2013 Red Hat, Inc.
+ *      Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+
+#include <asm/setup.h>
+
+static ssize_t version_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
+}
+
+static struct kobj_attribute boot_params_version_attr = __ATTR_RO(version);
+
+static ssize_t boot_params_data_read(struct file *fp, struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, (void *)&boot_params + off, count);
+	return count;
+}
+
+static struct bin_attribute boot_params_data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = boot_params_data_read,
+	.size = sizeof(boot_params),
+};
+
+static struct attribute *boot_params_version_attrs[] = {
+	&boot_params_version_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *boot_params_data_attrs[] = {
+	&boot_params_data_attr,
+	NULL,
+};
+
+static struct attribute_group boot_params_attr_group = {
+	.attrs = boot_params_version_attrs,
+	.bin_attrs = boot_params_data_attrs,
+};
+
+static int kobj_to_setup_data_nr(struct kobject *kobj, int *nr)
+{
+	const char *name;
+
+	name = kobject_name(kobj);
+	return kstrtoint(name, 10, nr);
+}
+
+static int get_setup_data_paddr(int nr, u64 *paddr)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		if (nr == i) {
+			*paddr = pa_data;
+			return 0;
+		}
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static int __init get_setup_data_size(int nr, size_t *size)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+		if (nr == i) {
+			*size = data->len;
+			iounmap(data);
+			return 0;
+		}
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	int nr, ret;
+	u64 paddr;
+	struct setup_data *data;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	ret = sprintf(buf, "0x%x\n", data->type);
+	iounmap(data);
+	return ret;
+}
+
+static ssize_t setup_data_data_read(struct file *fp,
+				    struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf,
+				    loff_t off, size_t count)
+{
+	int nr, ret = 0;
+	u64 paddr;
+	struct setup_data *data;
+	void *p;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	if (off > data->len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (count > data->len - off)
+		count = data->len - off;
+
+	if (!count)
+		goto out;
+
+	ret = count;
+	p = ioremap_cache(paddr + sizeof(*data), data->len);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(buf, p + off, count);
+	iounmap(p);
+out:
+	iounmap(data);
+	return ret;
+}
+
+static struct kobj_attribute type_attr = __ATTR_RO(type);
+
+static struct bin_attribute data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = setup_data_data_read,
+};
+
+static struct attribute *setup_data_type_attrs[] = {
+	&type_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *setup_data_data_attrs[] = {
+	&data_attr,
+	NULL,
+};
+
+static struct attribute_group setup_data_attr_group = {
+	.attrs = setup_data_type_attrs,
+	.bin_attrs = setup_data_data_attrs,
+};
+
+static int __init create_setup_data_node(struct kobject *parent,
+					struct kobject **kobjp, int nr)
+{
+	int ret = 0;
+	size_t size;
+	struct kobject *kobj;
+	char name[16]; /* should be enough for setup_data nodes numbers */
+	snprintf(name, 16, "%d", nr);
+
+	kobj = kobject_create_and_add(name, parent);
+	if (!kobj)
+		return -ENOMEM;
+
+	ret = get_setup_data_size(nr, &size);
+	if (ret)
+		goto out_kobj;
+
+	data_attr.size = size;
+	ret = sysfs_create_group(kobj, &setup_data_attr_group);
+	if (ret)
+		goto out_kobj;
+	*kobjp = kobj;
+
+	return 0;
+out_kobj:
+	kobject_put(kobj);
+	return ret;
+}
+
+static void __init cleanup_setup_data_node(struct kobject *kobj)
+{
+	sysfs_remove_group(kobj, &setup_data_attr_group);
+	kobject_put(kobj);
+}
+
+static int __init get_setup_data_total_num(u64 pa_data, int *nr)
+{
+	int ret = 0;
+	struct setup_data *data;
+
+	*nr = 0;
+	while (pa_data) {
+		*nr += 1;
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		pa_data = data->next;
+		iounmap(data);
+	}
+
+out:
+	return ret;
+}
+
+static int __init create_setup_data_nodes(struct kobject *parent)
+{
+	struct kobject *setup_data_kobj, **kobjp;
+	u64 pa_data;
+	int i, j, nr, ret = 0;
+
+	pa_data = boot_params.hdr.setup_data;
+	if (!pa_data)
+		return 0;
+
+	setup_data_kobj = kobject_create_and_add("setup_data", parent);
+	if (!setup_data_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_setup_data_total_num(pa_data, &nr);
+	if (ret)
+		goto out_setup_data_kobj;
+
+	kobjp = kmalloc(sizeof(*kobjp) * nr, GFP_KERNEL);
+	if (!kobjp) {
+		ret = -ENOMEM;
+		goto out_setup_data_kobj;
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = create_setup_data_node(setup_data_kobj, kobjp + i, i);
+		if (ret)
+			goto out_clean_nodes;
+	}
+
+	kfree(kobjp);
+	return 0;
+
+out_clean_nodes:
+	for (j = i - 1; j > 0; j--)
+		cleanup_setup_data_node(*(kobjp + j));
+	kfree(kobjp);
+out_setup_data_kobj:
+	kobject_put(setup_data_kobj);
+out:
+	return ret;
+}
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int ret;
+	struct kobject *boot_params_kobj;
+
+	boot_params_kobj = kobject_create_and_add("boot_params",
+						  kernel_kobj);
+	if (!boot_params_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sysfs_create_group(boot_params_kobj, &boot_params_attr_group);
+	if (ret)
+		goto out_boot_params_kobj;
+
+	ret = create_setup_data_nodes(boot_params_kobj);
+	if (ret)
+		goto out_create_group;
+
+	return 0;
+out_create_group:
+	sysfs_remove_group(boot_params_kobj, &boot_params_attr_group);
+out_boot_params_kobj:
+	kobject_put(boot_params_kobj);
+out:
+	return ret;
+}
+
+arch_initcall(boot_params_ksysfs_init);

