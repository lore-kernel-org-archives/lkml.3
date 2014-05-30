Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbaE3UNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:13:07 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3UKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 28/32] adfs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:52 +0200
Message-Id: <1401480116-1973111-29-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:61oYr20kuw0zDkJaZrBqBJRJkx2q90D0lbXc4dzfUiN
 s2ieoa6KdFEFhcnKO3Bh7LMrLbLPkkbNSg9l0F7YvdS5k6+lOb
 xfawfjP50HPDpc3DuXSqZGyX77BmiUJ4E5+MtBAEUksCX3K2LS
 rgk8x80UC2xHjGYmoB/zZlVKPfKSFTBYgMCDjHdYo6KG2xPlZF
 6FB6HHF9oCwyZpPDVeqmXQoDDiOs4Gg8ZDZxGqSKs2jQq08n2J
 G07qsKPhCx4cX48fAJua7a9ZUYaD6DNQVxjsli9AMU5WBYbmYr
 Nwjkv+qXxE3W7ztM5JbjiBNdiS4wAXRYgbZp37EoyQUH0a6LKQ
 EJX/sAcxGtQPyea1CE2WZFbnYZ9LcKlbJ3zjcGvVv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adfs uses unsigned 40-bit seconds for inode timestamps, which will work
for the next 234 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in adfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/adfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index b9acada..5698b9e 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -167,7 +167,7 @@ adfs_mode2atts(struct super_block *sb, struct inode *inode)
  * of time to convert from RISC OS epoch to Unix epoch.
  */
 static void
-adfs_adfs2unix_time(struct timespec *tv, struct inode *inode)
+adfs_adfs2unix_time(struct inode_time *tv, struct inode *inode)
 {
 	unsigned int high, low;
 	/* 01 Jan 1970 00:00:00 (Unix epoch) as nanoseconds since
@@ -195,7 +195,7 @@ adfs_adfs2unix_time(struct timespec *tv, struct inode *inode)
 	/* convert from RISC OS to Unix epoch */
 	nsec -= nsec_unix_epoch_diff_risc_os_epoch;
 
-	*tv = ns_to_timespec(nsec);
+	*tv = ns_to_inode_time(nsec);
 	return;
 
  cur_time:
-- 
1.8.3.2

