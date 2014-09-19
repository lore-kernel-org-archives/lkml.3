Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaISAvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaISAvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:51:02 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, pmoore@redhat.com, eparis@redhat.com,
        sgrubb@redhat.com
Subject: [PATCH] selinux: hooks: cleanup orphan keywords in audit log text
Date: Thu, 18 Sep 2014 20:50:17 -0400
Message-Id: <8bedc57ef45bf628ac344bc3d8513b9a93e274ca.1411087339.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert audit_log() call to WARN_ONCE().

Rename "type=" to nlmsg_type=" to avoid confusion with the audit record
type.

Added "protocol=" to help track down which protocol (NETLINK_AUDIT?) was used
within the netlink protocol family.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 security/selinux/hooks.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 83d06db..28ec61c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4681,10 +4681,9 @@ static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
 	if (err) {
 		if (err == -EINVAL) {
-			audit_log(current->audit_context, GFP_KERNEL, AUDIT_SELINUX_ERR,
-				  "SELinux:  unrecognized netlink message"
-				  " type=%hu for sclass=%hu\n",
-				  nlh->nlmsg_type, sksec->sclass);
+			WARN_ONCE(1, "selinux_nlmsg_perm: unrecognized netlink message:"
+				  " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
+				  sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}
-- 
1.7.1

