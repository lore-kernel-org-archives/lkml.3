Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3BMKXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:23:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab3BMKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:35 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RFC 1/5] UBIFS: xattr: protect ui_size and data_len by ui_mutex
Date: Wed, 13 Feb 2013 11:23:14 +0100
Message-Id: <1360750998-15191-2-git-send-email-mkl@pengutronix.de>
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

This patch moves the modification of ui->ui_size and ui->data_len in the
create_xattr() and change_xattr() functions, so that they are protected by the
ui_mutex as stated in the documenation of the the struct ubifs_inode.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 fs/ubifs/xattr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 0f7139b..1395307 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -143,10 +143,10 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 		err = -ENOMEM;
 		goto out_free;
 	}
-	inode->i_size = ui->ui_size = size;
-	ui->data_len = size;
 
 	mutex_lock(&host_ui->ui_mutex);
+	inode->i_size = ui->ui_size = size;
+	ui->data_len = size;
 	host->i_ctime = ubifs_current_time(host);
 	host_ui->xattr_cnt += 1;
 	host_ui->xattr_size += CALC_DENT_SIZE(nm->len);
@@ -208,10 +208,10 @@ static int change_xattr(struct ubifs_info *c, struct inode *host,
 		err = -ENOMEM;
 		goto out_free;
 	}
-	inode->i_size = ui->ui_size = size;
-	ui->data_len = size;
 
 	mutex_lock(&host_ui->ui_mutex);
+	inode->i_size = ui->ui_size = size;
+	ui->data_len = size;
 	host->i_ctime = ubifs_current_time(host);
 	host_ui->xattr_size -= CALC_XATTR_BYTES(ui->data_len);
 	host_ui->xattr_size += CALC_XATTR_BYTES(size);
-- 
1.7.10.4

