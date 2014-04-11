Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbaDKM7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:59:04 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62351 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaDKM7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:59:02 -0400
Message-ID: <5347E712.2010202@gmail.com>
Date: Fri, 11 Apr 2014 14:58:58 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rts5139: fix bad symbol declaration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With sparse, the following error appears :
  CHECK   drivers/staging/rts5139/ms_mg.c
drivers/staging/rts5139/ms_mg.c:82:5: warning: symbol 'mg_set_tpc_para_sub' was not declared. Should it be static?

Rename function with correct prefix and move declaration to coherent internal header file.

Signed-off-by: Neil 'Superna' Armstrong <superna9999@gmail.com>
---
 drivers/staging/rts5139/ms.c    |    7 ++-----
 drivers/staging/rts5139/ms_mg.c |    2 +-
 drivers/staging/rts5139/ms_mg.h |    1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts5139/ms.c b/drivers/staging/rts5139/ms.c
index 390292a..a843a2f 100644
--- a/drivers/staging/rts5139/ms.c
+++ b/drivers/staging/rts5139/ms.c
@@ -36,6 +36,7 @@
 #include "rts51x_scsi.h"
 #include "rts51x_card.h"
 #include "ms.h"
+#include "ms_mg.h"
 
 static inline void ms_set_err_code(struct rts51x_chip *chip, u8 err_code)
 {
@@ -1183,10 +1184,6 @@ static int ms_read_attribute_info(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-#ifdef SUPPORT_MAGIC_GATE
-int mg_set_tpc_para_sub(struct rts51x_chip *chip, int type, u8 mg_entry_num);
-#endif
-
 static int reset_ms_pro(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -1232,7 +1229,7 @@ Retry:
 #endif
 
 #ifdef SUPPORT_MAGIC_GATE
-	retval = mg_set_tpc_para_sub(chip, 0, 0);
+	retval = rts51x_mg_set_tpc_para_sub(chip, 0, 0);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 #endif
diff --git a/drivers/staging/rts5139/ms_mg.c b/drivers/staging/rts5139/ms_mg.c
index 00862c1..c8f2606 100644
--- a/drivers/staging/rts5139/ms_mg.c
+++ b/drivers/staging/rts5139/ms_mg.c
@@ -79,7 +79,7 @@ static int mg_send_ex_cmd(struct rts51x_chip *chip, u8 cmd, u8 entry_num)
 	return STATUS_SUCCESS;
 }
 
-int mg_set_tpc_para_sub(struct rts51x_chip *chip, int type, u8 mg_entry_num)
+int rts51x_mg_set_tpc_para_sub(struct rts51x_chip *chip, int type, u8 mg_entry_num)
 {
 	int retval;
 	u8 buf[6];
diff --git a/drivers/staging/rts5139/ms_mg.h b/drivers/staging/rts5139/ms_mg.h
index d15733a..109c712 100644
--- a/drivers/staging/rts5139/ms_mg.h
+++ b/drivers/staging/rts5139/ms_mg.h
@@ -30,6 +30,7 @@
 #include "rts51x_chip.h"
 #include "ms.h"
 
+int rts51x_mg_set_tpc_para_sub(struct rts51x_chip *chip, int type, u8 mg_entry_num);
 int rts51x_mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip);
 int rts51x_mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip);
 int rts51x_mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-- 
1.7.10.4
