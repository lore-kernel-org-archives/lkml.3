Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3GOLEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:04:04 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63819 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab3GOLEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:04:02 -0400
Message-ID: <1373886239.2591.26.camel@x61.thuisdomein>
Subject: [PATCH] RDMA/cma: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 13:03:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2013 11:03:59.0909 (UTC) FILETIME=[0228ED50:01CE814B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building cma.o triggers this GCC warning:
    drivers/infiniband/core/cma.c: In function ‘rdma_resolve_addr’:
    drivers/infiniband/core/cma.c:465:23: warning: ‘port’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/core/cma.c:426:5: note: ‘port’ was declared here

This is a false positive, as "port" will always be initialized if we're
at "found".

Help GCC by initializing "port" to 0. Since valid port numbers
apparently start at 1, this is an invalid value. That could help in
analyzing the code and tracking down errors.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) Perhaps a better way to silence GCC is to drop "port" entirely, and
assign to "id_priv->id.port_num" directly. Would that be acceptable?

 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f1c279f..c6c0a5f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -426,6 +426,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	u8 port, p;
 	int i;
 
+	port = 0; /* silence GCC */
 	cma_dev = NULL;
 	addr = (struct sockaddr_ib *) cma_dst_addr(id_priv);
 	dgid = (union ib_gid *) &addr->sib_addr;
-- 
1.8.1.4

