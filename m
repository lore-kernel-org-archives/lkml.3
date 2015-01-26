Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbbAZFlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:41:37 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:25903 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbAZFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:41:35 -0500
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 26 Jan 2015 06:41:33 +0100
X-ME-IP: 92.140.225.99
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: omap: Free memory in error path
Date: Mon, 26 Jan 2015 06:40:58 +0100
Message-Id: <1422250858-22516-1-git-send-email-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.1.0
X-Antivirus: avast! (VPS 150125-1, 25/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If only one of the 2 __get_free_pages fails, then there is a memory leak

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/omap-aes.c | 2 ++
 drivers/crypto/omap-des.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index f79dd41..c2f9333 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -577,6 +577,8 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
 
 	if (!buf_in || !buf_out) {
+		free_page((unsigned long)buf_out);
+		free_page((unsigned long)buf_in);
 		pr_err("Couldn't allocated pages for unaligned cases.\n");
 		return -1;
 	}
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 0b8dcf5..a2f6ca1 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -570,6 +570,8 @@ static int omap_des_copy_sgs(struct omap_des_dev *dd)
 	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
 
 	if (!buf_in || !buf_out) {
+		free_page((unsigned long)buf_out);
+		free_page((unsigned long)buf_in);
 		pr_err("Couldn't allocated pages for unaligned cases.\n");
 		return -1;
 	}
-- 
2.1.0

