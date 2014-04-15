Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaDON7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:59:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:27346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbaDON7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:59:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="513522792"
From: Rui Wang <rui.y.wang@intel.com>
To: bhelgaas@google.com, tony.luck@intel.com, rafael.j.wysocki@intel.com
Cc: ruiv.wang@gmail.com, chaohong.guo@intel.com, dave.hansen@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v3 2/5] I/O Hook: Help functions to manage the hook
Date: Tue, 15 Apr 2014 21:48:08 +0800
Message-Id: <1397569691-24691-3-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1397569691-24691-1-git-send-email-rui.y.wang@intel.com>
References: <1397569691-24691-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following kernel helper functions used to add/delete/query Register
Overrides, and to start/stop the I/O Hook:
        iohook_add_ovrd
        iohook_query_ovrd
        iohook_cleanup_ovrd
        iohook_start_ovrd
        iohook_stop_ovrd
        iohook_get_status

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 drivers/misc/iohook/iohook.c |  151 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/iohook/iohook.c b/drivers/misc/iohook/iohook.c
index e6a626f..d8c41d0 100644
--- a/drivers/misc/iohook/iohook.c
+++ b/drivers/misc/iohook/iohook.c
@@ -6,6 +6,7 @@
 #include "iohook.h"
 
 static DEFINE_RAW_SPINLOCK(io_hook_lock);
+static DEFINE_RAW_SPINLOCK(engine_lock);
 
 LIST_HEAD(ovrd_io_reg_map);
 LIST_HEAD(ovrd_mem_reg_map);
@@ -14,6 +15,150 @@ LIST_HEAD(ovrd_pci_conf_reg_map);
 struct static_key ovrdhw_enabled = STATIC_KEY_INIT_FALSE;
 EXPORT_SYMBOL(ovrdhw_enabled);
 
+int	g_ovrd_on;
+/* query a Register Override given spaceid and index */
+struct reg_ovrd *iohook_query_ovrd(int spaceid, int idx)
+{
+	struct list_head *reg_ovrd;
+	struct reg_ovrd *ovrdreg, *regentry;
+	unsigned long lock_flags = 0;
+	int n = 0;
+
+	if (spaceid == OVRD_SPACE_MEM)
+		reg_ovrd = &ovrd_mem_reg_map;
+	else if (spaceid == OVRD_SPACE_IO)
+		reg_ovrd = &ovrd_io_reg_map;
+	else
+		reg_ovrd = &ovrd_pci_conf_reg_map;
+
+	regentry = NULL;
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	list_for_each_entry(ovrdreg, reg_ovrd, node) {
+		if (n++ >= idx) {
+			regentry = ovrdreg;
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+	pr_info("iohook_query_ovrd() returns %p, idx=%d\n",
+		regentry, idx);
+	return regentry;
+
+}
+
+/* delete all Register Overrides from one space (IO/mem/pciconf) */
+void iohook_cleanup_ovrd(int spaceid)
+{
+	struct list_head *tmp, *next, *ovrd_list;
+
+	if (spaceid == OVRD_SPACE_MEM)
+		ovrd_list = &ovrd_mem_reg_map;
+	else if (spaceid == OVRD_SPACE_IO)
+		ovrd_list = &ovrd_io_reg_map;
+	else
+		ovrd_list = &ovrd_pci_conf_reg_map;
+
+	list_for_each_safe(tmp, next, ovrd_list) {
+		struct reg_ovrd *ovrdreg =
+		    list_entry(tmp, struct reg_ovrd, node);
+		list_del(tmp);
+		kfree(ovrdreg);
+	}
+}
+
+/* for pci config space, address is encoded per PCI_ENCODE_ADDR() */
+void iohook_add_ovrd(int spaceid, u64 address, u64 value, u64 mask,
+		u32 length, u8 attrib)
+{
+	struct list_head *reg_ovrd;
+	struct reg_ovrd *ovrdreg;
+	unsigned long lock_flags = 0;
+
+	if (spaceid == OVRD_SPACE_MEM)
+		reg_ovrd = &ovrd_mem_reg_map;
+	else if (spaceid == OVRD_SPACE_IO)
+		reg_ovrd = &ovrd_io_reg_map;
+	else
+		reg_ovrd = &ovrd_pci_conf_reg_map;
+
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	list_for_each_entry(ovrdreg, reg_ovrd, node) {
+		if (ovrdreg->address == address &&
+			ovrdreg->attrib == attrib &&
+			ovrdreg->length == length) {
+			/* if already added the address, just change the bits */
+			ovrdreg->bit_mask |= mask;
+			ovrdreg->val |= value;
+			pr_info("iohook_add_ovrd(): 0x%llx already added, changed to 0x%llx, mask:0x%llx, attrib:0x%x\n",
+				address, ovrdreg->val, ovrdreg->bit_mask,
+				attrib);
+			goto out;
+		} else if (address >= ovrdreg->address &&
+			address < ovrdreg->address + ovrdreg->length) {
+			pr_info("iohook_add_ovrd(): conflicting reg at 0x%llx, length:%llx, mask:0x%llx, attrib:0x%x\n",
+				address, ovrdreg->val, ovrdreg->bit_mask,
+				attrib);
+			goto out;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+	ovrdreg = kmalloc(sizeof(struct reg_ovrd), GFP_ATOMIC);
+	if (!ovrdreg) {
+		pr_info("failed to alloc Reg Override!\n");
+		return;
+	}
+
+	ovrdreg->address = address;
+	ovrdreg->val = value;
+	ovrdreg->length = length;
+	ovrdreg->bit_mask = mask;
+	ovrdreg->attrib = attrib;
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	list_add_tail(&ovrdreg->node, reg_ovrd);
+out:
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+}
+
+/* to start the hook */
+void iohook_start_ovrd(void)
+{
+	unsigned long lock_flags = 0;
+
+	raw_spin_lock_irqsave(&engine_lock, lock_flags);
+	if (g_ovrd_on)
+		goto done;
+
+	static_key_slow_inc(&ovrdhw_enabled);
+	g_ovrd_on = 1;
+done:
+	raw_spin_unlock_irqrestore(&engine_lock, lock_flags);
+
+}
+
+/* to stop the hook */
+void iohook_stop_ovrd(void)
+{
+	unsigned long lock_flags = 0;
+
+	raw_spin_lock_irqsave(&engine_lock, lock_flags);
+	if (!g_ovrd_on)
+		goto done;
+	g_ovrd_on = 0;
+	static_key_slow_dec(&ovrdhw_enabled);
+done:
+	raw_spin_unlock_irqrestore(&engine_lock, lock_flags);
+
+}
+
+int iohook_get_status(void)
+{
+	return g_ovrd_on;
+}
+
 /* len should only be 1, 2, 4, 8 */
 static int mem_read(u64 address, int len, void *data)
 {
@@ -170,6 +315,9 @@ int read_ovrd_common(int spaceid, u64 address, int len, void *value, void *bus)
 
 	ret = -EINVAL;
 
+	if (!g_ovrd_on)
+		return ret;
+
 	if (spaceid == OVRD_SPACE_MEM) {
 		/* in the case of memory, 'address' is virtual */
 		vaddr = address;
@@ -300,6 +448,9 @@ int write_ovrd_common(int spaceid, u64 address, int len, void *data, void *bus)
 
 	ret = -EINVAL;
 
+	if (!g_ovrd_on)
+		return ret;
+
 	if (spaceid == OVRD_SPACE_MEM) {
 		/* in the case of memory, 'address' is virtual */
 		vaddr = address;
-- 
1.7.5.4

