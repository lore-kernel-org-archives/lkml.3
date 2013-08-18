Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3HRUfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3HRUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/45] genetlink: fix family dump race
Date: Sun, 18 Aug 2013 13:36:07 -0700
Message-Id: <20130818203622.279854313@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 58ad436fcf49810aa006016107f494c9ac9013db upstream.

When dumping generic netlink families, only the first dump call
is locked with genl_lock(), which protects the list of families,
and thus subsequent calls can access the data without locking,
racing against family addition/removal. This can cause a crash.
Fix it - the locking needs to be conditional because the first
time around it's already locked.

A similar bug was reported to me on an old kernel (3.4.47) but
the exact scenario that happened there is no longer possible,
on those kernels the first round wasn't locked either. Looking
at the current code I found the race described above, which had
also existed on the old kernel.

Reported-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netlink/genetlink.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -789,6 +789,10 @@ static int ctrl_dumpfamily(struct sk_buf
 	struct net *net = sock_net(skb->sk);
 	int chains_to_skip = cb->args[0];
 	int fams_to_skip = cb->args[1];
+	bool need_locking = chains_to_skip || fams_to_skip;
+
+	if (need_locking)
+		genl_lock();
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -810,6 +814,9 @@ errout:
 	cb->args[0] = i;
 	cb->args[1] = n;
 
+	if (need_locking)
+		genl_unlock();
+
 	return skb->len;
 }
 


