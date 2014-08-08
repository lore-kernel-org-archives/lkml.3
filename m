Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbaHHWeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:34:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaHHUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xufeng Zhang <xufeng.zhang@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 004/259] sctp: Fix sk_ack_backlog wrap-around problem
Date: Fri,  8 Aug 2014 13:37:07 -0700
Message-Id: <1407530482-4483-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Reference: CVE-2014-4667
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 31ed008..6524fa8 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -372,7 +372,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Only real associations count against the endpoint, so
 	 * don't bother for if this is a temporary association.
 	 */
-	if (!asoc->temp) {
+	if (!list_empty(&asoc->asocs)) {
 		list_del(&asoc->asocs);
 
 		/* Decrement the backlog value for a TCP-style listening
-- 
1.9.1

