Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaKRPL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:11:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbaKROJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:34 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/206] fix misuses of f_count() in ppp and netlink
Date: Tue, 18 Nov 2014 15:07:10 +0100
Message-Id: <ec84c5e8a19be56aa297f195885e0303a956230f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 24dff96a37a2ca319e75a74d3929b2de22447ca6 upstream.

we used to check for "nobody else could start doing anything with
that opened file" by checking that refcount was 2 or less - one
for descriptor table and one we'd acquired in fget() on the way to
wherever we are.  That was race-prone (somebody else might have
had a reference to descriptor table and do fget() just as we'd
been checking) and it had become flat-out incorrect back when
we switched to fget_light() on those codepaths - unlike fget(),
it doesn't grab an extra reference unless the descriptor table
is shared.  The same change allowed a race-free check, though -
we are safe exactly when refcount is less than 2.

It was a long time ago; pre-2.6.12 for ioctl() (the codepath leading
to ppp one) and 2.6.17 for sendmsg() (netlink one).  OTOH,
netlink hadn't grown that check until 3.9 and ppp used to live
in drivers/net, not drivers/net/ppp until 3.1.  The bug existed
well before that, though, and the same fix used to apply in old
location of file.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 net/netlink/af_netlink.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 72ff14b811c6..5a1897d86e94 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -601,7 +601,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (file == ppp->owner)
 				ppp_shutdown_interface(ppp);
 		}
-		if (atomic_long_read(&file->f_count) <= 2) {
+		if (atomic_long_read(&file->f_count) < 2) {
 			ppp_release(NULL, file);
 			err = 0;
 		} else
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 2a4f35e7b5c0..2735facbbf91 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -699,7 +699,7 @@ static int netlink_mmap_sendmsg(struct sock *sk, struct msghdr *msg,
 	 * after validation, the socket and the ring may only be used by a
 	 * single process, otherwise we fall back to copying.
 	 */
-	if (atomic_long_read(&sk->sk_socket->file->f_count) > 2 ||
+	if (atomic_long_read(&sk->sk_socket->file->f_count) > 1 ||
 	    atomic_read(&nlk->mapped) > 1)
 		excl = false;
 
-- 
2.1.3

