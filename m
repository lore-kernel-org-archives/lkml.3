Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3GVBiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:38:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51376 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3GVBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:38:04 -0400
Date: Sun, 21 Jul 2013 18:37:58 -0700
From: Michel Lespinasse <walken@google.com>
To: Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: infiniband build warning
Message-ID: <20130722013758.GA14337@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing build warnings in drivers/infiniband/core/cma.c starting with v3.11-rc1. These can be reproduced with gcc 4.6.3.

Would you consider applying the following fix ?
(The compiler warning seems benign as I could easily convince myself that the variable won't be used uninitialized, but I'd like to get rid of the compiler warning anyway).

--------------------------------- 8< ------------------------------------
infiniband: fix maybe-uninitialized warning in rdma_resolve_addr()

This fixes the following warning:

drivers/infiniband/core/cma.c: In function 'rdma_resolve_addr':
drivers/infiniband/core/cma.c:465:23: error: 'port' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/infiniband/core/cma.c:426:5: note: 'port' was declared here

The warning looks benign: port is only used after checking that
cma_dev is not NULL, and all assignments to cma_dev also set port.

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f1c279fabe64..7b2e38ad1243 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -423,7 +423,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	struct sockaddr_ib *addr;
 	union ib_gid gid, sgid, *dgid;
 	u16 pkey, index;
-	u8 port, p;
+	u8 port = 0, p;
 	int i;
 
 	cma_dev = NULL;

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
