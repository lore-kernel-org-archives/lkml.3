Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3LQXnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:43:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab3LQXns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:43:48 -0500
Subject: [PATCH v2 2/4] pci: Add support for save/restore of extended
 capabilities
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 16:43:45 -0700
Message-ID: <20131217234345.2310.58636.stgit@bling.home>
In-Reply-To: <20131217233741.2310.78334.stgit@bling.home>
References: <20131217233741.2310.78334.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current save/restore is specific to standard capabilities.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c   |   43 +++++++++++++++++++++++++++++++++++--------
 include/linux/pci.h |    9 ++++++++-
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 848023f..c65d53c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -861,18 +861,28 @@ EXPORT_SYMBOL(pci_choose_state);
 #define PCI_EXP_SAVE_REGS	7
 
 
-static struct pci_cap_saved_state *pci_find_saved_cap(
-	struct pci_dev *pci_dev, char cap)
+static struct pci_cap_saved_state *_pci_find_saved_cap(struct pci_dev *pci_dev,
+						       u16 cap, bool extended)
 {
 	struct pci_cap_saved_state *tmp;
 
 	hlist_for_each_entry(tmp, &pci_dev->saved_cap_space, next) {
-		if (tmp->cap.cap_nr == cap)
+		if (tmp->cap.cap_extended == extended && tmp->cap.cap_nr == cap)
 			return tmp;
 	}
 	return NULL;
 }
 
+struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap)
+{
+	return _pci_find_saved_cap(dev, cap, false);
+}
+
+struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev, u16 cap)
+{
+	return _pci_find_saved_cap(dev, cap, true);
+}
+
 static int pci_save_pcie_state(struct pci_dev *dev)
 {
 	int i = 0;
@@ -1113,7 +1123,7 @@ int pci_load_saved_state(struct pci_dev *dev, struct pci_saved_state *state)
 	while (cap->size) {
 		struct pci_cap_saved_state *tmp;
 
-		tmp = pci_find_saved_cap(dev, cap->cap_nr);
+		tmp = _pci_find_saved_cap(dev, cap->cap_nr, cap->cap_extended);
 		if (!tmp || tmp->cap.size != cap->size)
 			return -EINVAL;
 
@@ -2047,18 +2057,24 @@ static void pci_add_saved_cap(struct pci_dev *pci_dev,
 }
 
 /**
- * pci_add_cap_save_buffer - allocate buffer for saving given capability registers
+ * _pci_add_cap_save_buffer - allocate buffer for saving given
+ *                            capability registers
  * @dev: the PCI device
  * @cap: the capability to allocate the buffer for
+ * @extended: Standard or Extended capability ID
  * @size: requested size of the buffer
  */
-static int pci_add_cap_save_buffer(
-	struct pci_dev *dev, char cap, unsigned int size)
+static int _pci_add_cap_save_buffer(struct pci_dev *dev, u16 cap,
+				    bool extended, unsigned int size)
 {
 	int pos;
 	struct pci_cap_saved_state *save_state;
 
-	pos = pci_find_capability(dev, cap);
+	if (extended)
+		pos = pci_find_ext_capability(dev, cap);
+	else
+		pos = pci_find_capability(dev, cap);
+
 	if (pos <= 0)
 		return 0;
 
@@ -2067,12 +2083,23 @@ static int pci_add_cap_save_buffer(
 		return -ENOMEM;
 
 	save_state->cap.cap_nr = cap;
+	save_state->cap.cap_extended = extended;
 	save_state->cap.size = size;
 	pci_add_saved_cap(dev, save_state);
 
 	return 0;
 }
 
+int pci_add_cap_save_buffer(struct pci_dev *dev, char cap, unsigned int size)
+{
+	return _pci_add_cap_save_buffer(dev, cap, false, size);
+}
+
+int pci_add_ext_cap_save_buffer(struct pci_dev *dev, u16 cap, unsigned int size)
+{
+	return _pci_add_cap_save_buffer(dev, cap, true, size);
+}
+
 /**
  * pci_allocate_cap_save_buffers - allocate buffers for saving capabilities
  * @dev: the PCI device
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e661333..ebbd311 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -224,7 +224,8 @@ enum pci_bus_speed {
 };
 
 struct pci_cap_saved_data {
-	char cap_nr;
+	u16 cap_nr;
+	bool cap_extended;
 	unsigned int size;
 	u32 data[0];
 };
@@ -978,6 +979,12 @@ struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev);
 int pci_load_saved_state(struct pci_dev *dev, struct pci_saved_state *state);
 int pci_load_and_free_saved_state(struct pci_dev *dev,
 				  struct pci_saved_state **state);
+struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
+struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
+						   u16 cap);
+int pci_add_cap_save_buffer(struct pci_dev *dev, char cap, unsigned int size);
+int pci_add_ext_cap_save_buffer(struct pci_dev *dev,
+				u16 cap, unsigned int size);
 int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);

