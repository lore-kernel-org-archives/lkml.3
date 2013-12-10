Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3LJSsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3LJSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:48:47 -0500
Subject: [PATCH 2/3] pci: Add support for save/restore of extended
 capabilities
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 10 Dec 2013 11:48:39 -0700
Message-ID: <20131210184839.26294.4912.stgit@bling.home>
In-Reply-To: <20131210183339.26294.14581.stgit@bling.home>
References: <20131210183339.26294.14581.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current save/restore is specific to standard capabilities.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c   |   47 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/pci.h |    3 ++-
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 05868e4..a898e4e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -861,18 +861,30 @@ EXPORT_SYMBOL(pci_choose_state);
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
 
+static struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev,
+						      char cap)
+{
+	return _pci_find_saved_cap(dev, cap, false);
+}
+
+static struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
+							  u16 cap)
+{
+	return _pci_find_saved_cap(dev, cap, true);
+}
+
 static int pci_save_pcie_state(struct pci_dev *dev)
 {
 	int i = 0;
@@ -1113,7 +1125,7 @@ int pci_load_saved_state(struct pci_dev *dev, struct pci_saved_state *state)
 	while (cap->size) {
 		struct pci_cap_saved_state *tmp;
 
-		tmp = pci_find_saved_cap(dev, cap->cap_nr);
+		tmp = _pci_find_saved_cap(dev, cap->cap_nr, cap->cap_extended);
 		if (!tmp || tmp->cap.size != cap->size)
 			return -EINVAL;
 
@@ -2047,18 +2059,24 @@ static void pci_add_saved_cap(struct pci_dev *pci_dev,
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
 
@@ -2067,12 +2085,25 @@ static int pci_add_cap_save_buffer(
 		return -ENOMEM;
 
 	save_state->cap.cap_nr = cap;
+	save_state->cap.cap_extended = extended;
 	save_state->cap.size = size;
 	pci_add_saved_cap(dev, save_state);
 
 	return 0;
 }
 
+static int pci_add_cap_save_buffer(struct pci_dev *dev,
+				   char cap, unsigned int size)
+{
+	return _pci_add_cap_save_buffer(dev, cap, false, size);
+}
+
+static int pci_add_ext_cap_save_buffer(struct pci_dev *dev,
+				       u16 cap, unsigned int size)
+{
+	return _pci_add_cap_save_buffer(dev, cap, true, size);
+}
+
 /**
  * pci_allocate_cap_save_buffers - allocate buffers for saving capabilities
  * @dev: the PCI device
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1084a15..adcc948 100644
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

