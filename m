Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaDNOtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:49:53 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34103 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaDNOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:47:06 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/7] ipmi: Reset the KCS timeout when starting error recovery
Date: Mon, 14 Apr 2014 09:46:52 -0500
Message-Id: <1397486816-18045-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397486816-18045-1-git-send-email-minyard@acm.org>
References: <1397486816-18045-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The OBF timer in KCS was not reset in one situation when error
recovery was started, resulting in an immediate timeout.

Reported-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_kcs_sm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index 6a4bdc1..8c25f59 100644
--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -251,8 +251,9 @@ static inline int check_obf(struct si_sm_data *kcs, unsigned char status,
 	if (!GET_STATUS_OBF(status)) {
 		kcs->obf_timeout -= time;
 		if (kcs->obf_timeout < 0) {
-		    start_error_recovery(kcs, "OBF not ready in time");
-		    return 1;
+			kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+			start_error_recovery(kcs, "OBF not ready in time");
+			return 1;
 		}
 		return 0;
 	}
-- 
1.8.3.1

