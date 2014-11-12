Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaKLVnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:43:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:48730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbaKLVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:43:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,371,1413270000"; 
   d="scan'208";a="606877524"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next] mei: kill cached host and me csr values
Date: Wed, 12 Nov 2014 23:42:14 +0200
Message-Id: <1415828534-2254-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill host_hw_status and me_hw_state from me hw structure that used
to cache host and me csr values.
We do not use the cached values across the function calls anymore

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c | 30 ++++++++++++++++--------------
 drivers/misc/mei/hw-me.h |  7 -------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 4f2fd6fc1e23..7ce7cf4b6092 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -270,10 +270,10 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 
-	hw->host_hw_state = mei_hcsr_read(hw);
-	hw->host_hw_state |= H_IE | H_IG | H_RDY;
-	mei_hcsr_set(hw, hw->host_hw_state);
+	hcsr |= H_IE | H_IG | H_RDY;
+	mei_hcsr_set(hw, hcsr);
 }
 
 /**
@@ -285,9 +285,9 @@ static void mei_me_host_set_ready(struct mei_device *dev)
 static bool mei_me_host_is_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 
-	hw->host_hw_state = mei_hcsr_read(hw);
-	return (hw->host_hw_state & H_RDY) == H_RDY;
+	return (hcsr & H_RDY) == H_RDY;
 }
 
 /**
@@ -299,9 +299,9 @@ static bool mei_me_host_is_ready(struct mei_device *dev)
 static bool mei_me_hw_is_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 mecsr = mei_me_mecsr_read(hw);
 
-	hw->me_hw_state = mei_me_mecsr_read(hw);
-	return (hw->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
+	return (mecsr & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
 /**
@@ -356,12 +356,13 @@ static int mei_me_hw_start(struct mei_device *dev)
 static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr;
 	char read_ptr, write_ptr;
 
-	hw->host_hw_state = mei_hcsr_read(hw);
+	hcsr = mei_hcsr_read(hw);
 
-	read_ptr = (char) ((hw->host_hw_state & H_CBRP) >> 8);
-	write_ptr = (char) ((hw->host_hw_state & H_CBWP) >> 16);
+	read_ptr = (char) ((hcsr & H_CBRP) >> 8);
+	write_ptr = (char) ((hcsr & H_CBWP) >> 16);
 
 	return (unsigned char) (write_ptr - read_ptr);
 }
@@ -474,13 +475,14 @@ static int mei_me_write_message(struct mei_device *dev,
 static int mei_me_count_full_read_slots(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 me_csr;
 	char read_ptr, write_ptr;
 	unsigned char buffer_depth, filled_slots;
 
-	hw->me_hw_state = mei_me_mecsr_read(hw);
-	buffer_depth = (unsigned char)((hw->me_hw_state & ME_CBD_HRA) >> 24);
-	read_ptr = (char) ((hw->me_hw_state & ME_CBRP_HRA) >> 8);
-	write_ptr = (char) ((hw->me_hw_state & ME_CBWP_HRA) >> 16);
+	me_csr = mei_me_mecsr_read(hw);
+	buffer_depth = (unsigned char)((me_csr & ME_CBD_HRA) >> 24);
+	read_ptr = (char) ((me_csr & ME_CBRP_HRA) >> 8);
+	write_ptr = (char) ((me_csr & ME_CBWP_HRA) >> 16);
 	filled_slots = (unsigned char) (write_ptr - read_ptr);
 
 	/* check for overflow */
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index e6a59a62573a..e44ed1d03911 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -51,18 +51,11 @@ struct mei_cfg {
  *
  * @cfg: per device generation config and ops
  * @mem_addr:  io memory address
- * @host_hw_state: cached host state
- * @me_hw_state:   cached me (fw) state
  * @pg_state:      power gating state
  */
 struct mei_me_hw {
 	const struct mei_cfg *cfg;
 	void __iomem *mem_addr;
-	/*
-	 * hw states of host and fw(ME)
-	 */
-	u32 host_hw_state;
-	u32 me_hw_state;
 	enum mei_pg_state pg_state;
 };
 
-- 
1.9.3

