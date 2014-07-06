Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaGFQMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:12:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37487 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaGFQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:12:08 -0400
Date: Sun, 6 Jul 2014 21:42:01 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] powerpc/mpic_msgr: Use kcalloc and correct the argument to
 sizeof
Message-ID: <20140706161201.GA6228@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpic_msgrs has type struct mpic_msgr **, not struct mpic_msgr *, so the
elements of the array should have pointer type, not structure type.
The advantage of kcalloc is, that will prevent integer overflows which
could result from the multiplication of number of elements and size and
it is also a bit nicer to read.

The Coccinelle semantic patch that makes the first change is as follows:

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/powerpc/sysdev/mpic_msgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/mpic_msgr.c b/arch/powerpc/sysdev/mpic_msgr.c
index 2c9b52a..7bdf3cc 100644
--- a/arch/powerpc/sysdev/mpic_msgr.c
+++ b/arch/powerpc/sysdev/mpic_msgr.c
@@ -184,7 +184,7 @@ static int mpic_msgr_probe(struct platform_device *dev)
 		dev_info(&dev->dev, "Found %d message registers\n",
 				mpic_msgr_count);
 
-		mpic_msgrs = kzalloc(sizeof(struct mpic_msgr) * mpic_msgr_count,
+		mpic_msgrs = kcalloc(mpic_msgr_count, sizeof(*mpic_msgrs),
 							 GFP_KERNEL);
 		if (!mpic_msgrs) {
 			dev_err(&dev->dev,
-- 
1.9.1

