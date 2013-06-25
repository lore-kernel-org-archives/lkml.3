Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3FYSeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3FYSd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Halilov <vlad.halilov@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 49/95] netlabel: improve domain mapping validation
Date: Tue, 25 Jun 2013 11:32:36 -0700
Message-Id: <20130625182159.170729720@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

[ Upstream commit 6b21e1b77d1a3d58ebfd513264c885695e8a0ba5 ]

The net/netlabel/netlabel_domainhash.c:netlbl_domhsh_add() function
does not properly validate new domain hash entries resulting in
potential problems when an administrator attempts to add an invalid
entry.  One such problem, as reported by Vlad Halilov, is a kernel
BUG (found in netlabel_domainhash.c:netlbl_domhsh_audit_add()) when
adding an IPv6 outbound mapping with a CIPSO configuration.

This patch corrects this problem by adding the necessary validation
code to netlbl_domhsh_add() via the newly created
netlbl_domhsh_validate() function.

Ideally this patch should also be pushed to the currently active
-stable trees.

Reported-by: Vlad Halilov <vlad.halilov@gmail.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_domainhash.c |   69 +++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -245,6 +245,71 @@ static void netlbl_domhsh_audit_add(stru
 	}
 }
 
+/**
+ * netlbl_domhsh_validate - Validate a new domain mapping entry
+ * @entry: the entry to validate
+ *
+ * This function validates the new domain mapping entry to ensure that it is
+ * a valid entry.  Returns zero on success, negative values on failure.
+ *
+ */
+static int netlbl_domhsh_validate(const struct netlbl_dom_map *entry)
+{
+	struct netlbl_af4list *iter4;
+	struct netlbl_domaddr4_map *map4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct netlbl_af6list *iter6;
+	struct netlbl_domaddr6_map *map6;
+#endif /* IPv6 */
+
+	if (entry == NULL)
+		return -EINVAL;
+
+	switch (entry->type) {
+	case NETLBL_NLTYPE_UNLABELED:
+		if (entry->type_def.cipsov4 != NULL ||
+		    entry->type_def.addrsel != NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_CIPSOV4:
+		if (entry->type_def.cipsov4 == NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_ADDRSELECT:
+		netlbl_af4list_foreach(iter4, &entry->type_def.addrsel->list4) {
+			map4 = netlbl_domhsh_addr4_entry(iter4);
+			switch (map4->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				if (map4->type_def.cipsov4 != NULL)
+					return -EINVAL;
+				break;
+			case NETLBL_NLTYPE_CIPSOV4:
+				if (map4->type_def.cipsov4 == NULL)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		netlbl_af6list_foreach(iter6, &entry->type_def.addrsel->list6) {
+			map6 = netlbl_domhsh_addr6_entry(iter6);
+			switch (map6->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#endif /* IPv6 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Domain Hash Table Functions
  */
@@ -311,6 +376,10 @@ int netlbl_domhsh_add(struct netlbl_dom_
 	struct netlbl_af6list *tmp6;
 #endif /* IPv6 */
 
+	ret_val = netlbl_domhsh_validate(entry);
+	if (ret_val != 0)
+		return ret_val;
+
 	/* XXX - we can remove this RCU read lock as the spinlock protects the
 	 *       entire function, but before we do we need to fixup the
 	 *       netlbl_af[4,6]list RCU functions to do "the right thing" with


