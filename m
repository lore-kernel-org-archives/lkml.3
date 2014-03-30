Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaC3Xbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:31:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36519 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaC3XZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Horman" <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Shreyas Bhatewara" <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.555675238@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 173/200] vmxnet3: fix netpoll race condition
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit d25f06ea466ea521b563b76661180b4e44714ae6 upstream.

vmxnet3's netpoll driver is incorrectly coded.  It directly calls
vmxnet3_do_poll, which is the driver internal napi poll routine.  As the netpoll
controller method doesn't block real napi polls in any way, there is a potential
for race conditions in which the netpoll controller method and the napi poll
method run concurrently.  The result is data corruption causing panics such as this
one recently observed:
PID: 1371   TASK: ffff88023762caa0  CPU: 1   COMMAND: "rs:main Q:Reg"
 #0 [ffff88023abd5780] machine_kexec at ffffffff81038f3b
 #1 [ffff88023abd57e0] crash_kexec at ffffffff810c5d92
 #2 [ffff88023abd58b0] oops_end at ffffffff8152b570
 #3 [ffff88023abd58e0] die at ffffffff81010e0b
 #4 [ffff88023abd5910] do_trap at ffffffff8152add4
 #5 [ffff88023abd5970] do_invalid_op at ffffffff8100cf95
 #6 [ffff88023abd5a10] invalid_op at ffffffff8100bf9b
    [exception RIP: vmxnet3_rq_rx_complete+1968]
    RIP: ffffffffa00f1e80  RSP: ffff88023abd5ac8  RFLAGS: 00010086
    RAX: 0000000000000000  RBX: ffff88023b5dcee0  RCX: 00000000000000c0
    RDX: 0000000000000000  RSI: 00000000000005f2  RDI: ffff88023b5dcee0
    RBP: ffff88023abd5b48   R8: 0000000000000000   R9: ffff88023a3b6048
    R10: 0000000000000000  R11: 0000000000000002  R12: ffff8802398d4cd8
    R13: ffff88023af35140  R14: ffff88023b60c890  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff88023abd5b50] vmxnet3_do_poll at ffffffffa00f204a [vmxnet3]
 #8 [ffff88023abd5b80] vmxnet3_netpoll at ffffffffa00f209c [vmxnet3]
 #9 [ffff88023abd5ba0] netpoll_poll_dev at ffffffff81472bb7

The fix is to do as other drivers do, and have the poll controller call the top
half interrupt handler, which schedules a napi poll properly to recieve frames

Tested by myself, successfully.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Shreyas Bhatewara <sbhatewara@vmware.com>
CC: "VMware, Inc." <pv-drivers@vmware.com>
CC: "David S. Miller" <davem@davemloft.net>
Reviewed-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1733,12 +1733,18 @@ static void
 vmxnet3_netpoll(struct net_device *netdev)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	int i;
 
-	if (adapter->intr.mask_mode == VMXNET3_IMM_ACTIVE)
-		vmxnet3_disable_all_intrs(adapter);
-
-	vmxnet3_do_poll(adapter, adapter->rx_queue[0].rx_ring[0].size);
-	vmxnet3_enable_all_intrs(adapter);
+	switch (adapter->intr.type) {
+	case VMXNET3_IT_MSIX:
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			vmxnet3_msix_rx(0, &adapter->rx_queue[i]);
+		break;
+	case VMXNET3_IT_MSI:
+	default:
+		vmxnet3_intr(0, adapter->netdev);
+		break;
+	}
 
 }
 #endif	/* CONFIG_NET_POLL_CONTROLLER */

