Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaJCJLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:11:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJCJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:06 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-27-542e67eb1c34
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 3/4] module: search the key only by keyid
Date: Fri, 03 Oct 2014 12:09:56 +0300
Message-id: <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xq7pv0vVCDJ7NZ7W49Xcvs8W7pt8s
	Fl+W1lmsW7+YyWL2rocsFi9nzGO3uLxrDpvFh55HbBY3p11gsfi0YhKzA5fHzll32T2mnVjG
	4vHg0GYWj90LPjN59HxP9ni/7yqbx4oNJ5g9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK+PL
	90OMBYe5Ku63LWNvYFzC0cXIySEhYCKx8tYnJghbTOLCvfVsXYxcHEICSxkltr1ZDZYQEuhk
	kvj5Qg3EZhPQk9jQ/IMdpEhE4CijxLQz11lBEswC6RKfJvUCJTg4hAUsJVbPVAYJswioSqx5
	shOshFcgTuJf5wNGiGVyEiePTQaLcwpYSWy5uoENYpelxPr+Fey4xCcw8i9gZFjFKJpamlxQ
	nJSea6hXnJhbXJqXrpecn7uJERLGX3YwLj5mdYhRgINRiYf34w3dECHWxLLiytxDjBIczEoi
	vKfj9EKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MAbxJ5jduWtzMfhTJVuBuEHzmacxwiYXLCUu
	h9bf9vuyaDXTAqmnO1zDJaaoCdZalB+49r7kd3jzh5XSfz7diVt8r/bup/MGb5cWN5suKfR/
	svBAnsn+X5N2/L8137Qg2+HrTKXdixdcCddY/pwlUcx/Te8Lv76onTWFpRP2TpnIsfJP9bsJ
	ydxKLMUZiYZazEXFiQBsi3AqQQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest KEYS code change the way keys identified and module
signing keys are not searchable anymore with original id.

This patch fixes this problem without change module signature
data.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 kernel/module_signing.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index be5b8fa..f329de8 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -134,26 +134,20 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 					  const u8 *key_id, size_t key_id_len)
 {
 	key_ref_t key;
-	size_t i;
 	char *id, *q;
 
 	pr_devel("==>%s(,%zu,,%zu)\n", __func__, signer_len, key_id_len);
 
 	/* Construct an identifier. */
-	id = kmalloc(signer_len + 2 + key_id_len * 2 + 1, GFP_KERNEL);
+	id = kmalloc(2 + 1 + key_id_len * 2 + 1, GFP_KERNEL);
 	if (!id)
 		return ERR_PTR(-ENOKEY);
 
-	memcpy(id, signer, signer_len);
-
-	q = id + signer_len;
+	q = id;
+	*q++ = 'i';
+	*q++ = 'd';
 	*q++ = ':';
-	*q++ = ' ';
-	for (i = 0; i < key_id_len; i++) {
-		*q++ = hex_asc[*key_id >> 4];
-		*q++ = hex_asc[*key_id++ & 0x0f];
-	}
-
+	q = bin2hex(q, key_id, key_id_len);
 	*q = 0;
 
 	pr_debug("Look up: \"%s\"\n", id);
-- 
1.9.1

