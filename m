Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3DSFPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 01:15:45 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57861 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3DSFPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 01:15:42 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] e1000e: fix mismatch in mutex lock-unlock in e1000_reset_hw_82571()
Date: Thu, 18 Apr 2013 22:15:18 -0700
Message-Id: <1366348518-5594-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If e1000_get_hw_semaphore_82574() succeed, it acquires swflag_mutex,
otherwise it does not. But the returned value of
e1000_get_hw_semaphore_82574() is ignored, so unlocking of swflag_mutex
happens anyway.

The patch fixes the issue by breaking reset if MIC ownership is not acquired.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/ethernet/intel/e1000e/82571.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 2faffbd..a6bd80e 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -1003,8 +1003,10 @@ static s32 e1000_reset_hw_82571(struct e1000_hw *hw)
 	default:
 		break;
 	}
-	if (ret_val)
+	if (ret_val) {
 		e_dbg("Cannot acquire MDIO ownership\n");
+		return ret_val;
+	}
 
 	ctrl = er32(CTRL);
 
-- 
1.7.9.5

