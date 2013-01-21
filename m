Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3AUMDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:03:20 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56523
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab3AUMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187838"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/15] drivers/crypto/atmel-aes.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:51 +0100
Message-Id: <1358773378-4700-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  The code tested the result
of a previous allocation, that itself was already tested.  It is changed to
test the result of the most recent allocation.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
    when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/crypto/atmel-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index c9d9d5c..6f22ba5 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -332,7 +332,7 @@ static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 		return -EINVAL;
 
 	dd->nb_out_sg = atmel_aes_sg_length(dd->req, dd->out_sg);
-	if (!dd->nb_in_sg)
+	if (!dd->nb_out_sg)
 		return -EINVAL;
 
 	dd->bufcnt = sg_copy_to_buffer(dd->in_sg, dd->nb_in_sg,

