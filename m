Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaHTL7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58960 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/104] sparc64: ldc_connect() should not return EINVAL when handshake is in progress.
Date: Wed, 20 Aug 2014 13:43:20 +0200
Message-Id: <fc52b92969d39a8a36ea174ab93cf10bf4b8a2ce.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sowmini Varadhan <sowmini.varadhan@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/ldc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index e01d75d40329..66dacd56bb10 100644
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
2.0.4

