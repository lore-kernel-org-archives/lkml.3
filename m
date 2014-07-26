Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaGZTDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGZTDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 35/56] tipc: clear next-pointer of message fragments before reassembly
Date: Sat, 26 Jul 2014 12:02:28 -0700
Message-Id: <20140726190201.205047241@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/bcast.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -531,6 +531,7 @@ receive:
 
 		buf = node->bclink.deferred_head;
 		node->bclink.deferred_head = buf->next;
+		buf->next = NULL;
 		node->bclink.deferred_size--;
 		goto receive;
 	}


