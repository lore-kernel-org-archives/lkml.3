Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaFWJMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:12:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:56207 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbaFWJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:12:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xufeng Zhang <xufeng.zhang@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 108/111] sctp: Fix sk_ack_backlog wrap-around problem
Date: Mon, 23 Jun 2014 10:32:23 +0200
Message-Id: <ddb638e68690ca61959775b262a5ef0719c5c066.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xufeng Zhang <xufeng.zhang@windriver.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit d3217b15a19a4779c39b212358a5c71d725822ee ]

Consider the scenario:
For a TCP-style socket, while processing the COOKIE_ECHO chunk in
sctp_sf_do_5_1D_ce(), after it has passed a series of sanity check,
a new association would be created in sctp_unpack_cookie(), but afterwards,
some processing maybe failed, and sctp_association_free() will be called to
free the previously allocated association, in sctp_association_free(),
sk_ack_backlog value is decremented for this socket, since the initial
value for sk_ack_backlog is 0, after the decrement, it will be 65535,
a wrap-around problem happens, and if we want to establish new associations
afterward in the same socket, ABORT would be triggered since sctp deem the
accept queue as full.
Fix this issue by only decrementing sk_ack_backlog for associations in
the endpoint's list.

Fix-suggested-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index cef509985192..f6d6dcd1f97d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -375,7 +375,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Only real associations count against the endpoint, so
 	 * don't bother for if this is a temporary association.
 	 */
-	if (!asoc->temp) {
+	if (!list_empty(&asoc->asocs)) {
 		list_del(&asoc->asocs);
 
 		/* Decrement the backlog value for a TCP-style listening
-- 
2.0.0

