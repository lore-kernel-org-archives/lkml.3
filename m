Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3DKUaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:30:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589Ab3DKU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:17 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Du3uu-mxolEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QH-JIuc-jfYA:10 a=20KFwNOVAAAA:8 a=JW8NXBGXAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=0u0nhMPvhaUjrep2UKUA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202555.038484570@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jason Burgess <jason@jacknife2.dns2go.com>,
        Yan Li <elliot.li.tech@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 054/171 ] cifs: ignore everything in SPNEGO blob after mechTypes
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0054-cifs-ignore-everything-in-SPNEGO-blob-after-mechType.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

[ Upstream commit f853c616883a8de966873a1dab283f1369e275a1 ]

We've had several reports of people attempting to mount Windows 8 shares
and getting failures with a return code of -EINVAL. The default sec=
mode changed recently to sec=ntlmssp. With that, we expect and parse a
SPNEGO blob from the server in the NEGOTIATE reply.

The current decode_negTokenInit function first parses all of the
mechTypes and then tries to parse the rest of the negTokenInit reply.
The parser however currently expects a mechListMIC or nothing to follow the
mechTypes, but Windows 8 puts a mechToken field there instead to carry
some info for the new NegoEx stuff.

In practice, we don't do anything with the fields after the mechTypes
anyway so I don't see any real benefit in continuing to parse them.
This patch just has the kernel ignore the fields after the mechTypes.
We'll probably need to reinstate some of this if we ever want to support
NegoEx.

Reported-by: Jason Burgess <jason@jacknife2.dns2go.com>
Reported-by: Yan Li <elliot.li.tech@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/asn1.c |   53 +++++------------------------------------------------
 1 file changed, 5 insertions(+), 48 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index cfd1ce3..1d36db1 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -614,53 +614,10 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 		}
 	}
 
-	/* mechlistMIC */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		/* Check if we have reached the end of the blob, but with
-		   no mechListMic (e.g. NTLMSSP instead of KRB5) */
-		if (ctx.error == ASN1_ERR_DEC_EMPTY)
-			goto decode_negtoken_exit;
-		cFYI(1, "Error decoding last part negTokenInit exit3");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		/* tag = 3 indicating mechListMIC */
-		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-
-	/* sequence */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit5");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
-		   || (tag != ASN1_SEQ)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-	}
-
-	/* sequence of */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit 7");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-
-	/* general string */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit9");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
-		   || (tag != ASN1_GENSTR)) {
-		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
-		return 0;
-	}
-	cFYI(1, "Need to call asn1_octets_decode() function for %s",
-		ctx.pointer);	/* is this UTF-8 or ASCII? */
-decode_negtoken_exit:
+	/*
+	 * We currently ignore anything at the end of the SPNEGO blob after
+	 * the mechTypes have been parsed, since none of that info is
+	 * used at the moment.
+	 */
 	return 1;
 }
-- 
1.7.10.4


