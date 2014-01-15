Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaAOV6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:58:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41111 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaAOV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chad Hanson <chanson@trustedcs.com>, Paul Moore <pmoore@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 109/166] selinux: fix broken peer recv check
Date: Wed, 15 Jan 2014 13:52:03 -0800
Message-Id: <1389822780-4729-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Hanson <chanson@trustedcs.com>

commit 46d01d63221c3508421dd72ff9c879f61053cffc upstream.

Fix a broken networking check. Return an error if peer recv fails.  If
secmark is active and the packet recv succeeds the peer recv error is
ignored.

Signed-off-by: Chad Hanson <chanson@trustedcs.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/selinux/hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1ce432d..0963169 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4205,8 +4205,10 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 		err = avc_has_perm(sk_sid, peer_sid, SECCLASS_PEER,
 				   PEER__RECV, &ad);
-		if (err)
+		if (err) {
 			selinux_netlbl_err(skb, err, 0);
+			return err;
+		}
 	}
 
 	if (secmark_active) {
-- 
1.8.3.2

