Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaKFXYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaKFWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/162] netlink: reset network header before passing to taps
Date: Thu,  6 Nov 2014 14:34:25 -0800
Message-Id: <1415313426-9622-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dbba678..cb5b7e0 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -204,7 +204,7 @@ static int __netlink_deliver_tap_skb(struct sk_buff *skb,
 	if (nskb) {
 		nskb->dev = dev;
 		nskb->protocol = htons((u16) sk->sk_protocol);
-
+		skb_reset_network_header(nskb);
 		ret = dev_queue_xmit(nskb);
 		if (unlikely(ret > 0))
 			ret = net_xmit_errno(ret);
-- 
1.9.1

