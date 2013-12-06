Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3LFV7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:59:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562Ab3LFVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 12/32] net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
Date: Fri,  6 Dec 2013 13:52:22 -0800
Message-Id: <20131206214957.972280229@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 68c6beb373955da0886d8f4f5995b3922ceda4be ]

In that case it is probable that kernel code overwrote part of the
stack. So we should bail out loudly here.

The BUG_ON may be removed in future if we are sure all protocols are
conformant.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -215,12 +215,13 @@ static int move_addr_to_user(struct sock
 	int err;
 	int len;
 
+	BUG_ON(klen > sizeof(struct sockaddr_storage));
 	err = get_user(len, ulen);
 	if (err)
 		return err;
 	if (len > klen)
 		len = klen;
-	if (len < 0 || len > sizeof(struct sockaddr_storage))
+	if (len < 0)
 		return -EINVAL;
 	if (len) {
 		if (audit_sockaddr(klen, kaddr))


