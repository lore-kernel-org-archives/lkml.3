Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3HMQJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:09:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab3HMP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:29 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=AGgavpjLrtkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FriRBMDSizMA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=_BQUcWTnWtBYLZoI67cA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155825.705956535@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlad Halilov <vlad.halilov@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [13/88] netlabel: improve domain mapping validation
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0013-netlabel-improve-domain-mapping-validation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netlabel/netlabel_domainhash.c |   69 ++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index d8d4243..6bb1d42 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -245,6 +245,71 @@ static void netlbl_domhsh_audit_add(struct netlbl_dom_map *entry,
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
@@ -311,6 +376,10 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 	struct netlbl_af6list *tmp6;
 #endif /* IPv6 */
 
+	ret_val = netlbl_domhsh_validate(entry);
+	if (ret_val != 0)
+		return ret_val;
+
 	/* XXX - we can remove this RCU read lock as the spinlock protects the
 	 *       entire function, but before we do we need to fixup the
 	 *       netlbl_af[4,6]list RCU functions to do "the right thing" with
-- 
1.7.10.4


