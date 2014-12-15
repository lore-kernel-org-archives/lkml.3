Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaLOObt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaLOO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 161/168] net: mvneta: fix Tx interrupt delay
Date: Mon, 15 Dec 2014 14:26:55 +0000
Message-Id: <1418653622-21105-162-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: willy tarreau <w@1wt.eu>

commit aebea2ba0f7495e1a1c9ea5e753d146cb2f6b845 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index dadd9a5f6323..626aa88644b8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -215,7 +215,7 @@
 /* Various constants */
 
 /* Coalescing */
-#define MVNETA_TXDONE_COAL_PKTS		16
+#define MVNETA_TXDONE_COAL_PKTS		1
 #define MVNETA_RX_COAL_PKTS		32
 #define MVNETA_RX_COAL_USEC		100
 
-- 
2.1.3

