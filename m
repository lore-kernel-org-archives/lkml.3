Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3HAKg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:36:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40575 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3HAKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:36:53 -0400
From: Rui Wang <ruiv.wang@gmail.com>
To: bhelgaas@google.com
Cc: tony.luck@intel.com, chaohong.guo@intel.com, gong.chen@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Rui Wang <rui.y.wang@intel.com>
Subject: [RFC v2 2/3] I/O Hook: kernel interface to manage the hook
Date: Thu,  1 Aug 2013 18:31:32 +0800
Message-Id: <1375353093-3206-3-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375353093-3206-1-git-send-email-rui.y.wang@intel.com>
References: <1375353093-3206-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following kernel functions used to add/delete/query Register
Overrides, and to start/stop the I/O Hook:
	hook_add_ovrd
	hook_query_ovrd
	hook_cleanup_ovrd
	hook_start_ovrd
	hook_stop_ovrd
	hook_get_status

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 drivers/misc/iohook/iohook.c |  151 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/iohook/iohook.c b/drivers/misc/iohook/iohook.c
index e410ece..be671d7 100644
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
+struct reg_ovrd *hook_query_ovrd(int spaceid, int idx)
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
+	pr_info("hook_query_ovrd() returns %p, idx=%d\n",
+		regentry, idx);
+	return regentry;
+
+}
+
+/* delete all Register Overrides from one space (IO/mem/pciconf) */
+void hook_cleanup_ovrd(int spaceid)
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
+void hook_add_ovrd(int spaceid, u64 address, u64 value, u64 mask,
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
+			pr_info("hook_add_ovrd(): 0x%llx already added, changed to 0x%llx, mask:0x%llx, attrib:0x%x\n",
+				address, ovrdreg->val, ovrdreg->bit_mask,
+				attrib);
+			goto out;
+		} else if (address >= ovrdreg->address &&
+			address < ovrdreg->address + ovrdreg->length) {
+			pr_info("hook_add_ovrd(): conflicting reg at 0x%llx, length:%llx, mask:0x%llx, attrib:0x%x\n",
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
+void hook_start_ovrd(void)
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
+void hook_stop_ovrd(void)
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
+int hook_get_status(void)
+{
+	return g_ovrd_on;
+}
+
 /* len should only be 1, 2, 4, 8 */
 static int mem_read(u64 address, int len, void *data)
 {
@@ -165,6 +310,9 @@ int read_ovrd_common(int spaceid, u64 address, int len, void *value, void *bus)
 
 	ret = -EINVAL;
 
+	if (!g_ovrd_on)
+		return ret;
+
 	if (spaceid == OVRD_SPACE_MEM) {
 		/* in the case of memory, 'address' is virtual */
 		vaddr = address;
@@ -295,6 +443,9 @@ int write_ovrd_common(int spaceid, u64 address, int len, void *data, void *bus)
 
 	ret = -EINVAL;
 
+	if (!g_ovrd_on)
+		return ret;
+
 	if (spaceid == OVRD_SPACE_MEM) {
 		ovrd_list = &ovrd_mem_reg_map;
 	} else if (spaceid == OVRD_SPACE_IO) {
-- 
1.7.5.4

