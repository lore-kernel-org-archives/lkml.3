Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaG3MUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36815 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jon Paul Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 52/94] tipc: clear 'next'-pointer of message fragments before reassembly
Date: Wed, 30 Jul 2014 14:14:41 +0200
Message-Id: <0515cc266b526def4d880515d3ab3bb0b190eec9.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Paul Maloy <jon.maloy@ericsson.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 999417549c16dd0e3a382aa9f6ae61688db03181 ]

If the 'next' pointer of the last fragment buffer in a message is not
zeroed before reassembly, we risk ending up with a corrupt message,
since the reassembly function itself isn't doing this.

Currently, when a buffer is retrieved from the deferred queue of the
broadcast link, the next pointer is not cleared, with the result as
described above.

This commit corrects this, and thereby fixes a bug that may occur when
long broadcast messages are transmitted across dual interfaces. The bug
has been present since 40ba3cdf542a469aaa9083fa041656e59b109b90 ("tipc:
message reassembly using fragment chain")

This commit should be applied to both net and net-next.

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/bcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 716de1ac6cb5..6ef89256b2fb 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -531,6 +531,7 @@ receive:
 
 		buf = node->bclink.deferred_head;
 		node->bclink.deferred_head = buf->next;
+		buf->next = NULL;
 		node->bclink.deferred_size--;
 		goto receive;
 	}
-- 
2.0.1

