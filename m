Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3FDXDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:03:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35635 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab3FDWnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:01 -0400
Message-Id: <20130604172137.519858074@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 174/184] atm: fix info leak via getsockname()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 3c0c5cfdcd4d69ffc4b9c0907cec99039f30a50a upstream.

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 2.6.32: adjust context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/atm/pvc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index d4c0245..523c21a 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -93,6 +93,7 @@ static int pvc_getname(struct socket *sock,struct sockaddr *sockaddr,
 	if (!vcc->dev || !test_bit(ATM_VF_ADDR,&vcc->flags)) return -ENOTCONN;
 	*sockaddr_len = sizeof(struct sockaddr_atmpvc);
 	addr = (struct sockaddr_atmpvc *) sockaddr;
+	memset(addr, 0, sizeof(*addr));
 	addr->sap_family = AF_ATMPVC;
 	addr->sap_addr.itf = vcc->dev->number;
 	addr->sap_addr.vpi = vcc->vpi;
-- 
1.7.12.2.21.g234cd45.dirty



