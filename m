Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3CZXLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:11:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3CZXCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Burgess <jason@jacknife2.dns2go.com>,
        Yan Li <elliot.li.tech@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 31/49] cifs: ignore everything in SPNEGO blob after mechTypes
Date: Tue, 26 Mar 2013 16:01:28 -0700
Message-Id: <20130326225842.786215137@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit f853c616883a8de966873a1dab283f1369e275a1 upstream.

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
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/asn1.c |   53 +++++------------------------------------------------
 1 file changed, 5 insertions(+), 48 deletions(-)

--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -614,53 +614,10 @@ decode_negTokenInit(unsigned char *secur
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


