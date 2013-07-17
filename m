Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3GQIk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:40:58 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55370 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab3GQIk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:40:56 -0400
Message-ID: <1374050453.26384.41.camel@x61.thuisdomein>
Subject: [PATCH v2] RDMA/cma: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 10:40:53 +0200
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805A65C0@ORSMSX110.amr.corp.intel.com>
References: <1373886239.2591.26.camel@x61.thuisdomein>
	 <1828884A29C6694DAF28B7E6B8A82373805A65C0@ORSMSX110.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2013 08:40:53.0869 (UTC) FILETIME=[594EB1D0:01CE82C9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building cma.o triggers this GCC warning:
    drivers/infiniband/core/cma.c: In function ‘rdma_resolve_addr’:
    drivers/infiniband/core/cma.c:465:23: warning: ‘port’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/core/cma.c:426:5: note: ‘port’ was declared here

This is a false positive, as "port" will always be initialized if we're
at "found". But if we assign to "id_priv->id.port_num" directly, we can
drop "port". That will, obviously, silence GCC.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: assign to "id_priv->id.port_num" directly, instead of
initializing "port" to 0, as discussed with Sean.

1) Still only compile tested.

 drivers/infiniband/core/cma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f1c279f..84487a2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -423,7 +423,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	struct sockaddr_ib *addr;
 	union ib_gid gid, sgid, *dgid;
 	u16 pkey, index;
-	u8 port, p;
+	u8 p;
 	int i;
 
 	cma_dev = NULL;
@@ -443,7 +443,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 				if (!memcmp(&gid, dgid, sizeof(gid))) {
 					cma_dev = cur_dev;
 					sgid = gid;
-					port = p;
+					id_priv->id.port_num = p;
 					goto found;
 				}
 
@@ -451,7 +451,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 						 dgid->global.subnet_prefix)) {
 					cma_dev = cur_dev;
 					sgid = gid;
-					port = p;
+					id_priv->id.port_num = p;
 				}
 			}
 		}
@@ -462,7 +462,6 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
 found:
 	cma_attach_to_dev(id_priv, cma_dev);
-	id_priv->id.port_num = port;
 	addr = (struct sockaddr_ib *) cma_src_addr(id_priv);
 	memcpy(&addr->sib_addr, &sgid, sizeof sgid);
 	cma_translate_ib(addr, &id_priv->id.route.addr.dev_addr);
-- 
1.8.1.4

