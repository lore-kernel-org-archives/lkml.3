Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936022AbaBDWeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:34:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792AbaBDVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:07:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.12 016/133] usb: chipidea: need to mask INT_STATUS when write otgsc
Date: Tue,  4 Feb 2014 13:06:57 -0800
Message-Id: <20140204210737.479192551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 5332ff1fb63c46588656e4208201bc131627c878 upstream.

For otgsc, both enable bits and status bits are in it. So we need
to make sure the status bits are not be cleared when write enable
bits. It can fix one bug that we plug in/out Micro AB cable fast,
and sometimes, the IDIS will be cleared wrongly when handle last
ID interrupt (ID 0->1), so the current interrupt will not occur.

For stable tree: 3.12+

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/otg.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/chipidea/otg.h
+++ b/drivers/usb/chipidea/otg.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Freescale Semiconductor, Inc.
+ * Copyright (C) 2013-2014 Freescale Semiconductor, Inc.
  *
  * Author: Peter Chen
  *
@@ -19,12 +19,12 @@ static inline void ci_clear_otg_interrup
 
 static inline void ci_enable_otg_interrupt(struct ci_hdrc *ci, u32 bits)
 {
-	hw_write(ci, OP_OTGSC, bits, bits);
+	hw_write(ci, OP_OTGSC, bits | OTGSC_INT_STATUS_BITS, bits);
 }
 
 static inline void ci_disable_otg_interrupt(struct ci_hdrc *ci, u32 bits)
 {
-	hw_write(ci, OP_OTGSC, bits, 0);
+	hw_write(ci, OP_OTGSC, bits | OTGSC_INT_STATUS_BITS, 0);
 }
 
 int ci_hdrc_otg_init(struct ci_hdrc *ci);


