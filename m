Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbbAYSIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:08:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbAYSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 02/50] netlink: Dont reorder loads/stores before marking mmap netlink frame as available
Date: Sun, 25 Jan 2015 10:06:52 -0800
Message-Id: <20150125180702.728480090@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -399,9 +399,9 @@ static enum nl_mmap_status netlink_get_s
 static void netlink_set_status(struct nl_mmap_hdr *hdr,
 			       enum nl_mmap_status status)
 {
+	smp_mb();
 	hdr->nm_status = status;
 	flush_dcache_page(pgvec_to_page(hdr));
-	smp_wmb();
 }
 
 static struct nl_mmap_hdr *


