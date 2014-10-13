Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaJMCt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:49:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaJMC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 11/55] tipc: fix message importance range check
Date: Mon, 13 Oct 2014 04:24:25 +0200
Message-Id: <20141013022444.218748642@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Hugne <erik.hugne@ericsson.com>

[ Upstream commit ac32c7f705692b92fe12dcbe88fe87136fdfff6f ]

Commit 3b4f302d8578 ("tipc: eliminate
redundant locking") introduced a bug by removing the sanity check
for message importance, allowing programs to assign any value to
the msg_user field. This will mess up the packet reception logic
and may cause random link resets.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/port.h   |    5 ++++-
 net/tipc/socket.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/tipc/port.h
+++ b/net/tipc/port.h
@@ -229,9 +229,12 @@ static inline int tipc_port_importance(s
 	return msg_importance(&port->phdr);
 }
 
-static inline void tipc_port_set_importance(struct tipc_port *port, int imp)
+static inline int tipc_port_set_importance(struct tipc_port *port, int imp)
 {
+	if (imp > TIPC_CRITICAL_IMPORTANCE)
+		return -EINVAL;
 	msg_set_importance(&port->phdr, (u32)imp);
+	return 0;
 }
 
 #endif
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1841,7 +1841,7 @@ static int tipc_setsockopt(struct socket
 
 	switch (opt) {
 	case TIPC_IMPORTANCE:
-		tipc_port_set_importance(port, value);
+		res = tipc_port_set_importance(port, value);
 		break;
 	case TIPC_SRC_DROPPABLE:
 		if (sock->type != SOCK_STREAM)


