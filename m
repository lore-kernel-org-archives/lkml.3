Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3EJOUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984Ab3EJOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcel Holtmann" <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Gustavo Padovan" <gustavo@padovan.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.88684867@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [101/118] Bluetooth: RFCOMM - Fix missing msg_namelen update in 
 rfcomm_sock_recvmsg()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e11e0455c0d7d3d62276a0c55d9dfbc16779d691 ]

If RFCOMM_DEFER_SETUP is set in the flags, rfcomm_sock_recvmsg() returns
early with 0 without updating the possibly set msg_namelen member. This,
in turn, leads to a 128 byte kernel stack leak in net/socket.c.

Fix this by updating msg_namelen in this case. For all other cases it
will be handled in bt_sock_stream_recvmsg().

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/rfcomm/sock.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -627,6 +627,7 @@ static int rfcomm_sock_recvmsg(struct ki
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
+		msg->msg_namelen = 0;
 		return 0;
 	}
 

