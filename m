Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaHRJeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaHRJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/137] tipc: clear 'next'-pointer of message fragments before reassembly
Date: Mon, 18 Aug 2014 10:31:54 +0100
Message-Id: <1408354398-10226-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Paul Maloy <jon.maloy@ericsson.com>

commit 999417549c16dd0e3a382aa9f6ae61688db03181 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

