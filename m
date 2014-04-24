Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaDXI4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:56:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaDXI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, minyard@acm.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 180/182] ipmi: Reset the KCS timeout when starting error recovery
Date: Thu, 24 Apr 2014 09:51:45 +0100
Message-Id: <1398329507-5911-181-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

commit eb6d78ec213e6938559b801421d64714dafcf4b2 upstream.

The OBF timer in KCS was not reset in one situation when error recovery
was started, resulting in an immediate timeout.

Reported-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: minyard@acm.org
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/ipmi/ipmi_kcs_sm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index e53fc24..e1ddcf9 100644
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
1.9.1

