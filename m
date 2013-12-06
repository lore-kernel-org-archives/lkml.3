Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162587Ab3LFN1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161828Ab3LFNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Kubecek <mkubecek@suse.cz>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 191/272] netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions
Date: Fri,  6 Dec 2013 12:58:00 +0000
Message-Id: <1386334761-25517-192-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>

commit c13a84a830a208fb3443628773c8ca0557773cc7 upstream.

Commit 68b80f11 (netfilter: nf_nat: fix RCU races) introduced
RCU protection for freeing extension data when reallocation
moves them to a new location. We need the same protection when
freeing them in nf_ct_ext_free() in order to prevent a
use-after-free by other threads referencing a NAT extension data
via bysource list.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/netfilter/nf_conntrack_extend.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 977bc8a..3313108 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -80,7 +80,7 @@ static inline void nf_ct_ext_destroy(struct nf_conn *ct)
 static inline void nf_ct_ext_free(struct nf_conn *ct)
 {
 	if (ct->ext)
-		kfree(ct->ext);
+		kfree_rcu(ct->ext, rcu);
 }
 
 /* Add this type, returns pointer to data or NULL. */
-- 
1.8.3.2

