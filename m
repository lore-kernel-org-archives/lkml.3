Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3LBTOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3LBTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.10 169/173] netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions
Date: Mon,  2 Dec 2013 11:12:32 -0800
Message-Id: <20131202191202.414598884@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubecek <mkubecek@suse.cz>

commit c13a84a830a208fb3443628773c8ca0557773cc7 upstream.

Commit 68b80f11 (netfilter: nf_nat: fix RCU races) introduced
RCU protection for freeing extension data when reallocation
moves them to a new location. We need the same protection when
freeing them in nf_ct_ext_free() in order to prevent a
use-after-free by other threads referencing a NAT extension data
via bysource list.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_conntrack_extend.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -80,7 +80,7 @@ static inline void nf_ct_ext_destroy(str
 static inline void nf_ct_ext_free(struct nf_conn *ct)
 {
 	if (ct->ext)
-		kfree(ct->ext);
+		kfree_rcu(ct->ext, rcu);
 }
 
 /* Add this type, returns pointer to data or NULL. */


