Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaHRO4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:56:34 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37897 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHRO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:56:32 -0400
Date: Mon, 18 Aug 2014 17:56:22 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: robert.w.love@intel.com, JBottomley@parallels.com,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] libfs: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818145622.GA14281@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/scsi/libfc/fc_libfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index 8d65a51a..c11a638 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -296,9 +296,9 @@ void fc_fc4_deregister_provider(enum fc_fh_type type, struct fc4_prov *prov)
 	BUG_ON(type >= FC_FC4_PROV_SIZE);
 	mutex_lock(&fc_prov_mutex);
 	if (prov->recv)
-		rcu_assign_pointer(fc_passive_prov[type], NULL);
+		RCU_INIT_POINTER(fc_passive_prov[type], NULL);
 	else
-		rcu_assign_pointer(fc_active_prov[type], NULL);
+		RCU_INIT_POINTER(fc_active_prov[type], NULL);
 	mutex_unlock(&fc_prov_mutex);
 	synchronize_rcu();
 }
-- 
1.9.1

