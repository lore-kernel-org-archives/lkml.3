Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab3APQCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3APQCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 081/222] target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
Date: Wed, 16 Jan 2013 13:54:41 -0200
Message-Id: <1358351822-7675-82-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 40ff2c3b3da35dd3a00ac6722056a59b4b3f2caf upstream.

This patch changes vectored file I/O to use kmap + kunmap when mapping
incoming SGL memory -> struct iovec in order to properly support 32-bit
highmem configurations.  This is because an extra bounce buffer may be
required when processing scatterlist pages allocated with GFP_KERNEL.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_file.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index c0d6e6d..d2414e9 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -279,7 +279,7 @@ static int fd_do_readv(struct se_cmd *cmd, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -287,6 +287,8 @@ static int fd_do_readv(struct se_cmd *cmd, struct scatterlist *sgl,
 	ret = vfs_readv(fd, &iov[0], sgl_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(sgl, sg, sgl_nents, i)
+		kunmap(sg_page(sg));
 	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
@@ -332,7 +334,7 @@ static int fd_do_writev(struct se_cmd *cmd, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -340,6 +342,9 @@ static int fd_do_writev(struct se_cmd *cmd, struct scatterlist *sgl,
 	ret = vfs_writev(fd, &iov[0], sgl_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(sgl, sg, sgl_nents, i)
+		kunmap(sg_page(sg));
+
 	kfree(iov);
 
 	if (ret < 0 || ret != cmd->data_length) {
-- 
1.7.9.5

