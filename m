Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab3B0AJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459Ab3B0AJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 77/86] sock_diag: Fix out-of-bounds access to sock_diag_handlers[]
Date: Tue, 26 Feb 2013 16:08:25 -0800
Message-Id: <20130226235920.914226168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 6e601a53566d84e1ffd25e7b6fe0b6894ffd79c0 ]

Userland can send a netlink message requesting SOCK_DIAG_BY_FAMILY
with a family greater or equal then AF_MAX -- the array size of
sock_diag_handlers[]. The current code does not test for this
condition therefore is vulnerable to an out-of-bound access opening
doors for a privilege escalation.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_diag.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -126,6 +126,9 @@ static int __sock_diag_rcv_msg(struct sk
 	if (nlmsg_len(nlh) < sizeof(*req))
 		return -EINVAL;
 
+	if (req->sdiag_family >= AF_MAX)
+		return -EINVAL;
+
 	hndl = sock_diag_lock_handler(req->sdiag_family);
 	if (hndl == NULL)
 		err = -ENOENT;


