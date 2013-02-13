Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab3BMKXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:23:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39162 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3BMKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:36 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RFC 2/5] UBIFS: fix couple bugs in UBIFS extended attribute length calculation
Date: Wed, 13 Feb 2013 11:23:15 +0100
Message-Id: <1360750998-15191-3-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 fs/ubifs/journal.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index afaad07..6981d7d 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -572,7 +572,12 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	aligned_dlen = ALIGN(dlen, 8);
 	aligned_ilen = ALIGN(ilen, 8);
-	len = aligned_dlen + aligned_ilen + UBIFS_INO_NODE_SZ;
+	/*
+	 * Make sure to account for dir_ui+data_len in length
+	 * calculation in case there is extended attribute.
+	 */
+	len = aligned_dlen + aligned_ilen +
+	      UBIFS_INO_NODE_SZ + dir_ui->data_len;
 	dent = kmalloc(len, GFP_NOFS);
 	if (!dent)
 		return -ENOMEM;
@@ -649,7 +654,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	ino_key_init(c, &ino_key, dir->i_ino);
 	ino_offs += aligned_ilen;
-	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs,
+			    UBIFS_INO_NODE_SZ + dir_ui->data_len);
 	if (err)
 		goto out_ro;
 
-- 
1.7.10.4

