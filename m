Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbaAFXlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:41:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbaAFWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Janak Desai <Janak.Desai@gtri.gatech.edu>,
        Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.12 137/144] selinux: look for IPsec labels on both inbound and outbound packets
Date: Mon,  6 Jan 2014 14:38:18 -0800
Message-Id: <20140106223749.275459347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 817eff718dca4e54d5721211ddde0914428fbb7c upstream.

Previously selinux_skb_peerlbl_sid() would only check for labeled
IPsec security labels on inbound packets, this patch enables it to
check both inbound and outbound traffic for labeled IPsec security
labels.

Reported-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c        |    2 -
 security/selinux/include/xfrm.h |    9 +++---
 security/selinux/xfrm.c         |   53 +++++++++++++++++++++++++++++++---------
 3 files changed, 48 insertions(+), 16 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3792,7 +3792,7 @@ static int selinux_skb_peerlbl_sid(struc
 	u32 nlbl_sid;
 	u32 nlbl_type;
 
-	selinux_skb_xfrm_sid(skb, &xfrm_sid);
+	selinux_xfrm_skb_sid(skb, &xfrm_sid);
 	selinux_netlbl_skbuff_getsid(skb, family, &nlbl_type, &nlbl_sid);
 
 	err = security_net_peersid_resolve(nlbl_sid, nlbl_type, xfrm_sid, sid);
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -47,6 +47,7 @@ int selinux_xfrm_sock_rcv_skb(u32 sid, s
 int selinux_xfrm_postroute_last(u32 isec_sid, struct sk_buff *skb,
 			struct common_audit_data *ad, u8 proto);
 int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall);
+int selinux_xfrm_skb_sid(struct sk_buff *skb, u32 *sid);
 
 static inline void selinux_xfrm_notify_policyload(void)
 {
@@ -85,12 +86,12 @@ static inline int selinux_xfrm_decode_se
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
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -152,21 +152,13 @@ int selinux_xfrm_state_pol_flow_match(st
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
 
@@ -190,6 +182,45 @@ int selinux_xfrm_decode_session(struct s
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


