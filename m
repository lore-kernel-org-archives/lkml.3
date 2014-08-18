Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaHRJ6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:58:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaHRJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Pfaff <blp@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/137] netlink: Fix handling of error from netlink_dump().
Date: Mon, 18 Aug 2014 10:31:52 +0100
Message-Id: <1408354398-10226-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Pfaff <blp@nicira.com>

commit ac30ef832e6af0505b6f0251a6659adcfa74975e upstream.

netlink_dump() returns a negative errno value on error.  Until now,
netlink_recvmsg() directly recorded that negative value in sk->sk_err, but
that's wrong since sk_err takes positive errno values.  (This manifests as
userspace receiving a positive return value from the recv() system call,
falsely indicating success.) This bug was introduced in the commit that
started checking the netlink_dump() return value, commit b44d211 (netlink:
handle errors from netlink_dump()).

Multithreaded Netlink dumps are one way to trigger this behavior in
practice, as described in the commit message for the userspace workaround
posted here:
    http://openvswitch.org/pipermail/dev/2014-June/042339.html

This commit also fixes the same bug in netlink_poll(), introduced in commit
cd1df525d (netlink: add flow control for memory mapped I/O).

Signed-off-by: Ben Pfaff <blp@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlink/af_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7bbc40b63aa4..4a8948b08d1b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -598,7 +598,7 @@ static unsigned int netlink_poll(struct file *file, struct socket *sock,
 		while (nlk->cb != NULL && netlink_dump_space(nlk)) {
 			err = netlink_dump(sk);
 			if (err < 0) {
-				sk->sk_err = err;
+				sk->sk_err = -err;
 				sk->sk_error_report(sk);
 				break;
 			}
@@ -2421,7 +2421,7 @@ static int netlink_recvmsg(struct kiocb *kiocb, struct socket *sock,
 	if (nlk->cb && atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
 		ret = netlink_dump(sk);
 		if (ret) {
-			sk->sk_err = ret;
+			sk->sk_err = -ret;
 			sk->sk_error_report(sk);
 		}
 	}
-- 
1.9.1

