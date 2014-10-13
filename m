Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaJMC6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:58:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaJMC0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 01/37] netlink: reset network header before passing to taps
Date: Mon, 13 Oct 2014 04:23:58 +0200
Message-Id: <20141013022400.342657247@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 4e48ed883c72e78c5a910f8831ffe90c9b18f0ec ]

netlink doesn't set any network header offset thus when the skb is
being passed to tap devices via dev_queue_xmit_nit(), it emits klog
false positives due to it being unset like:

  ...
  [  124.990397] protocol 0000 is buggy, dev nlmon0
  [  124.990411] protocol 0000 is buggy, dev nlmon0
  ...

So just reset the network header before passing to the device; for
packet sockets that just means nothing will change - mac and net
offset hold the same value just as before.

Reported-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -205,7 +205,7 @@ static int __netlink_deliver_tap_skb(str
 		nskb->protocol = htons((u16) sk->sk_protocol);
 		nskb->pkt_type = netlink_is_kernel(sk) ?
 				 PACKET_KERNEL : PACKET_USER;
-
+		skb_reset_network_header(nskb);
 		ret = dev_queue_xmit(nskb);
 		if (unlikely(ret > 0))
 			ret = net_xmit_errno(ret);


