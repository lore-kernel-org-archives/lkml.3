Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbaHHUqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbaHHUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Pfaff <blp@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 250/259] netlink: Fix handling of error from netlink_dump().
Date: Fri,  8 Aug 2014 13:41:13 -0700
Message-Id: <1407530482-4483-251-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Pfaff <blp@nicira.com>

[ Upstream commit ac30ef832e6af0505b6f0251a6659adcfa74975e ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netlink/af_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index ba45917..ab68a92e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -628,7 +628,7 @@ static unsigned int netlink_poll(struct file *file, struct socket *sock,
 		while (nlk->cb_running && netlink_dump_space(nlk)) {
 			err = netlink_dump(sk);
 			if (err < 0) {
-				sk->sk_err = err;
+				sk->sk_err = -err;
 				sk->sk_error_report(sk);
 				break;
 			}
@@ -2440,7 +2440,7 @@ static int netlink_recvmsg(struct kiocb *kiocb, struct socket *sock,
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
 		ret = netlink_dump(sk);
 		if (ret) {
-			sk->sk_err = ret;
+			sk->sk_err = -ret;
 			sk->sk_error_report(sk);
 		}
 	}
-- 
1.9.1

