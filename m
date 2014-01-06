Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaAFXem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:34:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbaAFWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chad Hanson <chanson@trustedcs.com>, Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.10 019/129] selinux: fix broken peer recv check
Date: Mon,  6 Jan 2014 14:37:28 -0800
Message-Id: <20140106223900.142403683@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Hanson <chanson@trustedcs.com>

commit 46d01d63221c3508421dd72ff9c879f61053cffc upstream.

Fix a broken networking check. Return an error if peer recv fails.  If
secmark is active and the packet recv succeeds the peer recv error is
ignored.

Signed-off-by: Chad Hanson <chanson@trustedcs.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4228,8 +4228,10 @@ static int selinux_socket_sock_rcv_skb(s
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


