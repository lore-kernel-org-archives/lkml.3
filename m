Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbaIOWWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:22:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbaIOWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/187] sparc64: ldc_connect() should not return EINVAL when handshake is in progress.
Date: Mon, 15 Sep 2014 15:07:23 -0700
Message-Id: <1410818997-9432-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sowmini Varadhan <sowmini.varadhan@oracle.com>

[ Upstream commit 4ec1b01029b4facb651b8ef70bc20a4be4cebc63 ]

The LDC handshake could have been asynchronously triggered
after ldc_bind() enables the ldc_rx() receive interrupt-handler
(and thus intercepts incoming control packets)
and before vio_port_up() calls ldc_connect(). If that is the case,
ldc_connect() should return 0 and let the state-machine
progress.

Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Acked-by: Karl Volz <karl.volz@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/ldc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index e01d75d..66dacd5 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1336,7 +1336,7 @@ int ldc_connect(struct ldc_channel *lp)
 	if (!(lp->flags & LDC_FLAG_ALLOCED_QUEUES) ||
 	    !(lp->flags & LDC_FLAG_REGISTERED_QUEUES) ||
 	    lp->hs_state != LDC_HS_OPEN)
-		err = -EINVAL;
+		err = ((lp->hs_state > LDC_HS_OPEN) ? 0 : -EINVAL);
 	else
 		err = start_handshake(lp);
 
-- 
1.9.1

