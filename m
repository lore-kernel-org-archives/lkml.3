Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3CZR6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3CZRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:09 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_v96s5ymXb0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IZ4gI9rKePcA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=vZ5s7cKhAAAA:8 a=b4KrJKo_AAAA:8 a=z2A4b4cbAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=_4rnhAHMDuQA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173604.039066093@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 26/86] net: sctp: sctp_endpoint_free: zero out secret key data
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0026-net-sctp-sctp_endpoint_free-zero-out-secret-key-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit b5c37fe6e24eec194bb29d22fdd55d73bcc709bf ]

On sctp_endpoint_destroy, previously used sensitive keying material
should be zeroed out before the memory is returned, as we already do
with e.g. auth keys when released.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sctp/endpointola.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 68a385d..58cd035 100644
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
-- 
1.7.10.4


