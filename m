Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3GZG4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:56:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57526 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3GZG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:56:24 -0400
From: Rui Wang <ruiv.wang@gmail.com>
To: bhelgaas@google.com
Cc: tony.luck@intel.com, chaohong.guo@intel.com, gong.chen@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>
Subject: [RFC 2/3] IO Hook: kernel interface to manage the hook
Date: Fri, 26 Jul 2013 14:51:14 +0800
Message-Id: <1374821475-3196-3-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
References: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following kernel functions are exported:
	hook_add_ovrd
	hook_query_ovrd
	hook_cleanup_ovrd
	hook_start_ovrd
	hook_stop_ovrd
	hook_get_status
Kernel modules can use them to add/delete/query Register Overrides, and
to start/stop the hook engine.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 drivers/pci/access.c     |  150 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/reg_ovrd.h |    9 +++
 2 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index fe7b282..81428655 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -27,6 +27,156 @@ LIST_HEAD(ovrd_pci_conf_reg_map);
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
+EXPORT_SYMBOL(hook_query_ovrd);
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
+EXPORT_SYMBOL(hook_cleanup_ovrd);
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
+EXPORT_SYMBOL(hook_add_ovrd);
+
+/* to start the hook */
+void hook_start_ovrd(void)
+{
+	unsigned long lock_flags = 0;
+
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	if (g_ovrd_on)
+		goto done;
+
+	static_key_slow_inc(&ovrdhw_enabled);
+	g_ovrd_on = 1;
+done:
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+}
+EXPORT_SYMBOL(hook_start_ovrd);
+
+/* to stop the hook */
+void hook_stop_ovrd(void)
+{
+	unsigned long lock_flags = 0;
+
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	if (!g_ovrd_on)
+		goto done;
+	g_ovrd_on = 0;
+	static_key_slow_dec(&ovrdhw_enabled);
+done:
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+}
+EXPORT_SYMBOL(hook_stop_ovrd);
+
+int hook_get_status()
+{
+	return g_ovrd_on;
+}
+EXPORT_SYMBOL(hook_get_status);
+
 /* len should only be 1, 2, 4, 8 */
 static int mem_read(u64 address, int len, void *data)
 {
diff --git a/include/linux/reg_ovrd.h b/include/linux/reg_ovrd.h
index 5f851fe..7a81b58 100644
--- a/include/linux/reg_ovrd.h
+++ b/include/linux/reg_ovrd.h
@@ -42,5 +42,14 @@ struct reg_ovrd {
 #define PCI_DECODE_BUSN(x)	((u8)(((x) >> 20) & 0xff))
 #define PCI_DECODE_DOMAIN(x)	((u32)((x) >> 32))
 
+#ifdef CONFIG_IO_HOOK
+void hook_add_ovrd(int spaceid, u64 address, u64 value, u64 mask,
+		u32 length, u8 attrib);
+struct reg_ovrd *hook_query_ovrd(int spaceid, int idx);
+void hook_cleanup_ovrd(int spaceid);
+void hook_start_ovrd(void);
+void hook_stop_ovrd(void);
+int hook_get_status(void);
+#endif /* CONFIG_IO_HOOK */
 
 #endif			/* __REG_OVRD_H__ */
-- 
1.7.5.4

