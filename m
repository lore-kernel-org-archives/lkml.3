Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKFFum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:50:42 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57292 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaKFFuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:50:37 -0500
Date: Thu, 6 Nov 2014 13:50:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        Masahide Nakamura <nakam@linux-ipv6.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: ipv4: Use standard iovec primitive in raw_probe_proto_opt
Message-ID: <20141106055023.GA28865@gondor.apana.org.au>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
 <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106032533.GU7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:25:34AM +0000, Al Viro wrote:
>
> 	* there's some really weird stuff in there.  Just what is this
> static int raw_probe_proto_opt(struct flowi4 *fl4, struct msghdr *msg)
> {

It looks like newbie coding that's all.  There's nothing tricky
here as far as I can tell.  We're just trying to fetch the ICMP
header to seed the IPsec lookup.

So how about this rewrite? I'm assuming that you're not going
to get rid of memcpy_fromiovecend/memcpy_toiovecend, if you
are, let me know and I'll redo this with iterators.

ipv4: Use standard iovec primitive in raw_probe_proto_opt

The function raw_probe_proto_opt tries to extract the first two
bytes from the user input in order to seed the IPsec lookup for
ICMP packets.  In doing so it's processing iovec by hand and
overcomplicating things.

This patch replaces the manual iovec processing with a call to
memcpy_fromiovecend.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 739db31..04f67e1 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -422,48 +422,20 @@ error:
 
 static int raw_probe_proto_opt(struct flowi4 *fl4, struct msghdr *msg)
 {
-	struct iovec *iov;
-	u8 __user *type = NULL;
-	u8 __user *code = NULL;
-	int probed = 0;
-	unsigned int i;
+	struct icmphdr icmph;
+	int err;
 
-	if (!msg->msg_iov)
+	if (fl4->flowi4_proto != IPPROTO_ICMP)
 		return 0;
 
-	for (i = 0; i < msg->msg_iovlen; i++) {
-		iov = &msg->msg_iov[i];
-		if (!iov)
-			continue;
-
-		switch (fl4->flowi4_proto) {
-		case IPPROTO_ICMP:
-			/* check if one-byte field is readable or not. */
-			if (iov->iov_base && iov->iov_len < 1)
-				break;
-
-			if (!type) {
-				type = iov->iov_base;
-				/* check if code field is readable or not. */
-				if (iov->iov_len > 1)
-					code = type + 1;
-			} else if (!code)
-				code = iov->iov_base;
-
-			if (type && code) {
-				if (get_user(fl4->fl4_icmp_type, type) ||
-				    get_user(fl4->fl4_icmp_code, code))
-					return -EFAULT;
-				probed = 1;
-			}
-			break;
-		default:
-			probed = 1;
-			break;
-		}
-		if (probed)
-			break;
-	}
+	/* We only need the first two bytes. */
+	err = memcpy_fromiovecend((void *)&icmph, msg->msg_iov, 0, 2);
+	if (err)
+		return err;
+
+	fl4->fl4_icmp_type = icmph.type;
+	fl4->fl4_icmp_code = icmph.code;
+
 	return 0;
 }
 

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
