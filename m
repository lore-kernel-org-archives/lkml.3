Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbbAIKuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44535 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757423AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, willy tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/78] net: mvneta: fix Tx interrupt delay
Date: Fri,  9 Jan 2015 11:31:16 +0100
Message-Id: <844969652b9b11b8b33779c35c1ae11d8cb30a96.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: willy tarreau <w@1wt.eu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit aebea2ba0f7495e1a1c9ea5e753d146cb2f6b845 ]

The mvneta driver sets the amount of Tx coalesce packets to 16 by
default. Normally that does not cause any trouble since the driver
uses a much larger Tx ring size (532 packets). But some sockets
might run with very small buffers, much smaller than the equivalent
of 16 packets. This is what ping is doing for example, by setting
SNDBUF to 324 bytes rounded up to 2kB by the kernel.

The problem is that there is no documented method to force a specific
packet to emit an interrupt (eg: the last of the ring) nor is it
possible to make the NIC emit an interrupt after a given delay.

In this case, it causes trouble, because when ping sends packets over
its raw socket, the few first packets leave the system, and the first
15 packets will be emitted without an IRQ being generated, so without
the skbs being freed. And since the socket's buffer is small, there's
no way to reach that amount of packets, and the ping ends up with
"send: no buffer available" after sending 6 packets. Running with 3
instances of ping in parallel is enough to hide the problem, because
with 6 packets per instance, that's 18 packets total, which is enough
to grant a Tx interrupt before all are sent.

The original driver in the LSP kernel worked around this design flaw
by using a software timer to clean up the Tx descriptors. This timer
was slow and caused terrible network performance on some Tx-bound
workloads (such as routing) but was enough to make tools like ping
work correctly.

Instead here, we simply set the packet counts before interrupt to 1.
This ensures that each packet sent will produce an interrupt. NAPI
takes care of coalescing interrupts since the interrupt is disabled
once generated.

No measurable performance impact nor CPU usage were observed on small
nor large packets, including when saturating the link on Tx, and this
fixes tools like ping which rely on too small a send buffer. If one
wants to increase this value for certain workloads where it is safe
to do so, "ethtool -C $dev tx-frames" will override this default
setting.

This fix needs to be applied to stable kernels starting with 3.10.

Tested-By: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index fabdda91fd0e..0e38db6469fb 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -172,7 +172,7 @@
 /* Various constants */
 
 /* Coalescing */
-#define MVNETA_TXDONE_COAL_PKTS		16
+#define MVNETA_TXDONE_COAL_PKTS		1
 #define MVNETA_RX_COAL_PKTS		32
 #define MVNETA_RX_COAL_USEC		100
 
-- 
2.2.1

