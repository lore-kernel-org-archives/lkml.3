Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaAMQnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:43:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaAMQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chad Hanson <chanson@trustedcs.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 087/208] selinux: fix broken peer recv check
Date: Mon, 13 Jan 2014 15:58:48 +0000
Message-Id: <1389628849-1614-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Hanson <chanson@trustedcs.com>

commit 46d01d63221c3508421dd72ff9c879f61053cffc upstream.

Fix a broken networking check. Return an error if peer recv fails.  If
secmark is active and the packet recv succeeds the peer recv error is
ignored.

Signed-off-by: Chad Hanson <chanson@trustedcs.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/selinux/hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index cba582c..122b956 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4303,8 +4303,10 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
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

