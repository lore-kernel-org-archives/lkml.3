Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaG3MPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36614 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 02/94] can: c_can: Remove EOB exit
Date: Wed, 30 Jul 2014 14:13:51 +0200
Message-Id: <9b448624dde40554d8ce7f2a53b456160209de8a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 710c56105dfd10e32a89086cf78cc1c8433f6a7a upstream.

The rx_poll code has the following gem:

	if (msg_ctrl_save & IF_MCONT_EOB)
		return num_rx_pkts;

The EOB bit is the indicator for the hardware that this is the last
configured FIFO object. But this object can contain valid data, if we
manage to free up objects before the overrun case hits.

Now if the code exits due to the EOB bit set, then this buffer is
stale and the interrupt bit and NewDat bit of the buffer are still
set. Results in a nice interrupt storm unless we come into an overrun
situation where the MSGLST bit gets set.

     ksoftirqd/0-3     [000] ..s.    79.124101: c_can_poll: rx_poll: val: 00008001 pend 00008001
     ksoftirqd/0-3     [000] ..s.    79.124176: c_can_poll: rx_poll: val: 00008000 pend 00008000
     ksoftirqd/0-3     [000] ..s.    79.124187: c_can_poll: rx_poll: val: 00008002 pend 00008002
     ksoftirqd/0-3     [000] ..s.    79.124256: c_can_poll: rx_poll: val: 00008000 pend 00008000
     ksoftirqd/0-3     [000] ..s.    79.124267: c_can_poll: rx_poll: val: 00008000 pend 00008000

The amazing thing is that the check of the MSGLST (aka overrun bit)
used to be after the check of the EOB bit. That was "fixed" in commit
5d0f801a2c(can: c_can: Fix RX message handling, handle lost message
before EOB). But the author of this "fix" did not even understand that
the EOB check is broken as well.

Again a simple solution: Remove

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[mkl: adjusted subject and commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/c_can/c_can.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index e59c42b446a9..ae148055baa2 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -830,9 +830,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 				continue;
 			}
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 
-- 
2.0.1

