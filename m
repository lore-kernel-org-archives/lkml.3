Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3AOW2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:41319 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab3AOW2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 048/221] target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
Date: Tue, 15 Jan 2013 10:49:35 -0800
Message-Id: <20130115185001.500186170@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 40ff2c3b3da35dd3a00ac6722056a59b4b3f2caf upstream.

This patch changes vectored file I/O to use kmap + kunmap when mapping
incoming SGL memory -> struct iovec in order to properly support 32-bit
highmem configurations.  This is because an extra bounce buffer may be
required when processing scatterlist pages allocated with GFP_KERNEL.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_file.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -260,7 +260,7 @@ static int fd_do_readv(struct se_cmd *cm
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -268,6 +268,8 @@ static int fd_do_readv(struct se_cmd *cm
 	ret = vfs_readv(fd, &iov[0], sgl_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(sgl, sg, sgl_nents, i)
+		kunmap(sg_page(sg));
 	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
@@ -313,7 +315,7 @@ static int fd_do_writev(struct se_cmd *c
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -321,6 +323,9 @@ static int fd_do_writev(struct se_cmd *c
 	ret = vfs_writev(fd, &iov[0], sgl_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(sgl, sg, sgl_nents, i)
+		kunmap(sg_page(sg));
+
 	kfree(iov);
 
 	if (ret < 0 || ret != cmd->data_length) {


