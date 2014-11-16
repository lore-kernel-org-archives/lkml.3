Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaKPWAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:36 -0500
Received: from 1wt.eu ([62.212.114.60]:47864 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKPWAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:32 -0500
Message-Id: <20141116215329.021276432@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Xufeng Zhang <xufeng.zhang@windriver.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 09/48] sctp: Fix sk_ack_backlog wrap-around problem
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

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
(cherry picked from commit d3217b15a19a4779c39b212358a5c71d725822ee)
[wt: fixes CVE-2014-4667]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 7eed77a..55b015b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -380,7 +380,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Only real associations count against the endpoint, so
 	 * don't bother for if this is a temporary association.
 	 */
-	if (!asoc->temp) {
+	if (!list_empty(&asoc->asocs)) {
 		list_del(&asoc->asocs);
 
 		/* Decrement the backlog value for a TCP-style listening
-- 
1.7.12.2.21.g234cd45.dirty



