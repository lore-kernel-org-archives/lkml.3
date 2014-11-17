Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaKQSV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:21:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKQSV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:21:57 -0500
Subject: [PATCH 4/4] fm10k/igb/ixgbe: Use fast_rmb on Rx descriptor reads
From: Alexander Duyck <alexander.h.duyck@redhat.com>
To: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Mon, 17 Nov 2014 09:18:40 -0800
Message-ID: <20141117171839.22333.25487.stgit@ahduyck-server>
In-Reply-To: <20141117171005.22333.96544.stgit@ahduyck-server>
References: <20141117171005.22333.96544.stgit@ahduyck-server>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that fast_rmb is used when reading the Rx
descriptor.  The advantage of fast_rmb is that it allows for a much
lower cost barrier on x86, powerpc, arm, and arm64 architectures than a
traditional memory barrier when dealing with reads that only have to
synchronize to system memory.

In addition I have updated the code so that it just checks to see if any
bits have been set instead of just the DD bit since the DD bit will always
be set as a part of a descriptor write-back so we just need to check for a
non-zero value being present at that memory location rather than just
checking for any specific bit.  This allows the code itself to appear much
cleaner and allows the compiler more room to optimize.

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Matthew Vick <matthew.vick@intel.com>
Cc: Don Skidmore <donald.c.skidmore@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@redhat.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |    6 +++---
 drivers/net/ethernet/intel/igb/igb_main.c     |    6 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    9 ++++-----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index e645af4..ba959b9 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -620,14 +620,14 @@ static bool fm10k_clean_rx_irq(struct fm10k_q_vector *q_vector,
 
 		rx_desc = FM10K_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
-		if (!fm10k_test_staterr(rx_desc, FM10K_RXD_STATUS_DD))
+		if (!rx_desc->d.staterr)
 			break;
 
 		/* This memory barrier is needed to keep us from reading
 		 * any other fields out of the rx_desc until we know the
-		 * RXD_STATUS_DD bit is set
+		 * descriptor has been written back
 		 */
-		rmb();
+		fast_rmb();
 
 		/* retrieve a buffer from the ring */
 		skb = fm10k_fetch_rx_buffer(rx_ring, rx_desc, skb);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a2d72a8..3dbbaa8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6918,14 +6918,14 @@ static bool igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 
 		rx_desc = IGB_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
-		if (!igb_test_staterr(rx_desc, E1000_RXD_STAT_DD))
+		if (!rx_desc->wb.upper.status_error)
 			break;
 
 		/* This memory barrier is needed to keep us from reading
 		 * any other fields out of the rx_desc until we know the
-		 * RXD_STAT_DD bit is set
+		 * descriptor has been written back
 		 */
-		rmb();
+		fast_rmb();
 
 		/* retrieve a buffer from the ring */
 		skb = igb_fetch_rx_buffer(rx_ring, rx_desc, skb);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index d2df4e3..890d740 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2003,15 +2003,14 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 
 		rx_desc = IXGBE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
-		if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_DD))
+		if (!rx_desc->wb.upper.status_error)
 			break;
 
-		/*
-		 * This memory barrier is needed to keep us from reading
+		/* This memory barrier is needed to keep us from reading
 		 * any other fields out of the rx_desc until we know the
-		 * RXD_STAT_DD bit is set
+		 * descriptor has been written back
 		 */
-		rmb();
+		fast_rmb();
 
 		/* retrieve a buffer from the ring */
 		skb = ixgbe_fetch_rx_buffer(rx_ring, rx_desc);

