Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaICHX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:27 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8822 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbaICHXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ce-5406c1e18447
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/8] integrity: prevent flooding with 'Request for unknown key'
Date: Wed, 03 Sep 2014 10:19:54 +0300
Message-id: <e0ddf36b22e77b6ec7344cb58f587345dd7b0fe4.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Vd2HB9lCDOb95bC49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBmN246xFGziqmh/foOxgfE0RxcjB4eEgInE3C6zLkZOIFNM4sK99WxdjFwc
	QgJLGSWWLehkgXA6mSQO/mpgAqliE9CT2ND8gx3EFhHIkZh05gIziM0skC7xaVIvWFxYwF/i
	8c02NhCbRUBVYl7vBjCbVyBO4trEfewQ2+QkTh6bzApyBKeAlcS8o1ogYSEBS4n2q8sYcQhP
	YORfwMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMk6L7sYFx8zOoQowAHoxIPb4EaW4gQ
	a2JZcWXuIUYJDmYlEV7fRKAQb0piZVVqUX58UWlOavEhRiYOTqkGRp6Gi703Dn/f4nTwo6Do
	hkuGnMo5KcJR9js1rktd7IiXVn/sp3o1IbX1xGX+ZKviU80yF7LcT7BG9mReZ3ol6OJo2bfn
	8h/HR82bGrkkMx9LL7r5vMVS+MK6WqaSlTf2+1y9EqPgmPtj+bENVqdNTPadnzRv2p31U+Si
	20RSs97fnaJ4+rI3qxJLcUaioRZzUXEiAAZKfb8YAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If file has IMA signature, IMA in enforce mode, but key is missing
then file access is blocked and single error message is printed.

If IMA appraisal is enabled in fix mode, then system runs as usual
but might produce tons of 'Request for unknown key' messages.

This patch switches 'pr_warn' to 'pr_err_ratelimited'.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/digsig_asymmetric.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 9eae480..37e0d98 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
+#include <linux/ratelimit.h>
 #include <linux/key-type.h>
 #include <crypto/public_key.h>
 #include <keys/asymmetric-type.h>
@@ -45,8 +46,8 @@ static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
 	}
 
 	if (IS_ERR(key)) {
-		pr_warn("Request for unknown key '%s' err %ld\n",
-			name, PTR_ERR(key));
+		pr_err_ratelimited("Request for unknown key '%s' err %ld\n",
+				   name, PTR_ERR(key));
 		switch (PTR_ERR(key)) {
 			/* Hide some search errors */
 		case -EACCES:
-- 
1.9.1

