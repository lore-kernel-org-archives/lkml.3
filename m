Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565AbaFIJRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58389 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/146] ipmi: Reset the KCS timeout when starting error recovery
Date: Mon,  9 Jun 2014 10:49:21 +0200
Message-Id: <e818ab1909b45811829875764d6a78041f303c09.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit eb6d78ec213e6938559b801421d64714dafcf4b2 upstream.

The OBF timer in KCS was not reset in one situation when error recovery
was started, resulting in an immediate timeout.

Reported-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/ipmi/ipmi_kcs_sm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index e53fc24c6af3..e1ddcf938519 100644
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
1.9.3

