Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaFDN7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:59:13 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:59177 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaFDN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:58:28 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 1/4] GenWQE: Add sysfs interface for bitstream reload
Date: Wed,  4 Jun 2014 10:57:50 -0300
Message-Id: <1401890273-13067-2-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060413-1820-0000-0000-000000BD794C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface on sysfs for userspace to request a card
bitstream reload. It sets the appropriate register and try to perform a
fundamental reset on the PCIe slot for the card to reload the bitstream
from the chosen partition.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/sysfs-driver-genwqe |    9 +++
 drivers/misc/genwqe/card_base.c               |   90 +++++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c              |   25 +++++++
 include/uapi/linux/genwqe/genwqe_card.h       |    1 +
 4 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
index 1870737..64ac6d5 100644
--- a/Documentation/ABI/testing/sysfs-driver-genwqe
+++ b/Documentation/ABI/testing/sysfs-driver-genwqe
@@ -25,6 +25,15 @@ Date:           Oct 2013
 Contact:        haver@linux.vnet.ibm.com
 Description:    Interface to set the next bitstream to be used.
 
+What:           /sys/class/genwqe/genwqe<n>_card/reload_bitstream
+Date:           May 2014
+Contact:        klebers@linux.vnet.ibm.com
+Description:    Interface to trigger a PCIe card reset to reload the bitstream.
+                  sudo sh -c 'echo 1 > \
+                    /sys/class/genwqe/genwqe0_card/reload_bitstream'
+                If successfully, the card will come back with the bitstream set
+                on 'next_bitstream'.
+
 What:           /sys/class/genwqe/genwqe<n>_card/tempsens
 Date:           Oct 2013
 Contact:        haver@linux.vnet.ibm.com
diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index 74d51c9..e6cc3e1 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -761,6 +761,89 @@ static u64 genwqe_fir_checking(struct genwqe_dev *cd)
 }
 
 /**
+ * genwqe_pci_fundamental_reset() - trigger a PCIe fundamental reset on the slot
+ *
+ * Note: pci_set_pcie_reset_state() is not implemented on all archs, so this
+ * reset method will not work in all cases.
+ *
+ * Return: 0 on success or error code from pci_set_pcie_reset_state()
+ */
+static int genwqe_pci_fundamental_reset(struct pci_dev *pci_dev)
+{
+	int rc;
+
+	/*
+	 * lock pci config space access from userspace,
+	 * save state and issue PCIe fundamental reset
+	 */
+	pci_cfg_access_lock(pci_dev);
+	pci_save_state(pci_dev);
+	rc = pci_set_pcie_reset_state(pci_dev, pcie_warm_reset);
+	if (!rc) {
+		/* keep PCIe reset asserted for 250ms */
+		msleep(250);
+		pci_set_pcie_reset_state(pci_dev, pcie_deassert_reset);
+		/* Wait for 2s to reload flash and train the link */
+		msleep(2000);
+	}
+	pci_restore_state(pci_dev);
+	pci_cfg_access_unlock(pci_dev);
+	return rc;
+}
+
+/*
+ * genwqe_reload_bistream() - reload card bitstream
+ *
+ * Set the appropriate register and call fundamental reset to reaload the card
+ * bitstream.
+ *
+ * Return: 0 on success, error code otherwise
+ */
+static int genwqe_reload_bistream(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+	int rc;
+
+	dev_info(&pci_dev->dev,
+		 "[%s] resetting card for bitstream reload\n",
+		 __func__);
+
+	genwqe_stop(cd);
+
+	/*
+	 * Cause a CPLD reprogram with the 'next_bitstream'
+	 * partition on PCIe hot or fundamental reset
+	 */
+	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET,
+			(cd->softreset & 0xcull) | 0x70ull);
+
+	rc = genwqe_pci_fundamental_reset(pci_dev);
+	if (rc) {
+		/*
+		 * A fundamental reset failure can be caused
+		 * by lack of support on the arch, so we just
+		 * log the error and try to start the card
+		 * again.
+		 */
+		dev_err(&pci_dev->dev,
+			"[%s] err: failed to reset card for bitstream reload\n",
+			__func__);
+	}
+
+	rc = genwqe_start(cd);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"[%s] err: cannot start card services! (err=%d)\n",
+			__func__, rc);
+		return rc;
+	}
+	dev_info(&pci_dev->dev,
+		 "[%s] card reloaded\n", __func__);
+	return 0;
+}
+
+
+/**
  * genwqe_health_thread() - Health checking thread
  *
  * This thread is only started for the PF of the card.
@@ -846,6 +929,13 @@ static int genwqe_health_thread(void *data)
 			}
 		}
 
+		if (cd->card_state == GENWQE_CARD_RELOAD_BITSTREAM) {
+			/* Userspace requested card bitstream reload */
+			rc = genwqe_reload_bistream(cd);
+			if (rc)
+				goto fatal_error;
+		}
+
 		cd->last_gfir = gfir;
 		cond_resched();
 	}
diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
index a72a992..7232e40 100644
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -223,6 +223,30 @@ static ssize_t next_bitstream_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(next_bitstream);
 
+static ssize_t reload_bitstream_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int reload;
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+
+	if (kstrtoint(buf, 0, &reload) < 0)
+		return -EINVAL;
+
+	if (reload == 0x1) {
+		if (cd->card_state == GENWQE_CARD_UNUSED ||
+		    cd->card_state == GENWQE_CARD_USED)
+			cd->card_state = GENWQE_CARD_RELOAD_BITSTREAM;
+		else
+			return -EIO;
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+static DEVICE_ATTR_WO(reload_bitstream);
+
 /*
  * Create device_attribute structures / params: name, mode, show, store
  * additional flag if valid in VF
@@ -239,6 +263,7 @@ static struct attribute *genwqe_attributes[] = {
 	&dev_attr_status.attr,
 	&dev_attr_freerunning_timer.attr,
 	&dev_attr_queue_working_time.attr,
+	&dev_attr_reload_bitstream.attr,
 	NULL,
 };
 
diff --git a/include/uapi/linux/genwqe/genwqe_card.h b/include/uapi/linux/genwqe/genwqe_card.h
index 795e957..4fc065f 100644
--- a/include/uapi/linux/genwqe/genwqe_card.h
+++ b/include/uapi/linux/genwqe/genwqe_card.h
@@ -328,6 +328,7 @@ enum genwqe_card_state {
 	GENWQE_CARD_UNUSED = 0,
 	GENWQE_CARD_USED = 1,
 	GENWQE_CARD_FATAL_ERROR = 2,
+	GENWQE_CARD_RELOAD_BITSTREAM = 3,
 	GENWQE_CARD_STATE_MAX,
 };
 
-- 
1.7.1

