Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaAOVx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:53:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaAOVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 002/166] selinux: look for IPsec labels on both inbound and outbound packets
Date: Wed, 15 Jan 2014 13:50:16 -0800
Message-Id: <1389822780-4729-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 817eff718dca4e54d5721211ddde0914428fbb7c upstream.

Previously selinux_skb_peerlbl_sid() would only check for labeled
IPsec security labels on inbound packets, this patch enables it to
check both inbound and outbound traffic for labeled IPsec security
labels.

Reported-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
[ Paul: backported to 3.4 kernel ]
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/selinux/hooks.c        |  2 +-
 security/selinux/include/xfrm.h |  9 +++----
 security/selinux/xfrm.c         | 53 ++++++++++++++++++++++++++++++++---------
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a3d77ec..1fd031b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3699,7 +3699,7 @@ static int selinux_skb_peerlbl_sid(struct sk_buff *skb, u16 family, u32 *sid)
 	u32 nlbl_sid;
 	u32 nlbl_type;
 
-	selinux_skb_xfrm_sid(skb, &xfrm_sid);
+	selinux_xfrm_skb_sid(skb, &xfrm_sid);
 	selinux_netlbl_skbuff_getsid(skb, family, &nlbl_type, &nlbl_sid);
 
 	err = security_net_peersid_resolve(nlbl_sid, nlbl_type, xfrm_sid, sid);
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 65f67cb..3ffdadc 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -47,6 +47,7 @@ int selinux_xfrm_sock_rcv_skb(u32 sid, struct sk_buff *skb,
 int selinux_xfrm_postroute_last(u32 isec_sid, struct sk_buff *skb,
 			struct common_audit_data *ad, u8 proto);
 int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall);
+int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid);
 
 static inline void selinux_xfrm_notify_policyload(void)
 {
@@ -80,12 +81,12 @@ static inline int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int
 static inline void selinux_xfrm_notify_policyload(void)
 {
 }
-#endif
 
-static inline void selinux_skb_xfrm_sid(struct sk_buff *skb, u32 *sid)
+static inline int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid)
 {
-	int err = selinux_xfrm_decode_session(skb, sid, 0);
-	BUG_ON(err);
+	*sid = SECSID_NULL;
+	return 0;
 }
+#endif
 
 #endif /* _SELINUX_XFRM_H_ */
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 8ab2951..1552b91 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -152,21 +152,13 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x, struct xfrm_policy *
 	return rc;
 }
 
-/*
- * LSM hook implementation that checks and/or returns the xfrm sid for the
- * incoming packet.
- */
-
-int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
+static int selinux_xfrm_skb_sid_ingress(struct sk_buff *skb,
+					u32 *sid, int ckall)
 {
-	struct sec_path *sp;
+	struct sec_path *sp = skb->sp;
 
 	*sid = SECSID_NULL;
 
-	if (skb == NULL)
-		return 0;
-
-	sp = skb->sp;
 	if (sp) {
 		int i, sid_set = 0;
 
@@ -190,6 +182,45 @@ int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
 	return 0;
 }
 
+static u32 selinux_xfrm_skb_sid_egress(struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct xfrm_state *x;
+
+	if (dst == NULL)
+		return SECSID_NULL;
+	x = dst->xfrm;
+	if (x == NULL || !selinux_authorizable_xfrm(x))
+		return SECSID_NULL;
+
+	return x->security->ctx_sid;
+}
+
+/*
+ * LSM hook implementation that checks and/or returns the xfrm sid for the
+ * incoming packet.
+ */
+
+int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
+{
+	if (skb == NULL) {
+		*sid = SECSID_NULL;
+		return 0;
+	}
+	return selinux_xfrm_skb_sid_ingress(skb, sid, ckall);
+}
+
+int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid)
+{
+	int rc;
+
+	rc = selinux_xfrm_skb_sid_ingress(skb, sid, 0);
+	if (rc == 0 && *sid == SECSID_NULL)
+		*sid = selinux_xfrm_skb_sid_egress(skb);
+
+	return rc;
+}
+
 /*
  * Security blob allocation for xfrm_policy and xfrm_state
  * CTX does not have a meaningful value on input
-- 
1.8.3.2

