Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3E1Dzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52476 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758771Ab3E1DyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bing Zhao" <bzhao@marvell.com>,
        "Daniel Drake" <dsd@laptop.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.879329037@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [20/94] mwifiex: fix setting of multicast filter
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit ccd384b10420ac81ba3fb9b0a7d18272c7173552 upstream.

A small bug in this code was causing the ALLMULTI filter to be set
when in fact we were just wanting to program a selective multicast list
to the hardware.

Fix that bug and remove a redundant if condition in the code that
follows.

This fixes wakeup behaviour when multicast WOL is enabled. Previously,
all multicast packets would wake up the system. Now, only those that the
host intended to receive trigger wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -105,7 +105,7 @@ int mwifiex_request_set_multicast_list(s
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -117,20 +117,11 @@ int mwifiex_request_set_multicast_list(s
 				dev_dbg(priv->adapter->dev,
 					"info: Set multicast list=%d\n",
 				       mcast_list->num_multicast_addr);
-				/* Set multicast addresses to firmware */
-				if (old_pkt_filter == priv->curr_pkt_filter) {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				} else {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				}
+				/* Send multicast addresses to firmware */
+				ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_MAC_MULTICAST_ADR,
+					HostCmd_ACT_GEN_SET, 0,
+					mcast_list);
 			}
 		}
 	}

