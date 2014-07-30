Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaG3M3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:29:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36752 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Pfaff <blp@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 50/94] netlink: Fix handling of error from netlink_dump().
Date: Wed, 30 Jul 2014 14:14:39 +0200
Message-Id: <8df19ce788d3d18eb4054862daa55a7ee4c883b0.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Pfaff <blp@nicira.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netlink/af_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e6d457c4a4e4..d9a2598a5190 100644
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
2.0.1

