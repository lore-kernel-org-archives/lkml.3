Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKGKeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:34:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:40881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKGKeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:34:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="633217738"
Message-ID: <1415356480.958.315.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] UBIFS: fix a couple bugs in UBIFS xattr length
 calculation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri, 07 Nov 2014 12:34:40 +0200
In-Reply-To: <1414781431-2911-2-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-2-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> From: Subodh Nijsure <snijsure@grid-net.com>
> 
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ben Shelton <ben.shelton@ni.com>
> Acked-by: Brad Mouring <brad.mouring@ni.com>
> Acked-by: Gratian Crisan <gratian.crisan@ni.com>

It looks like these patches are against an old kernel. In the new kernel
"dir_ui" was renamed to "host_ui", to show that this is not just a
directory inode, but a directory or an xattr inode (we call the "host"
inodes, since the "host" the xattr value).

I've pushed this patch in a modified form.

Do you have a possibility to test this series with a newer kernel?

Here is the patch I pushed:


>From a76284e6f89b2ae37d413fe793752257be01765a Mon Sep 17 00:00:00 2001
From: Subodh Nijsure <snijsure@grid-net.com>
Date: Fri, 31 Oct 2014 13:50:28 -0500
Subject: [PATCH] UBIFS: fix a couple bugs in UBIFS xattr length calculation

The journal update function did not work for extended attributes properly,
because extended attribute inodes carry the xattr data, and the size of this
data was not taken into account.

Artem: improved commit message, amended the patch a bit.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Shelton <ben.shelton@ni.com>
Acked-by: Brad Mouring <brad.mouring@ni.com>
Acked-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ubifs/journal.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index fb166e2..f6ac3f2 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -571,7 +571,11 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	aligned_dlen = ALIGN(dlen, 8);
 	aligned_ilen = ALIGN(ilen, 8);
+
 	len = aligned_dlen + aligned_ilen + UBIFS_INO_NODE_SZ;
+	/* Make sure to also account for extended attributes */
+	len += host_ui->data_len;
+
 	dent = kmalloc(len, GFP_NOFS);
 	if (!dent)
 		return -ENOMEM;
@@ -648,7 +652,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	ino_key_init(c, &ino_key, dir->i_ino);
 	ino_offs += aligned_ilen;
-	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs,
+			    UBIFS_INO_NODE_SZ + host_ui->data_len);
 	if (err)
 		goto out_ro;
 
-- 
1.9.3

Artem.

