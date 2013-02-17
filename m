Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3BQWzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45676 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164Ab3BQWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:21 -0500
Message-Id: <20130217225008.019470014@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Borkmann <dborkman@redhat.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 55/66] net: sctp: sctp_endpoint_free: zero out secret key  data
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit b5c37fe6e24eec194bb29d22fdd55d73bcc709bf ]

On sctp_endpoint_destroy, previously used sensitive keying material
should be zeroed out before the memory is returned, as we already do
with e.g. auth keys when released.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/endpointola.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index c8cc24e..dbe5870a 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -248,6 +248,8 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 /* Final destructor for endpoint.  */
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
+	int i;
+
 	SCTP_ASSERT(ep->base.dead, "Endpoint is not dead", return);
 
 	/* Free up the HMAC transform. */
@@ -270,6 +272,9 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	sctp_inq_free(&ep->base.inqueue);
 	sctp_bind_addr_free(&ep->base.bind_addr);
 
+	for (i = 0; i < SCTP_HOW_MANY_SECRETS; ++i)
+		memset(&ep->secret_key[i], 0, SCTP_SECRET_SIZE);
+
 	/* Remove and free the port */
 	if (sctp_sk(ep->base.sk)->bind_hash)
 		sctp_put_port(ep->base.sk);


