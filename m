Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaBLIb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:31:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50135 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbaBLIN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chad Hanson" <chanson@trustedcs.com>,
        "Paul Moore" <pmoore@redhat.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.629116664@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 58/79] selinux: fix broken peer recv check
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Hanson <chanson@trustedcs.com>

commit 46d01d63221c3508421dd72ff9c879f61053cffc upstream.

Fix a broken networking check. Return an error if peer recv fails.  If
secmark is active and the packet recv succeeds the peer recv error is
ignored.

Signed-off-by: Chad Hanson <chanson@trustedcs.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4181,8 +4181,10 @@ static int selinux_socket_sock_rcv_skb(s
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

