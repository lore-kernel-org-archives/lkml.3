Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3EQWDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:03:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3EQVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        JerryKang <jerry.kang@samsung.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/50] bridge: fix race with topology change timer
Date: Fri, 17 May 2013 14:47:06 -0700
Message-Id: <20130517213845.964819769@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 83401eb4990ff6af55aeed8f49681558544192e6 ]

A bridge should only send topology change notice if it is not
the root bridge. It is possible for message age timer to elect itself
as a new root bridge, and still have a topology change timer running
but waiting for bridge lock on other CPU.

Solve the race by checking if we are root bridge before continuing.
This was the root cause of the cases where br_send_tcn_bpdu would OOPS.

Reported-by: JerryKang <jerry.kang@samsung.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_stp_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -107,7 +107,7 @@ static void br_tcn_timer_expired(unsigne
 
 	br_debug(br, "tcn timer expired\n");
 	spin_lock(&br->lock);
-	if (br->dev->flags & IFF_UP) {
+	if (!br_is_root_bridge(br) && (br->dev->flags & IFF_UP)) {
 		br_transmit_tcn(br);
 
 		mod_timer(&br->tcn_timer,jiffies + br->bridge_hello_time);


