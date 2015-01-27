Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbbA0MSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbbA0MSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 059/126] netlink: Don't reorder loads/stores before marking mmap netlink frame as available
Date: Tue, 27 Jan 2015 12:16:04 +0000
Message-Id: <1422361031-19364-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit a18e6a186f53af06937a2c268c72443336f4ab56 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 625593d866ac..256ce8b84456 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -535,9 +535,9 @@ static enum nl_mmap_status netlink_get_status(const struct nl_mmap_hdr *hdr)
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
2.1.4

