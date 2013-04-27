Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3D0HFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:05:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:4157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab3D0HFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:05:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="303853884"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: [PATCH 5/5] driver: provide sysfs interfaces to access TXT heap
Date: Sat, 27 Apr 2013 22:56:20 +0800
Message-Id: <1367074580-16530-6-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
References: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These interfaces are located in /sys/devices/platform/txt/heap/.
There are one file binary_heap displaying the whole heap information
in binary, and four subfolders displaying detailed heap information.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/char/txt/Makefile    |    2 +-
 drivers/char/txt/txt-heap.c  | 1616 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/txt/txt-heap.h  |  338 +++++++++
 drivers/char/txt/txt-sysfs.c |    5 +
 4 files changed, 1960 insertions(+), 1 deletion(-)
 create mode 100644 drivers/char/txt/txt-heap.c
 create mode 100644 drivers/char/txt/txt-heap.h

diff --git a/drivers/char/txt/Makefile b/drivers/char/txt/Makefile
index be73add..4e972df 100644
--- a/drivers/char/txt/Makefile
+++ b/drivers/char/txt/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the intel TXT drivers.
 #
 obj-$(CONFIG_TXT) += txt.o
-txt-y := txt-sysfs.o txt-config.o txt-log.o txt-parameter.o
+txt-y := txt-sysfs.o txt-config.o txt-log.o txt-parameter.o txt-heap.o
diff --git a/drivers/char/txt/txt-heap.c b/drivers/char/txt/txt-heap.c
new file mode 100644
index 0000000..e47018d
--- /dev/null
+++ b/drivers/char/txt/txt-heap.c
@@ -0,0 +1,1616 @@
+/*
+ * txt-heap.c
+ *
+ * binary_heap, -r--r--r--; output all raw binary heap data.
+ * 4 subfolders, indicating 4 kinds of data in heap, in which every file
+ * is one data field bios_data, os_mle_data, os_sinit_data, sinit_mle_data
+ *
+ * Data is currently found below
+ *   /sys/devices/platform/txt/heap/...
+ *
+ *   - bios_data/
+ *     bios_data_raw		-r--r--r-- ;
+ *     bios_data_version	-r--r--r-- ;
+ *     bios_sinit_size		-r--r--r-- ;
+ *     lcp_pd_base		-r--r--r-- ;
+ *     lcp_pd_size		-r--r--r-- ;
+ *     num_logical_procs	-r--r--r-- ;
+ *     flags			-r--r--r-- ;
+ *
+ *   - Dynamically create extended data elements subfolders:
+ *     bios_spec_ver_elt/
+ *	 major, minor, ver
+ *     acm_elt/
+ *	 num_acms, acm_addrs
+ *     custom_elt/
+ *	 size, uuid
+ *     event_log_elt/
+ *	 event_log_size, event_log_addr, event_log_container, events
+ *
+ *   - os_mle_data/
+ *     os_mle_data_raw		-r--r--r-- ;
+ *     os_mle_data_version	-r--r--r-- ;
+ *     mbi			-r--r--r-- ;
+ *
+ *   - os_sinit_data/
+ *     os_sinit_data_raw	-r--r--r-- ;
+ *     os_sinit_data_version	-r--r--r-- ;
+ *     mle_ptab			-r--r--r-- ;
+ *     mle_size			-r--r--r-- ;
+ *     mle_hdr_base		-r--r--r-- ;
+ *     vtd_pmr_lo_base		-r--r--r-- ;
+ *     vtd_pmr_lo_size		-r--r--r-- ;
+ *     vtd_pmr_hi_base		-r--r--r-- ;
+ *     vtd_pmr_hi_size		-r--r--r-- ;
+ *     lcp_po_base		-r--r--r-- ;
+ *     lcp_po_size		-r--r--r-- ;
+ *     caps_raw			-r--r--r-- ;
+ *     caps_rlp_wake_getsec	-r--r--r-- ;
+ *     caps_rlp_wake_monitor	-r--r--r-- ;
+ *     caps_ecx_pgtbl		-r--r--r-- ;
+ *     caps_pcr_map_no_legacy	-r--r--r-- ;
+ *     caps_pcr_map_da		-r--r--r-- ;
+ *     efi_rsdt_ptr		-r--r--r-- ;
+ *     ext_data_element same with that in bios_data
+ *
+ *   - sinit_mle_data/
+ *     sinit_mle_data_raw	-r--r--r-- ;
+ *     sinit_mle_data_version	-r--r--r-- ;
+ *     bios_acm_id		-r--r--r-- ;
+ *     edx_senter_flags		-r--r--r-- ;
+ *     mseg_valid		-r--r--r-- ;
+ *     sinit_hash		-r--r--r-- ;
+ *     mle_hash			-r--r--r-- ;
+ *     stm_hash			-r--r--r-- ;
+ *     lcp_policy_hash		-r--r--r-- ;
+ *     lcp_policy_control	-r--r--r-- ;
+ *     rlp_wakeup_addr		-r--r--r-- ;
+ *     num_mdrs			-r--r--r-- ;
+ *     mdrs_off			-r--r--r-- ;
+ *     num_vtd_dmars		-r--r--r-- ;
+ *     vtd_dmars_off		-r--r--r-- ;
+ *     sinit_mdrs		-r--r--r-- ;
+ *     proc_scrtm_status	-r--r--r-- ;
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+
+#include "txt-config.h"
+#include "txt-log.h"
+#include "txt-heap.h"
+
+static uint64_t txt_heap_size;
+
+static ssize_t print_hash(char *buf, uint8_t *hash)
+{
+	int i;
+	void *start;
+	char *str = buf;
+
+	if (hash == NULL)
+		return -EINVAL;
+
+	start = hash;
+	for (i = 0; i < SHA1_LENGTH; i++, start++)
+		str += scnprintf(str, PAGE_SIZE, "%02x ", *(uint8_t *)start);
+
+	str += scnprintf(str, PAGE_SIZE, "\n");
+	return str - buf;
+}
+
+static ssize_t print_hex(char *buf, char *prefix, void *ptr, size_t size)
+{
+	size_t i;
+	char *str = buf;
+
+	for (i = 0; i < size; i++) {
+		if (i % 16 == 0 && prefix != NULL)
+			str += scnprintf(str, PAGE_SIZE, "\n%s", prefix);
+		str += scnprintf(str, PAGE_SIZE, "%02x ", *(uint8_t *)ptr++);
+	}
+
+	str += scnprintf(str, PAGE_SIZE, "\n");
+	return str - buf;
+}
+
+static void *get_txt_heap(void)
+{
+	void __iomem *config;
+	void __iomem *heap;
+	uint64_t base, size;
+
+	config = ioremap_nocache(TXT_PUB_CONFIG_REGS_BASE,
+				 TXT_CONFIG_REGS_SIZE);
+	if (!config)
+		return NULL;
+
+	base = read_txt_config_reg(config, TXTCR_HEAP_BASE);
+	size = read_txt_config_reg(config, TXTCR_HEAP_SIZE);
+
+	iounmap(config);
+
+	if (base == 0 || size == 0)
+		return NULL;
+
+	heap = ioremap_nocache(base, size);
+	if (!heap)
+		return NULL;
+
+	txt_heap_size = size;
+
+	return heap;
+}
+
+/*
+ * extended data elements
+ */
+
+/* HEAP_BIOS_SPEC_VER_ELEMENT */
+static ssize_t print_bios_elt(char *buf, struct heap_ext_data_element *elt,
+			      u32 offset)
+{
+	struct heap_bios_spec_ver_elt *bios_elt;
+
+	while (elt->type != HEAP_EXTDATA_TYPE_END &&
+	       elt->type != HEAP_EXTDATA_TYPE_BIOS_SPEC_VER)
+		elt = (void *)elt + elt->size;
+
+	if (elt->type == HEAP_EXTDATA_TYPE_END)
+		return -EFAULT;
+
+	bios_elt = (struct heap_bios_spec_ver_elt *)elt->data;
+
+	switch (offset) {
+	case off_bios_elt_major:
+		return scnprintf(buf, PAGE_SIZE, "0x%x\n",
+				 bios_elt->spec_ver_major);
+
+	case off_bios_elt_minor:
+		return scnprintf(buf, PAGE_SIZE, "0x%x\n",
+				 bios_elt->spec_ver_minor);
+
+	case off_bios_elt_rev:
+		return scnprintf(buf, PAGE_SIZE, "0x%x\n",
+				 bios_elt->spec_ver_rev);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/* HEAP_ACM_ELEMENT */
+static ssize_t print_acm_elt(char *buf, struct heap_ext_data_element *elt,
+			     u32 offset)
+{
+	struct heap_acm_elt *acm_elt;
+
+	while (elt->type != HEAP_EXTDATA_TYPE_END &&
+	       elt->type != HEAP_EXTDATA_TYPE_ACM)
+		elt = (void *)elt + elt->size;
+
+	if (elt->type == HEAP_EXTDATA_TYPE_END)
+		return -EFAULT;
+
+	acm_elt = (struct heap_acm_elt *)elt->data;
+
+	switch (offset) {
+	case off_acm_elt_num_acms:
+		return scnprintf(buf, PAGE_SIZE, "%u\n", acm_elt->num_acms);
+
+	case off_acm_elt_acm_addrs:
+	{
+		char *str = buf;
+		u32 i;
+
+		for (i = 0; i < acm_elt->num_acms; i++)
+			str += scnprintf(str, PAGE_SIZE,
+					 "acm_addrs[%u]: 0x%llx\n",
+					 i, acm_elt->acm_addrs[i]);
+
+		return str - buf;
+	}
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/* HEAP_CUSTOM_ELEMENT */
+static ssize_t print_custom_elt(char *buf, struct heap_ext_data_element *elt,
+				u32 offset)
+{
+	struct heap_custom_elt *custom_elt;
+
+	while (elt->type != HEAP_EXTDATA_TYPE_END &&
+	       elt->type != HEAP_EXTDATA_TYPE_CUSTOM)
+		elt = (void *)elt + elt->size;
+
+	if (elt->type == HEAP_EXTDATA_TYPE_END)
+		return -EFAULT;
+
+	custom_elt = (struct heap_custom_elt *)elt->data;
+
+	switch (offset) {
+	case off_custom_elt_size:
+		return scnprintf(buf, PAGE_SIZE, "%u\n", elt->size);
+
+	case off_custom_elt_uuid:
+	{
+		struct uuid *uuid;
+
+		uuid = &custom_elt->uuid;
+
+		return scnprintf(buf, PAGE_SIZE,
+				 "{0x%08x, 0x%04x, 0x%04x, 0x%04x,\n{0x%02x"
+				 ",0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x}}",
+				 uuid->data1, (uint32_t)uuid->data2,
+				 (uint32_t)uuid->data3, (uint32_t)uuid->data4,
+				 (uint32_t)uuid->data5[0],
+				 (uint32_t)uuid->data5[1],
+				 (uint32_t)uuid->data5[2],
+				 (uint32_t)uuid->data5[3],
+				 (uint32_t)uuid->data5[4],
+				 (uint32_t)uuid->data5[5]);
+	}
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/* HEAP_EVENT_LOG_POINTER_ELEMENT */
+static ssize_t print_event(char *buf, struct tpm12_pcr_event *evt)
+{
+	char *str = buf;
+
+	str += scnprintf(str, PAGE_SIZE, "Event:\n");
+	str += scnprintf(str, PAGE_SIZE, "  PCRIndex: %u\n", evt->pcr_index);
+	str += scnprintf(str, PAGE_SIZE, "      Type: 0x%x\n", evt->type);
+	str += scnprintf(str, PAGE_SIZE, "    Digest: ");
+	str += print_hash(str, evt->digest);
+	str += scnprintf(str, PAGE_SIZE, "      Data: %u bytes",
+			 evt->data_size);
+	str += print_hex(str, "      ", evt->data, evt->data_size);
+
+	return str - buf;
+}
+
+static ssize_t print_event_elt(char *buf, struct heap_ext_data_element *elt,
+			       u32 offset)
+{
+	struct heap_event_log_ptr_elt *elog_elt;
+	struct event_log_container *elog_con;
+	void *elog_con_base;
+	char *str = buf;
+	int ret;
+
+	while (elt->type != HEAP_EXTDATA_TYPE_END &&
+	       elt->type != HEAP_EXTDATA_TYPE_TPM_EVENT_LOG_PTR)
+		elt = (void *)elt + elt->size;
+
+	if (elt->type == HEAP_EXTDATA_TYPE_END)
+		return -EFAULT;
+
+	elog_elt = (struct heap_event_log_ptr_elt *)elt->data;
+
+	elog_con_base = ioremap_nocache(elog_elt->event_log_phys_addr,
+					MAX_EVENT_LOG_SIZE);
+	if (elog_con_base == NULL)
+		return -ENOMEM;
+
+	elog_con = (struct event_log_container *)elog_con_base;
+
+	switch (offset) {
+	case off_event_elt_size:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n", elt->size);
+		break;
+
+	case off_event_elt_addr:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       elog_elt->event_log_phys_addr);
+		break;
+
+	case off_event_elt_container:
+		ret = scnprintf(buf, PAGE_SIZE,
+			       "Signature: %s\nContainerVer: %u.%u\n"
+			       "PCREventVer: %u.%u\nSize: %u\n"
+			       "EventOffset: [%u,%u)\n",
+			       elog_con->signature,
+			       elog_con->container_ver_major,
+			       elog_con->container_ver_minor,
+			       elog_con->pcr_event_ver_major,
+			       elog_con->pcr_event_ver_minor,
+			       elog_con->size,
+			       elog_con->pcr_events_offset,
+			       elog_con->next_event_offset);
+		break;
+
+	case off_event_elt_events:
+	{
+		struct tpm12_pcr_event *cur, *next;
+
+		cur = (struct tpm12_pcr_event *)
+			((void *)elog_con + elog_con->pcr_events_offset);
+		next = (struct tpm12_pcr_event *)
+			((void *)elog_con + elog_con->next_event_offset);
+		while (cur < next) {
+			str += print_event(str, cur);
+			cur = (void *)cur + sizeof(*cur) + cur->data_size;
+		}
+		ret = str - buf;
+
+		break;
+	}
+
+	default:
+		ret = -EINVAL;
+	}
+
+	iounmap(elog_con_base);
+	return ret;
+}
+
+static struct attribute_group bios_spec_ver_elt_attr_grp;
+static struct attribute_group acm_elt_attr_grp;
+static struct attribute_group custom_elt_attr_grp;
+static struct attribute_group event_elt_attr_grp;
+
+static ssize_t sysfs_create_ext_data_elt(struct kobject *parent,
+					 struct heap_ext_data_element elts[])
+{
+	struct heap_ext_data_element *elt = elts;
+	int ret = 0;
+
+	while (elt->type != HEAP_EXTDATA_TYPE_END) {
+
+		switch (elt->type) {
+		case HEAP_EXTDATA_TYPE_BIOS_SPEC_VER:
+		{
+			struct kobject *bios_spec_ver_elt_kobj;
+
+			bios_spec_ver_elt_kobj = kobject_create_and_add(
+					"bios_spec_ver_elt", parent);
+			if (!bios_spec_ver_elt_kobj)
+				return -ENOMEM;
+
+			ret = sysfs_create_group(bios_spec_ver_elt_kobj,
+						&bios_spec_ver_elt_attr_grp);
+			if (ret)
+				return ret;
+
+			break;
+		}
+
+		case HEAP_EXTDATA_TYPE_ACM:
+		{
+			struct kobject *acm_elt_kobj;
+
+			acm_elt_kobj = kobject_create_and_add(
+					"acm_elt", parent);
+			if (!acm_elt_kobj)
+				return -ENOMEM;
+
+			ret = sysfs_create_group(acm_elt_kobj,
+						&acm_elt_attr_grp);
+			if (ret)
+				return ret;
+
+			break;
+		}
+
+		case HEAP_EXTDATA_TYPE_CUSTOM:
+		{
+			struct kobject *custom_elt_kobj;
+
+			custom_elt_kobj = kobject_create_and_add(
+					"custom_elt", parent);
+			if (!custom_elt_kobj)
+				return -ENOMEM;
+
+			ret = sysfs_create_group(custom_elt_kobj,
+						&custom_elt_attr_grp);
+			if (ret)
+				return ret;
+
+			break;
+		}
+
+		case HEAP_EXTDATA_TYPE_TPM_EVENT_LOG_PTR:
+		{
+			struct kobject *event_log_ptr_elt_kobj;
+
+			event_log_ptr_elt_kobj = kobject_create_and_add(
+					"event_log_elt", parent);
+			if (!event_log_ptr_elt_kobj)
+				return -ENOMEM;
+
+			ret = sysfs_create_group(event_log_ptr_elt_kobj,
+						&event_elt_attr_grp);
+			if (ret)
+				return ret;
+
+			break;
+		}
+
+		default:
+			return -EINVAL;
+		}
+
+		elt = (void *)elt + elt->size;
+	}
+
+	return ret;
+}
+
+/*
+ * BIOS Data Format
+ */
+
+static ssize_t show_bios_data(char *buf, u32 offset)
+{
+	void *heap = NULL;
+	struct bios_data *bios_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	bios_data = get_bios_data_start(heap);
+
+	switch (offset) {
+	case off_bios_data_raw:
+		ret = scnprintf(buf, PAGE_SIZE, "@0x%p, 0x%llx\n", bios_data,
+			       *((uint64_t *)bios_data - 1));
+		break;
+
+	case off_bios_data_version:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n", bios_data->version);
+		break;
+
+	case off_bios_sinit_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%x (%u)\n",
+			       bios_data->bios_sinit_size,
+			       bios_data->bios_sinit_size);
+		break;
+
+	case off_lcp_pd_base:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       bios_data->lcp_pd_base);
+		break;
+
+	case off_lcp_pd_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx (%llu)\n",
+			       bios_data->lcp_pd_size,
+			       bios_data->lcp_pd_size);
+		break;
+
+	case off_num_logical_procs:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
+			       bios_data->num_logical_procs);
+		break;
+
+	case off_flags:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%08llx\n",
+			       bios_data->flags);
+		break;
+
+	case off_bios_elt_major:
+	case off_bios_elt_minor:
+	case off_bios_elt_rev:
+		ret = print_bios_elt(buf, bios_data->ext_data_elts, offset);
+		break;
+
+	case off_acm_elt_num_acms:
+	case off_acm_elt_acm_addrs_index:
+	case off_acm_elt_acm_addrs:
+		ret = print_acm_elt(buf, bios_data->ext_data_elts, offset);
+		break;
+
+	case off_custom_elt_size:
+	case off_custom_elt_uuid:
+		ret = print_custom_elt(buf, bios_data->ext_data_elts, offset);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	iounmap(heap);
+	return ret;
+}
+
+static ssize_t show_bios_spec_ver_elt_major(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	return show_bios_data(buf, off_bios_elt_major);
+}
+static DEVICE_ATTR(major, S_IRUGO, show_bios_spec_ver_elt_major, NULL);
+
+static ssize_t show_bios_spec_ver_elt_minor(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	return show_bios_data(buf, off_bios_elt_minor);
+}
+static DEVICE_ATTR(minor, S_IRUGO, show_bios_spec_ver_elt_minor, NULL);
+
+static ssize_t show_bios_spec_ver_elt_rev(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return show_bios_data(buf, off_bios_elt_rev);
+}
+static DEVICE_ATTR(rev, S_IRUGO, show_bios_spec_ver_elt_rev, NULL);
+
+static struct attribute *bios_spec_ver_elt_attr[] = {
+	&dev_attr_major.attr,
+	&dev_attr_minor.attr,
+	&dev_attr_rev.attr,
+	NULL,
+};
+
+static struct attribute_group bios_spec_ver_elt_attr_grp = {
+	.attrs = bios_spec_ver_elt_attr
+};
+static ssize_t show_acm_elt_num_acms(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	return show_bios_data(buf, off_acm_elt_num_acms);
+}
+static DEVICE_ATTR(num_acms, S_IRUGO, show_acm_elt_num_acms, NULL);
+
+static ssize_t show_acm_elt_acm_addrs(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_bios_data(buf, off_acm_elt_acm_addrs);
+}
+static DEVICE_ATTR(acm_addrs, S_IRUGO, show_acm_elt_acm_addrs, NULL);
+
+static struct attribute *acm_elt_attr[] = {
+	&dev_attr_num_acms.attr,
+	&dev_attr_acm_addrs.attr,
+	NULL,
+};
+static struct attribute_group acm_elt_attr_grp = {
+	.attrs = acm_elt_attr
+};
+
+static ssize_t show_custom_elt_size(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_bios_data(buf, off_custom_elt_size);
+}
+static DEVICE_ATTR(size, S_IRUGO, show_custom_elt_size, NULL);
+
+static ssize_t show_custom_elt_uuid(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_bios_data(buf, off_custom_elt_uuid);
+}
+static DEVICE_ATTR(uuid, S_IRUGO, show_custom_elt_uuid, NULL);
+
+static struct attribute *custom_elt_attr[] = {
+	&dev_attr_size.attr,
+	&dev_attr_uuid.attr,
+	NULL,
+};
+static struct attribute_group custom_elt_attr_grp = {
+	.attrs = custom_elt_attr
+};
+
+static ssize_t show_bios_data_raw(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_bios_data(buf, off_bios_data_raw);
+}
+static DEVICE_ATTR(bios_data_raw, S_IRUGO, show_bios_data_raw, NULL);
+
+static ssize_t show_bios_data_version(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_bios_data(buf, off_bios_data_version);
+}
+static DEVICE_ATTR(bios_data_version, S_IRUGO, show_bios_data_version, NULL);
+
+static ssize_t show_bios_sinit_size(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_bios_data(buf, off_bios_sinit_size);
+}
+static DEVICE_ATTR(bios_sinit_size, S_IRUGO, show_bios_sinit_size, NULL);
+
+static ssize_t show_lcp_pd_base(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_bios_data(buf, off_lcp_pd_base);
+}
+static DEVICE_ATTR(lcp_pd_base, S_IRUGO, show_lcp_pd_base, NULL);
+
+static ssize_t show_lcp_pd_size(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_bios_data(buf, off_lcp_pd_size);
+}
+static DEVICE_ATTR(lcp_pd_size, S_IRUGO, show_lcp_pd_size, NULL);
+
+static ssize_t show_num_logical_procs(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_bios_data(buf, off_num_logical_procs);
+}
+static DEVICE_ATTR(num_logical_procs, S_IRUGO, show_num_logical_procs, NULL);
+
+static ssize_t show_flags(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	return show_bios_data(buf, off_flags);
+}
+static DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
+
+static struct attribute *bios_data_attr[] = {
+	&dev_attr_bios_data_raw.attr,
+	&dev_attr_bios_data_version.attr,
+	&dev_attr_bios_sinit_size.attr,
+	&dev_attr_lcp_pd_base.attr,
+	&dev_attr_lcp_pd_size.attr,
+	&dev_attr_num_logical_procs.attr,
+	NULL,
+};
+
+static struct attribute_group bios_data_attr_grp = {
+	.attrs = bios_data_attr
+};
+
+static ssize_t sysfs_create_bios_data(struct kobject *parent)
+{
+	struct kobject *bios_data_kobj;
+	void *heap;
+	struct bios_data *bios_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	bios_data = get_bios_data_start(heap);
+
+	bios_data_kobj = kobject_create_and_add("bios_data", parent);
+	if (!bios_data_kobj) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = sysfs_create_group(bios_data_kobj, &bios_data_attr_grp);
+	if (ret)
+		goto err;
+
+	if (bios_data->version >= 3) {
+		ret = sysfs_create_file(bios_data_kobj, &dev_attr_flags.attr);
+		if (ret)
+			goto err;
+	}
+
+	if (bios_data->version >= 4) {
+		ret = sysfs_create_ext_data_elt(bios_data_kobj,
+						bios_data->ext_data_elts);
+		if (ret)
+			goto err;
+	}
+
+	ret = 0;
+
+err:
+	iounmap(heap);
+	return ret;
+}
+
+/*
+ * OS to MLE Data Format
+ */
+
+static ssize_t show_os_mle_data(char *buf, u32 offset)
+{
+	void *heap;
+	struct os_mle_data *os_mle_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	os_mle_data = get_os_mle_data_start(heap);
+
+	switch (offset) {
+	case off_os_mle_raw:
+		ret = scnprintf(buf, PAGE_SIZE, "@0x%p, 0x%llx\n", os_mle_data,
+			       *((uint64_t *)os_mle_data - 1));
+		break;
+
+	case off_os_mle_version:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n", os_mle_data->version);
+		break;
+
+	case off_mbi:
+		ret = scnprintf(buf, PAGE_SIZE, "%p\n", os_mle_data->mbi);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	iounmap(heap);
+	return ret;
+}
+
+static ssize_t show_os_mle_data_raw(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_mle_data(buf, off_os_mle_raw);
+}
+static DEVICE_ATTR(os_mle_data_raw, S_IRUGO, show_os_mle_data_raw, NULL);
+
+static ssize_t show_os_mle_data_version(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return show_os_mle_data(buf, off_os_mle_version);
+}
+static DEVICE_ATTR(os_mle_data_version, S_IRUGO,
+		   show_os_mle_data_version, NULL);
+
+static ssize_t show_mbi(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	return show_os_mle_data(buf, off_mbi);
+}
+static DEVICE_ATTR(mbi, S_IRUGO, show_mbi, NULL);
+
+static struct attribute *os_mle_attr[] = {
+	&dev_attr_os_mle_data_raw.attr,
+	&dev_attr_os_mle_data_version.attr,
+	&dev_attr_mbi.attr,
+	NULL,
+};
+
+static struct attribute_group os_mle_attr_grp = {
+	.attrs = os_mle_attr
+};
+
+static ssize_t sysfs_create_os_mle_data(struct kobject *parent)
+{
+	struct kobject *os_mle_data;
+	int ret;
+
+	os_mle_data = kobject_create_and_add("os_mle_data", parent);
+	if (!os_mle_data)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(os_mle_data, &os_mle_attr_grp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * OS to SINIT Data Format
+ */
+
+static ssize_t show_os_sinit_data(char *buf, u32 offset)
+{
+	void *heap = NULL;
+	struct os_sinit_data *os_sinit_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	os_sinit_data = get_os_sinit_data_start(heap);
+
+	switch (offset) {
+	case off_os_sinit_raw:
+		ret = scnprintf(buf, PAGE_SIZE, "@0x%p, 0x%llx\n",
+			       os_sinit_data,
+			       *((uint64_t *)os_sinit_data - 1));
+		break;
+
+	case off_os_sinit_version:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
+			       os_sinit_data->version);
+		break;
+
+	case off_mle_ptab:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->mle_ptab);
+		break;
+
+	case off_mle_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx, %llu\n",
+			       os_sinit_data->mle_size,
+			       os_sinit_data->mle_size);
+		break;
+
+	case off_mle_hdr_base:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->mle_hdr_base);
+		break;
+
+	case off_vtd_pmr_lo_base:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->vtd_pmr_lo_base);
+		break;
+
+	case off_vtd_pmr_lo_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->vtd_pmr_lo_size);
+		break;
+
+	case off_vtd_pmr_hi_base:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->vtd_pmr_hi_base);
+		break;
+
+	case off_vtd_pmr_hi_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->vtd_pmr_hi_size);
+		break;
+
+	case off_lcp_po_base:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->lcp_po_base);
+		break;
+
+	case off_lcp_po_size:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx (%llu)\n",
+			       os_sinit_data->lcp_po_size,
+			       os_sinit_data->lcp_po_size);
+		break;
+
+	case off_caps_raw:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%08x\n",
+			       os_sinit_data->capabilities._raw);
+		break;
+
+	case off_caps_rlp_wake_getsec:
+		ret = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       os_sinit_data->capabilities.rlp_wake_getsec);
+		break;
+
+	case off_caps_rlp_wake_monitor:
+		ret = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       os_sinit_data->capabilities.rlp_wake_monitor);
+		break;
+
+	case off_caps_ecx_pgtbl:
+		ret = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       os_sinit_data->capabilities.ecx_pgtbl);
+		break;
+
+	case off_caps_pcr_map_no_legacy:
+		ret = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       os_sinit_data->capabilities.pcr_map_no_legacy);
+		break;
+
+	case off_caps_pcr_map_da:
+		ret = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       os_sinit_data->capabilities.pcr_map_da);
+		break;
+
+	case off_efi_rsdt_ptr:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       os_sinit_data->efi_rsdt_ptr);
+		break;
+
+	case off_event_elt_size:
+	case off_event_elt_addr:
+	case off_event_elt_container:
+	case off_event_elt_events:
+		ret = print_event_elt(buf, os_sinit_data->ext_data_elts,
+				     offset);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	iounmap(heap);
+	return ret;
+}
+
+static ssize_t show_event_elt_size(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_os_sinit_data(buf, off_event_elt_size);
+}
+static DEVICE_ATTR(event_log_size, S_IRUGO, show_event_elt_size, NULL);
+
+static ssize_t show_event_elt_addr(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_os_sinit_data(buf, off_event_elt_addr);
+}
+static DEVICE_ATTR(event_log_addr, S_IRUGO, show_event_elt_addr, NULL);
+
+static ssize_t show_event_elt_container(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return show_os_sinit_data(buf, off_event_elt_container);
+}
+static DEVICE_ATTR(event_log_container, S_IRUGO,
+		   show_event_elt_container, NULL);
+
+static ssize_t show_event_elt_events(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	return show_os_sinit_data(buf, off_event_elt_events);
+}
+static DEVICE_ATTR(events, S_IRUGO, show_event_elt_events, NULL);
+
+static struct attribute *event_elt_attr[] = {
+	&dev_attr_event_log_size.attr,
+	&dev_attr_event_log_addr.attr,
+	&dev_attr_event_log_container.attr,
+	&dev_attr_events.attr,
+	NULL,
+};
+
+static struct attribute_group event_elt_attr_grp = {
+	.attrs = event_elt_attr
+};
+
+static ssize_t show_os_sinit_data_raw(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_os_sinit_data(buf, off_os_sinit_raw);
+}
+static DEVICE_ATTR(os_sinit_data_raw, S_IRUGO, show_os_sinit_data_raw, NULL);
+
+static ssize_t show_os_sinit_data_version(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return show_os_sinit_data(buf, off_os_sinit_version);
+}
+static DEVICE_ATTR(os_sinit_data_version, S_IRUGO,
+		   show_os_sinit_data_version, NULL);
+
+static ssize_t show_mle_ptab(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_os_sinit_data(buf, off_mle_ptab);
+}
+static DEVICE_ATTR(mle_ptab, S_IRUGO, show_mle_ptab, NULL);
+
+static ssize_t show_mle_size(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_os_sinit_data(buf, off_mle_size);
+}
+static DEVICE_ATTR(mle_size, S_IRUGO, show_mle_size, NULL);
+
+static ssize_t show_mle_hdr_base(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_os_sinit_data(buf, off_mle_hdr_base);
+}
+static DEVICE_ATTR(mle_hdr_base, S_IRUGO, show_mle_hdr_base, NULL);
+
+static ssize_t show_vtd_pmr_lo_base(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_sinit_data(buf, off_vtd_pmr_lo_base);
+}
+static DEVICE_ATTR(vtd_pmr_lo_base, S_IRUGO, show_vtd_pmr_lo_base, NULL);
+
+static ssize_t show_vtd_pmr_lo_size(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_sinit_data(buf, off_vtd_pmr_lo_size);
+}
+static DEVICE_ATTR(vtd_pmr_lo_size, S_IRUGO, show_vtd_pmr_lo_size, NULL);
+
+static ssize_t show_vtd_pmr_hi_base(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_sinit_data(buf, off_vtd_pmr_hi_base);
+}
+static DEVICE_ATTR(vtd_pmr_hi_base, S_IRUGO, show_vtd_pmr_hi_base, NULL);
+
+static ssize_t show_vtd_pmr_hi_size(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_sinit_data(buf, off_vtd_pmr_hi_size);
+}
+static DEVICE_ATTR(vtd_pmr_hi_size, S_IRUGO, show_vtd_pmr_hi_size, NULL);
+
+static ssize_t show_lcp_po_base(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_os_sinit_data(buf, off_lcp_po_base);
+}
+static DEVICE_ATTR(lcp_po_base, S_IRUGO, show_lcp_po_base, NULL);
+
+static ssize_t show_lcp_po_size(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_os_sinit_data(buf, off_lcp_po_size);
+}
+static DEVICE_ATTR(lcp_po_size, S_IRUGO, show_lcp_po_size, NULL);
+
+static ssize_t show_caps_raw(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_raw);
+}
+static DEVICE_ATTR(caps_raw, S_IRUGO, show_caps_raw, NULL);
+
+static ssize_t show_caps_rlp_wake_getsec(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_rlp_wake_getsec);
+}
+static DEVICE_ATTR(caps_rlp_wake_getsec, S_IRUGO,
+		   show_caps_rlp_wake_getsec, NULL);
+
+static ssize_t show_caps_rlp_wake_monitor(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_rlp_wake_monitor);
+}
+static DEVICE_ATTR(caps_rlp_wake_monitor, S_IRUGO,
+		   show_caps_rlp_wake_monitor, NULL);
+
+static ssize_t show_caps_ecx_pgtbl(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_ecx_pgtbl);
+}
+static DEVICE_ATTR(caps_ecx_pgtbl, S_IRUGO, show_caps_ecx_pgtbl, NULL);
+
+static ssize_t show_caps_pcr_map_no_legacy(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_pcr_map_no_legacy);
+}
+static DEVICE_ATTR(caps_pcr_map_no_legacy, S_IRUGO,
+		   show_caps_pcr_map_no_legacy, NULL);
+
+static ssize_t show_caps_pcr_map_da(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_os_sinit_data(buf, off_caps_pcr_map_da);
+}
+static DEVICE_ATTR(caps_pcr_map_da, S_IRUGO,
+		   show_caps_pcr_map_da, NULL);
+
+static ssize_t show_efi_rsdt_ptr(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_os_sinit_data(buf, off_efi_rsdt_ptr);
+}
+static DEVICE_ATTR(efi_rsdt_ptr, S_IRUGO, show_efi_rsdt_ptr, NULL);
+
+static struct attribute *os_sinit_attr[] = {
+	&dev_attr_os_sinit_data_raw.attr,
+	&dev_attr_os_sinit_data_version.attr,
+	&dev_attr_mle_ptab.attr,
+	&dev_attr_mle_size.attr,
+	&dev_attr_mle_hdr_base.attr,
+	&dev_attr_vtd_pmr_lo_base.attr,
+	&dev_attr_vtd_pmr_lo_size.attr,
+	&dev_attr_vtd_pmr_hi_base.attr,
+	&dev_attr_vtd_pmr_hi_size.attr,
+	&dev_attr_lcp_po_base.attr,
+	&dev_attr_lcp_po_size.attr,
+	&dev_attr_caps_raw.attr,
+	&dev_attr_caps_rlp_wake_getsec.attr,
+	&dev_attr_caps_rlp_wake_monitor.attr,
+	&dev_attr_caps_ecx_pgtbl.attr,
+	&dev_attr_caps_pcr_map_no_legacy.attr,
+	&dev_attr_caps_pcr_map_da.attr,
+	NULL,
+};
+
+static struct attribute_group os_sinit_attr_grp = {
+	.attrs = os_sinit_attr
+};
+
+static ssize_t sysfs_create_os_sinit_data(struct kobject *parent)
+{
+	struct kobject *os_sinit_data_kobj;
+	void *heap;
+	struct os_sinit_data *os_sinit_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	os_sinit_data = get_os_sinit_data_start(heap);
+
+	os_sinit_data_kobj = kobject_create_and_add("os_sinit_data", parent);
+	if (!os_sinit_data_kobj) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = sysfs_create_group(os_sinit_data_kobj, &os_sinit_attr_grp);
+	if (ret)
+		goto err;
+
+	if (os_sinit_data->version >= 5) {
+		ret = sysfs_create_file(os_sinit_data_kobj,
+				       &dev_attr_efi_rsdt_ptr.attr);
+		if (ret)
+			goto err;
+	}
+
+	if (os_sinit_data->version >= 6) {
+		ret = sysfs_create_ext_data_elt(os_sinit_data_kobj,
+					       os_sinit_data->ext_data_elts);
+		if (ret)
+			goto err;
+	}
+
+	ret = 0;
+
+err:
+	iounmap(heap);
+	return ret;
+}
+
+/*
+ * SINIT to MLE Data Format
+ */
+
+static ssize_t print_sinit_mdrs(char *buf, struct sinit_mdr mdrs[],
+				uint32_t num)
+{
+	static const char * const mem_types[] = {
+		"GOOD",
+		"SMRAM OVERLAY",
+		"SMRAM NON-OVERLAY",
+		"PCIE EXTENDED CONFIG",
+		"PROTECTED"
+	};
+	uint32_t i;
+	char *str = buf;
+
+	for (i = 0; i < num; i++) {
+		str += scnprintf(str, PAGE_SIZE, "%016llx - %016llx ",
+				 mdrs[i].base, mdrs[i].base + mdrs[i].length);
+		if (mdrs[i].mem_type < sizeof(mem_types)/sizeof(mem_types[0]))
+			str += scnprintf(str, PAGE_SIZE, "(%s)\n",
+					 mem_types[mdrs[i].mem_type]);
+		else
+			str += scnprintf(str, PAGE_SIZE, "(%d)\n",
+					 (int)mdrs[i].mem_type);
+	}
+
+	return str - buf;
+}
+
+static ssize_t show_sinit_mle_data(char *buf, u32 offset)
+{
+	void *heap;
+	struct sinit_mle_data *sinit_mle_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	sinit_mle_data = get_sinit_mle_data_start(heap);
+
+	switch (offset) {
+	case off_sinit_mle_raw:
+		ret = scnprintf(buf, PAGE_SIZE, "@0x%p, 0x%llx\n",
+			       sinit_mle_data,
+			       *((uint64_t *)sinit_mle_data - 1));
+		break;
+
+	case off_sinit_mle_version:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
+			       sinit_mle_data->version);
+		break;
+
+	case off_bios_acm_id:
+		ret = print_hash(buf, sinit_mle_data->bios_acm_id);
+		break;
+
+	case off_edx_senter_flags:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%08x\n",
+			       sinit_mle_data->edx_senter_flags);
+		break;
+
+	case off_mseg_valid:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			       sinit_mle_data->mseg_valid);
+		break;
+
+	case off_sinit_hash:
+		ret = print_hash(buf, sinit_mle_data->sinit_hash);
+		break;
+
+	case off_mle_hash:
+		ret = print_hash(buf, sinit_mle_data->mle_hash);
+		break;
+
+	case off_stm_hash:
+		ret = print_hash(buf, sinit_mle_data->stm_hash);
+		break;
+
+	case off_lcp_policy_hash:
+		ret = print_hash(buf, sinit_mle_data->lcp_policy_hash);
+		break;
+
+	case off_lcp_policy_control:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%08x\n",
+			       sinit_mle_data->lcp_policy_control);
+		break;
+
+	case off_rlp_wakeup_addr:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%x\n",
+			       sinit_mle_data->rlp_wakeup_addr);
+		break;
+
+	case off_num_mdrs:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
+			       sinit_mle_data->num_mdrs);
+		break;
+
+	case off_mdrs_off:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%x\n",
+			       sinit_mle_data->mdrs_off);
+		break;
+
+	case off_num_vtd_dmars:
+		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
+			       sinit_mle_data->num_vtd_dmars);
+		break;
+
+	case off_vtd_dmars_off:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%x\n",
+			       sinit_mle_data->vtd_dmars_off);
+		break;
+
+	case off_sinit_mdrs:
+	{
+		struct sinit_mdr *mdrs;
+
+		mdrs = (struct sinit_mdr *)(((void *)sinit_mle_data -
+					     sizeof(uint64_t)) +
+					    sinit_mle_data->mdrs_off);
+		ret = print_sinit_mdrs(buf, mdrs, sinit_mle_data->num_mdrs);
+
+		break;
+	}
+
+	case off_proc_scrtm_status:
+		ret = scnprintf(buf, PAGE_SIZE, "0x%08x\n",
+			       sinit_mle_data->proc_scrtm_status);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	iounmap(heap);
+	return ret;
+}
+
+static ssize_t show_sinit_mle_data_raw(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return show_sinit_mle_data(buf, off_sinit_mle_raw);
+}
+static DEVICE_ATTR(sinit_mle_data_raw, S_IRUGO,
+		   show_sinit_mle_data_raw, NULL);
+
+static ssize_t show_sinit_mle_data_version(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return show_sinit_mle_data(buf, off_sinit_mle_version);
+}
+static DEVICE_ATTR(sinit_mle_data_version, S_IRUGO,
+		   show_sinit_mle_data_version, NULL);
+
+static ssize_t show_bios_acm_id(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_sinit_mle_data(buf, off_bios_acm_id);
+}
+static DEVICE_ATTR(bios_acm_id, S_IRUGO, show_bios_acm_id, NULL);
+
+static ssize_t show_edx_senter_flags(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	return show_sinit_mle_data(buf, off_edx_senter_flags);
+}
+static DEVICE_ATTR(edx_senter_flags, S_IRUGO, show_edx_senter_flags, NULL);
+
+static ssize_t show_mseg_valid(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return show_sinit_mle_data(buf, off_mseg_valid);
+}
+static DEVICE_ATTR(mseg_valid, S_IRUGO, show_mseg_valid, NULL);
+
+static ssize_t show_sinit_hash(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return show_sinit_mle_data(buf, off_sinit_hash);
+}
+static DEVICE_ATTR(sinit_hash, S_IRUGO, show_sinit_hash, NULL);
+
+static ssize_t show_mle_hash(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_sinit_mle_data(buf, off_mle_hash);
+}
+static DEVICE_ATTR(mle_hash, S_IRUGO, show_mle_hash, NULL);
+
+static ssize_t show_stm_hash(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	return show_sinit_mle_data(buf, off_stm_hash);
+}
+static DEVICE_ATTR(stm_hash, S_IRUGO, show_stm_hash, NULL);
+
+static ssize_t show_lcp_policy_hash(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_sinit_mle_data(buf, off_lcp_policy_hash);
+}
+static DEVICE_ATTR(lcp_policy_hash, S_IRUGO, show_lcp_policy_hash, NULL);
+
+static ssize_t show_lcp_policy_control(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return show_sinit_mle_data(buf, off_lcp_policy_control);
+}
+static DEVICE_ATTR(lcp_policy_control, S_IRUGO,
+		   show_lcp_policy_control, NULL);
+
+static ssize_t show_rlp_wakeup_addr(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	return show_sinit_mle_data(buf, off_rlp_wakeup_addr);
+}
+static DEVICE_ATTR(rlp_wakeup_addr, S_IRUGO, show_rlp_wakeup_addr, NULL);
+
+static ssize_t show_num_mdrs(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_sinit_mle_data(buf, off_num_mdrs);
+}
+static DEVICE_ATTR(num_mdrs, S_IRUGO, show_num_mdrs, NULL);
+
+static ssize_t show_mdrs_off(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return show_sinit_mle_data(buf, off_mdrs_off);
+}
+static DEVICE_ATTR(mdrs_off, S_IRUGO, show_mdrs_off, NULL);
+
+static ssize_t show_num_vtd_dmars(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_sinit_mle_data(buf, off_num_vtd_dmars);
+}
+static DEVICE_ATTR(num_vtd_dmars, S_IRUGO, show_num_vtd_dmars, NULL);
+
+static ssize_t show_vtd_dmars_off(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_sinit_mle_data(buf, off_vtd_dmars_off);
+}
+static DEVICE_ATTR(vtd_dmars_off, S_IRUGO, show_vtd_dmars_off, NULL);
+
+static ssize_t show_sinit_mdrs(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return show_sinit_mle_data(buf, off_sinit_mdrs);
+}
+static DEVICE_ATTR(sinit_mdrs, S_IRUGO, show_sinit_mdrs, NULL);
+
+static ssize_t show_proc_scrtm_status(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_sinit_mle_data(buf, off_proc_scrtm_status);
+}
+static DEVICE_ATTR(proc_scrtm_status, S_IRUGO, show_proc_scrtm_status, NULL);
+
+static struct attribute *sinit_mle_attr[] = {
+	&dev_attr_sinit_mle_data_raw.attr,
+	&dev_attr_sinit_mle_data_version.attr,
+	&dev_attr_bios_acm_id.attr,
+	&dev_attr_edx_senter_flags.attr,
+	&dev_attr_mseg_valid.attr,
+	&dev_attr_sinit_hash.attr,
+	&dev_attr_mle_hash.attr,
+	&dev_attr_stm_hash.attr,
+	&dev_attr_lcp_policy_hash.attr,
+	&dev_attr_lcp_policy_control.attr,
+	&dev_attr_rlp_wakeup_addr.attr,
+	&dev_attr_num_mdrs.attr,
+	&dev_attr_mdrs_off.attr,
+	&dev_attr_num_vtd_dmars.attr,
+	&dev_attr_vtd_dmars_off.attr,
+	&dev_attr_sinit_mdrs.attr,
+	NULL,
+};
+
+static struct attribute_group sinit_mle_attr_grp = {
+	.attrs = sinit_mle_attr
+};
+
+static ssize_t sysfs_create_sinit_mle_data(struct kobject *parent)
+{
+	struct kobject *sinit_mle_data_kobj;
+	void *heap;
+	struct sinit_mle_data *sinit_mle_data;
+	int ret;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	sinit_mle_data = get_sinit_mle_data_start(heap);
+
+	sinit_mle_data_kobj = kobject_create_and_add("sinit_mle_data", parent);
+	if (!sinit_mle_data_kobj) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = sysfs_create_group(sinit_mle_data_kobj, &sinit_mle_attr_grp);
+	if (ret)
+		goto err;
+
+	if (sinit_mle_data->version >= 8) {
+		ret = sysfs_create_file(sinit_mle_data_kobj,
+				       &dev_attr_proc_scrtm_status.attr);
+		if (ret)
+			goto err;
+	}
+
+	ret = 0;
+
+err:
+	iounmap(heap);
+	return ret;
+}
+
+/*
+ * Raw Binary Data in Heap Memory
+ */
+
+static ssize_t txt_show_binary_heap(struct file *filp, struct kobject *kobj,
+				    struct bin_attribute *attr, char *buf,
+				    loff_t off, size_t count)
+{
+	void *heap;
+
+	heap = get_txt_heap();
+	if (!heap)
+		return -ENOMEM;
+
+	if (off >= txt_heap_size) {
+		count = 0;
+	} else {
+		if (off + count > txt_heap_size)
+			count = txt_heap_size - off;
+		memcpy_fromio(buf, heap + off, count);
+	}
+
+	iounmap(heap);
+	return count;
+}
+
+static struct bin_attribute heap_bin_attr = {
+	.attr = {
+		.name = "binary_heap",
+		.mode = S_IRUGO,
+	},
+	.size = PAGE_SIZE,
+	.read = txt_show_binary_heap,
+};
+
+ssize_t sysfs_create_heap(struct kobject *parent)
+{
+	struct kobject *heap_kobj;
+	int retval;
+	void *base;
+
+	base = get_txt_heap();
+	if (!base || txt_heap_size == 0)
+		return -ENOMEM;
+
+	heap_bin_attr.size = txt_heap_size;
+	iounmap(base);
+
+	heap_kobj = kobject_create_and_add("heap", parent);
+	if (!heap_kobj)
+		return -ENOMEM;
+
+	retval = sysfs_create_bin_file(heap_kobj, &heap_bin_attr);
+	if (retval)
+		return retval;
+
+	retval = sysfs_create_bios_data(heap_kobj);
+	if (retval)
+		return retval;
+
+	retval = sysfs_create_os_mle_data(heap_kobj);
+	if (retval)
+		return retval;
+
+	retval = sysfs_create_os_sinit_data(heap_kobj);
+	if (retval)
+		return retval;
+
+	retval = sysfs_create_sinit_mle_data(heap_kobj);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_heap);
+
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/char/txt/txt-heap.h b/drivers/char/txt/txt-heap.h
new file mode 100644
index 0000000..b354948
--- /dev/null
+++ b/drivers/char/txt/txt-heap.h
@@ -0,0 +1,338 @@
+#ifndef __HEAP_H__
+#define __HEAP_H__
+
+#define off_bios_data_raw		101
+#define off_bios_data_version		102
+#define off_bios_sinit_size		103
+#define off_lcp_pd_base			104
+#define off_lcp_pd_size			105
+#define off_num_logical_procs		106
+#define off_flags			107
+
+#define off_os_mle_raw			201
+#define off_os_mle_version		202
+#define off_mbi				203
+
+#define off_os_sinit_raw		301
+#define off_os_sinit_version		302
+#define off_mle_ptab			303
+#define off_mle_size			304
+#define off_mle_hdr_base		305
+#define off_vtd_pmr_lo_base		306
+#define off_vtd_pmr_lo_size		307
+#define off_vtd_pmr_hi_base		308
+#define off_vtd_pmr_hi_size		309
+#define off_lcp_po_base			310
+#define off_lcp_po_size			311
+#define off_caps_raw			312
+#define off_caps_rlp_wake_getsec	313
+#define off_caps_rlp_wake_monitor	314
+#define off_caps_ecx_pgtbl		315
+#define off_caps_pcr_map_no_legacy	316
+#define off_caps_pcr_map_da		317
+#define off_efi_rsdt_ptr		318
+
+#define off_sinit_mle_raw		401
+#define off_sinit_mle_version		402
+#define off_bios_acm_id			403
+#define off_edx_senter_flags		404
+#define off_mseg_valid			405
+#define off_sinit_hash			406
+#define off_mle_hash			407
+#define off_stm_hash			408
+#define off_lcp_policy_hash		409
+#define off_lcp_policy_control		410
+#define off_rlp_wakeup_addr		411
+#define off_num_mdrs			412
+#define off_mdrs_off			413
+#define off_num_vtd_dmars		414
+#define off_vtd_dmars_off		415
+#define off_sinit_mdrs			416
+#define off_proc_scrtm_status		417
+
+#define off_bios_elt_major		501
+#define off_bios_elt_minor		502
+#define off_bios_elt_rev		503
+#define off_acm_elt_num_acms		504
+#define off_acm_elt_acm_addrs_index	505
+#define off_acm_elt_acm_addrs		506
+#define off_custom_elt_size		507
+#define off_custom_elt_uuid		508
+#define off_event_elt_size		509
+#define off_event_elt_addr		510
+#define off_event_elt_container		511
+#define off_event_elt_events		512
+
+#define SHA1_LENGTH 20
+
+/*
+ * Extensible TXT heap data structure
+ */
+struct heap_ext_data_element {
+	uint32_t type;
+	uint32_t size;
+	uint8_t  data[];
+} __packed;
+
+/*
+ * HEAP_END_ELEMENT
+ */
+#define HEAP_EXTDATA_TYPE_END			0
+
+/*
+ * HEAP_BIOS_SPEC_VER_ELEMENT
+ */
+#define HEAP_EXTDATA_TYPE_BIOS_SPEC_VER		1
+
+struct heap_bios_spec_ver_elt {
+	uint16_t spec_ver_major;
+	uint16_t spec_ver_minor;
+	uint16_t spec_ver_rev;
+} __packed;
+
+/*
+ * HEAP_ACM_ELEMENT
+ */
+#define HEAP_EXTDATA_TYPE_ACM			2
+
+struct heap_acm_elt {
+	uint32_t num_acms;
+	uint64_t acm_addrs[];
+} __packed;
+
+/*
+ * HEAP_CUSTOM_ELEMENT
+ */
+#define HEAP_EXTDATA_TYPE_CUSTOM		4
+
+struct heap_custom_elt {
+	struct uuid uuid;
+	uint8_t     data[];
+} __packed;
+
+/*
+ * HEAP_EVENT_LOG_POINTER_ELEMENT
+ */
+#define HEAP_EXTDATA_TYPE_TPM_EVENT_LOG_PTR	5
+
+struct heap_event_log_ptr_elt {
+	uint64_t event_log_phys_addr;
+} __packed;
+
+struct tpm12_pcr_event {
+	uint32_t pcr_index;
+	uint32_t type;
+	uint8_t  digest[SHA1_LENGTH];
+	uint32_t data_size;
+	uint8_t  data[];
+} __packed;
+
+struct event_log_container {
+	uint8_t  signature[20];
+	uint8_t  reserved[12];
+	uint8_t  container_ver_major;
+	uint8_t  container_ver_minor;
+	uint8_t  pcr_event_ver_major;
+	uint8_t  pcr_event_ver_minor;
+	uint32_t size;
+	uint32_t pcr_events_offset;
+	uint32_t next_event_offset;
+	struct tpm12_pcr_event pcr_events[];
+} __packed;
+
+/*
+ * data-passing structures contained in TXT heap:
+ *   - BIOS
+ *   - OS/loader to MLE
+ *   - OS/loader to SINIT
+ *   - SINIT to MLE
+ */
+
+/*
+ * BIOS structure
+ */
+struct bios_data {
+	uint32_t version;
+	uint32_t bios_sinit_size;
+	uint64_t lcp_pd_base;
+	uint64_t lcp_pd_size;
+	uint32_t num_logical_procs;
+	/* versions >= 3 */
+	uint64_t flags;
+	/* versions >= 4 */
+	struct heap_ext_data_element ext_data_elts[];
+} __packed;
+
+/*
+ * OS/loader to MLE structure
+ */
+#define MAX_LCP_PO_DATA_SIZE (64*1024)
+#define MAX_EVENT_LOG_SIZE   (4*1024)
+
+struct os_mle_data {
+	uint32_t version;
+	uint8_t  saved_mtrr_state;
+	uint8_t  *mbi;
+	uint32_t saved_misc_enable_msr;
+	uint8_t  lcp_po_data[MAX_LCP_PO_DATA_SIZE];
+	uint8_t  event_log_buffer[MAX_EVENT_LOG_SIZE];
+} __packed;
+
+/*
+ * SINIT/MLE capabilities
+ */
+union txt_caps {
+	uint32_t _raw;
+	struct {
+		uint32_t rlp_wake_getsec:1;
+		uint32_t rlp_wake_monitor:1;
+		uint32_t ecx_pgtbl:1;
+		uint32_t reserved1:1;
+		uint32_t pcr_map_no_legacy:1;
+		uint32_t pcr_map_da:1;
+		uint32_t reserved2:26;
+	};
+};
+
+/*
+ * OS/loader to SINIT structure
+ */
+struct os_sinit_data {
+	uint32_t version;
+	uint32_t reserved;
+	uint64_t mle_ptab;
+	uint64_t mle_size;
+	uint64_t mle_hdr_base;
+	uint64_t vtd_pmr_lo_base;
+	uint64_t vtd_pmr_lo_size;
+	uint64_t vtd_pmr_hi_base;
+	uint64_t vtd_pmr_hi_size;
+	uint64_t lcp_po_base;
+	uint64_t lcp_po_size;
+	union txt_caps capabilities;
+	/* versions >= 5 */
+	uint64_t    efi_rsdt_ptr;
+	/* versions >= 6 */
+	struct heap_ext_data_element  ext_data_elts[];
+} __packed;
+
+struct sinit_mdr {
+	uint64_t base;
+	uint64_t length;
+	uint8_t  mem_type;
+	uint8_t  reserved[7];
+} __packed;
+
+/*
+ * SINIT to MLE structure
+ */
+struct sinit_mle_data {
+	uint32_t version;
+	uint8_t  bios_acm_id[SHA1_LENGTH];
+	uint32_t edx_senter_flags;
+	uint64_t mseg_valid;
+	uint8_t  sinit_hash[SHA1_LENGTH];
+	uint8_t  mle_hash[SHA1_LENGTH];
+	uint8_t  stm_hash[SHA1_LENGTH];
+	uint8_t  lcp_policy_hash[SHA1_LENGTH];
+	uint32_t lcp_policy_control;
+	uint32_t rlp_wakeup_addr;
+	uint32_t reserved;
+	uint32_t num_mdrs;
+	uint32_t mdrs_off;
+	uint32_t num_vtd_dmars;
+	uint32_t vtd_dmars_off;
+	/* versions >= 8 */
+	uint32_t proc_scrtm_status;
+} __packed;
+
+/*
+ * TXT field accessor fns
+ */
+
+/*
+ * offset                 length                      field
+ * ------                 ------                      -----
+ *  0                     8                          bios_data_size
+ *  8                     bios_data_size - 8         bios_data
+ *
+ *  bios_data_size        8                          os_mle_data_size
+ *  bios_data_size +      os_mle_data_size - 8       os_mle_data
+ *   8
+ *
+ *  bios_data_size +      8                          os_sinit_data_size
+ *   os_mle_data_size
+ *  bios_data_size +      os_sinit_data_size - 8     os_sinit_data
+ *   os_mle_data_size +
+ *   8
+ *
+ *  bios_data_size +      8                          sinit_mle_data_size
+ *   os_mle_data_size +
+ *   os_sinit_data_size
+ *  bios_data_size +      sinit_mle_data_size - 8    sinit_mle_data
+ *   os_mle_data_size +
+ *   os_sinit_data_size +
+ *   8
+ */
+
+static inline uint64_t
+get_bios_data_size(const void *heap)
+{
+	return *(uint64_t *)heap;
+}
+
+static inline struct bios_data *
+get_bios_data_start(const void *heap)
+{
+	return (struct bios_data *)((char *)heap + sizeof(uint64_t));
+}
+
+static inline uint64_t
+get_os_mle_data_size(const void *heap)
+{
+	return *(uint64_t *)(heap + get_bios_data_size(heap));
+}
+
+static inline struct os_mle_data *
+get_os_mle_data_start(const void *heap)
+{
+	return (struct os_mle_data *)(heap + get_bios_data_size(heap) +
+				      sizeof(uint64_t));
+}
+
+static inline uint64_t
+get_os_sinit_data_size(const void *heap)
+{
+	return *(uint64_t *)(heap + get_bios_data_size(heap) +
+			     get_os_mle_data_size(heap));
+}
+
+static inline struct os_sinit_data *
+get_os_sinit_data_start(const void *heap)
+{
+	return (struct os_sinit_data *)(heap + get_bios_data_size(heap) +
+					get_os_mle_data_size(heap) +
+					sizeof(uint64_t));
+}
+
+static inline uint64_t
+get_sinit_mle_data_size(const void *heap)
+{
+	return *(uint64_t *)(heap + get_bios_data_size(heap) +
+			     get_os_mle_data_size(heap) +
+			     get_os_sinit_data_size(heap));
+}
+
+static inline struct sinit_mle_data *
+get_sinit_mle_data_start(const void *heap)
+{
+	return (struct sinit_mle_data *)(heap + get_bios_data_size(heap) +
+					 get_os_mle_data_size(heap) +
+					 get_os_sinit_data_size(heap) +
+					 sizeof(uint64_t));
+}
+
+extern ssize_t sysfs_create_heap(struct kobject *parent);
+
+#endif /* __HEAP_H__ */
+
diff --git a/drivers/char/txt/txt-sysfs.c b/drivers/char/txt/txt-sysfs.c
index 7b092bd..341e0eb 100644
--- a/drivers/char/txt/txt-sysfs.c
+++ b/drivers/char/txt/txt-sysfs.c
@@ -19,6 +19,7 @@
 #include "txt-config.h"
 #include "txt-log.h"
 #include "txt-parameter.h"
+#include "txt-heap.h"
 
 #define DEV_NAME "txt"
 struct platform_device *pdev;
@@ -43,6 +44,10 @@ static int __init txt_sysfs_init(void)
 	if (retval)
 		goto err;
 
+	retval = sysfs_create_heap(&pdev->dev.kobj);
+	if (retval)
+		goto err;
+
 	pr_info("Loading TXT module successfully\n");
 	return 0;
 
-- 
1.7.9.5

