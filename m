Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaHHVgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:36:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbaHHVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        Karl Volz <karl.volz@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 23/24] sparc64: ldc_connect() should not return EINVAL when handshake is in progress.
Date: Fri,  8 Aug 2014 14:35:16 -0700
Message-Id: <20140808213336.375299529@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/ldc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


