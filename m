Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaIUXc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaIUXc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:32:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/10] Check hex2bin()'s return when generating an asymmetric key ID
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22565.1411342339.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Sep 2014 00:32:19 +0100
Message-ID: <22566.1411342339@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it stands, the code to generate an asymmetric key ID prechecks the hex
string it is given whilst determining the length, before it allocates the
buffer for hex2bin() to translate into - which mean that checking the result of
hex2bin() is redundant.

Unfortunately, hex2bin() is marked as __must_check, which means that the
following warning may be generated if the return value isn't checked:

	crypto/asymmetric_keys/asymmetric_type.c: In function
	asymmetric_key_hex_to_key_id:
	crypto/asymmetric_keys/asymmetric_type.c:110: warning: ignoring return
	value of hex2bin, declared with attribute warn_unused_result

The warning can't be avoided by casting the result to void.

Instead, use strlen() to check the length of the string and ignore the fact
that the string might not be entirely valid hex until after the allocation has
been done - in which case we can use the result of hex2bin() for this.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 asymmetric_type.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 718e779a010e..f0f2111d2c66 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -90,15 +90,12 @@ EXPORT_SYMBOL_GPL(asymmetric_match_key_ids);
 struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 {
 	struct asymmetric_key_id *match_id;
-	const char *p;
-	ptrdiff_t hexlen;
+	size_t hexlen;
+	int ret;
 
 	if (!*id)
 		return ERR_PTR(-EINVAL);
-	for (p = id; *p; p++)
-		if (!isxdigit(*p))
-			return ERR_PTR(-EINVAL);
-	hexlen = p - id;
+	hexlen = strlen(id);
 	if (hexlen & 1)
 		return ERR_PTR(-EINVAL);
 
@@ -107,7 +104,11 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 	if (!match_id)
 		return ERR_PTR(-ENOMEM);
 	match_id->len = hexlen / 2;
-	(void)hex2bin(match_id->data, id, hexlen / 2);
+	ret = hex2bin(match_id->data, id, hexlen / 2);
+	if (ret < 0) {
+		kfree(match_id);
+		return ERR_PTR(-EINVAL);
+	}
 	return match_id;
 }
 
