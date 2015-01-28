Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbbA2KW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:22:59 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756097AbbA2JAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/176] netlink: Don't reorder loads/stores before marking mmap netlink frame as available
Date: Wed, 28 Jan 2015 15:28:08 +0100
Message-Id: <d7ab02d6e980a50530a2f92056b653de1c114285.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a18e6a186f53af06937a2c268c72443336f4ab56 ]

Each mmap Netlink frame contains a status field which indicates
whether the frame is unused, reserved, contains data or needs to
be skipped. Both loads and stores may not be reordeded and must
complete before the status field is changed and another CPU might
pick up the frame for use. Use an smp_mb() to cover needs of both
types of callers to netlink_set_status(), callers which have been
reading data frame from the frame, and callers which have been
filling or releasing and thus writing to the frame.

- Example code path requiring a smp_rmb():
  memcpy(skb->data, (void *)hdr + NL_MMAP_HDRLEN, hdr->nm_len);
  netlink_set_status(hdr, NL_MMAP_STATUS_UNUSED);

- Example code path requiring a smp_wmb():
  hdr->nm_uid	= from_kuid(sk_user_ns(sk), NETLINK_CB(skb).creds.uid);
  hdr->nm_gid	= from_kgid(sk_user_ns(sk), NETLINK_CB(skb).creds.gid);
  netlink_frame_flush_dcache(hdr);
  netlink_set_status(hdr, NL_MMAP_STATUS_VALID);

Fixes: f9c228 ("netlink: implement memory mapped recvmsg()")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9a0dc632354c..00590135dc30 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -527,9 +527,9 @@ static enum nl_mmap_status netlink_get_status(const struct nl_mmap_hdr *hdr)
 static void netlink_set_status(struct nl_mmap_hdr *hdr,
 			       enum nl_mmap_status status)
 {
+	smp_mb();
 	hdr->nm_status = status;
 	flush_dcache_page(pgvec_to_page(hdr));
-	smp_wmb();
 }
 
 static struct nl_mmap_hdr *
-- 
2.2.2

