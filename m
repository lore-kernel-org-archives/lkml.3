Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3FDXGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:06:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35590 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3FDWmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:52 -0400
Message-Id: <20130604172137.140310447@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 165/184] net: sctp: sctp_endpoint_free: zero out secret key
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 data

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit b5c37fe6e24eec194bb29d22fdd55d73bcc709bf ]

On sctp_endpoint_destroy, previously used sensitive keying material
should be zeroed out before the memory is returned, as we already do
with e.g. auth keys when released.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/endpointola.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 905fda5..ca48660 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -249,6 +249,8 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 /* Final destructor for endpoint.  */
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
+	int i;
+
 	SCTP_ASSERT(ep->base.dead, "Endpoint is not dead", return);
 
 	/* Free up the HMAC transform. */
@@ -271,6 +273,9 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	sctp_inq_free(&ep->base.inqueue);
 	sctp_bind_addr_free(&ep->base.bind_addr);
 
+	for (i = 0; i < SCTP_HOW_MANY_SECRETS; ++i)
+		memset(&ep->secret_key[i], 0, SCTP_SECRET_SIZE);
+
 	/* Remove and free the port */
 	if (sctp_sk(ep->base.sk)->bind_hash)
 		sctp_put_port(ep->base.sk);
-- 
1.7.12.2.21.g234cd45.dirty



