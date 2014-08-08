Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbaHHVqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbaHHVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:46:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.16 08/17] batman-adv: Fix out-of-order fragmentation support
Date: Fri,  8 Aug 2014 14:35:30 -0700
Message-Id: <20140808213457.853428867@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213457.511493898@linuxfoundation.org>
References: <20140808213457.511493898@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit d9124268d84a836f14a6ead54ff9d8eee4c43be5 ]

batadv_frag_insert_packet was unable to handle out-of-order packets because it
dropped them directly. This is caused by the way the fragmentation lists is
checked for the correct place to insert a fragmentation entry.

The fragmentation code keeps the fragments in lists. The fragmentation entries
are kept in descending order of sequence number. The list is traversed and each
entry is compared with the new fragment. If the current entry has a smaller
sequence number than the new fragment then the new one has to be inserted
before the current entry. This ensures that the list is still in descending
order.

An out-of-order packet with a smaller sequence number than all entries in the
list still has to be added to the end of the list. The used hlist has no
information about the last entry in the list inside hlist_head and thus the
last entry has to be calculated differently. Currently the code assumes that
the iterator variable of hlist_for_each_entry can be used for this purpose
after the hlist_for_each_entry finished. This is obviously wrong because the
iterator variable is always NULL when the list was completely traversed.

Instead the information about the last entry has to be stored in a different
variable.

This problem was introduced in 610bfc6bc99bc83680d190ebc69359a05fc7f605
("batman-adv: Receive fragmented packets and merge").

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -128,6 +128,7 @@ static bool batadv_frag_insert_packet(st
 {
 	struct batadv_frag_table_entry *chain;
 	struct batadv_frag_list_entry *frag_entry_new = NULL, *frag_entry_curr;
+	struct batadv_frag_list_entry *frag_entry_last = NULL;
 	struct batadv_frag_packet *frag_packet;
 	uint8_t bucket;
 	uint16_t seqno, hdr_size = sizeof(struct batadv_frag_packet);
@@ -180,11 +181,14 @@ static bool batadv_frag_insert_packet(st
 			ret = true;
 			goto out;
 		}
+
+		/* store current entry because it could be the last in list */
+		frag_entry_last = frag_entry_curr;
 	}
 
-	/* Reached the end of the list, so insert after 'frag_entry_curr'. */
-	if (likely(frag_entry_curr)) {
-		hlist_add_after(&frag_entry_curr->list, &frag_entry_new->list);
+	/* Reached the end of the list, so insert after 'frag_entry_last'. */
+	if (likely(frag_entry_last)) {
+		hlist_add_after(&frag_entry_last->list, &frag_entry_new->list);
 		chain->size += skb->len - hdr_size;
 		chain->timestamp = jiffies;
 		ret = true;


