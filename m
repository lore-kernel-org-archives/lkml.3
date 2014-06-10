Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936119AbaFJA2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:28:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934621AbaFJAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 71/88] target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
Date: Mon,  9 Jun 2014 17:25:21 -0700
Message-Id: <20140610002426.831923318@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 40ff2c3b3da35dd3a00ac6722056a59b4b3f2caf upstream.

This patch changes vectored file I/O to use kmap + kunmap when mapping
incoming SGL memory -> struct iovec in order to properly support 32-bit
highmem configurations.  This is because an extra bounce buffer may be
required when processing scatterlist pages allocated with GFP_KERNEL.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: use task->task_sg{,_nents} for iteration]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_file.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -299,7 +299,7 @@ static int fd_do_readv(struct se_task *t
 
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -307,6 +307,8 @@ static int fd_do_readv(struct se_task *t
 	ret = vfs_readv(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
 	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
@@ -352,7 +354,7 @@ static int fd_do_writev(struct se_task *
 
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -360,6 +362,9 @@ static int fd_do_writev(struct se_task *
 	ret = vfs_writev(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
+
 	kfree(iov);
 
 	if (ret < 0 || ret != task->task_size) {


