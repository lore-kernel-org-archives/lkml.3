Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaBEU6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:58:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:54692 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaBEUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "danborkmann@iogearbox.net" <danborkmann@iogearbox.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 050/213] af_packet: remove BUG statement in tpacket_destruct_skb
Date: Wed, 5 Feb 2014 15:00:05 -0500
Message-ID: <1391630568-49251-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "danborkmann@iogearbox.net" <danborkmann@iogearbox.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7f5c3e3a80e6654cf48dfba7cf94f88c6b505467 upstream.

Here's a quote of the comment about the BUG macro from asm-generic/bug.h:

 Don't use BUG() or BUG_ON() unless there's really no way out; one
 example might be detecting data structure corruption in the middle
 of an operation that can't be backed out of.  If the (sub)system
 can somehow continue operating, perhaps with reduced functionality,
 it's probably not BUG-worthy.

 If you're tempted to BUG(), think again:  is completely giving up
 really the *only* solution?  There are usually better options, where
 users don't need to reboot ASAP and can mostly shut down cleanly.

In our case, the status flag of a ring buffer slot is managed from both sides,
the kernel space and the user space. This means that even though the kernel
side might work as expected, the user space screws up and changes this flag
right between the send(2) is triggered when the flag is changed to
TP_STATUS_SENDING and a given skb is destructed after some time. Then, this
will hit the BUG macro. As David suggested, the best solution is to simply
remove this statement since it cannot be used for kernel side internal
consistency checks. I've tested it and the system still behaves /stable/ in
this case, so in accordance with the above comment, we should rather remove it.

Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/packet/af_packet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4096a66f6379..dbe4dd160631 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -812,7 +812,6 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 
 	if (likely(po->tx_ring.pg_vec)) {
 		ph = skb_shinfo(skb)->destructor_arg;
-		BUG_ON(__packet_get_status(po, ph) != TP_STATUS_SENDING);
 		BUG_ON(atomic_read(&po->tx_ring.pending) == 0);
 		atomic_dec(&po->tx_ring.pending);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE);
-- 
1.8.5.2

