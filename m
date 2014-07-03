Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203AbaGCJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:42:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030360AbaGCJYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xufeng Zhang <xufeng.zhang@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 149/198] sctp: Fix sk_ack_backlog wrap-around problem
Date: Thu,  3 Jul 2014 10:19:52 +0100
Message-Id: <1404379241-8590-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

commit d3217b15a19a4779c39b212358a5c71d725822ee upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index ab67efc64b24..619c781e6691 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -381,7 +381,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Only real associations count against the endpoint, so
 	 * don't bother for if this is a temporary association.
 	 */
-	if (!asoc->temp) {
+	if (!list_empty(&asoc->asocs)) {
 		list_del(&asoc->asocs);
 
 		/* Decrement the backlog value for a TCP-style listening
-- 
1.9.1

