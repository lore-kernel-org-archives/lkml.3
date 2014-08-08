Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbaHHUqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaHHUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 252/259] tipc: clear 'next'-pointer of message fragments before reassembly
Date: Fri,  8 Aug 2014 13:41:15 -0700
Message-Id: <1407530482-4483-253-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Paul Maloy <jon.maloy@ericsson.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/tipc/bcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 0d44025..bc1e5d6 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -537,6 +537,7 @@ receive:
 
 		buf = node->bclink.deferred_head;
 		node->bclink.deferred_head = buf->next;
+		buf->next = NULL;
 		node->bclink.deferred_size--;
 		goto receive;
 	}
-- 
1.9.1

